import 'package:firebaseapi/models/scan_model.dart';
import 'package:firebaseapi/provider/old_plat_form_provider.dart';
import 'package:firebaseapi/services/old_plats_services.dart';
import 'package:firebaseapi/ui/old_input_decorations.dart';
import 'package:firebaseapi/widgets/old_plat_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// Pantalla principal para mostrar y editar un producto

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlatsServices platsServices = Provider.of<PlatsServices>(context);

    return ChangeNotifierProvider(
      create: ( _ ) => PlatFormProvider(platsServices.selectedPlat),
      child: _PlatsScreenBody(platsServices: platsServices)
    );
  }
}

// Esta clase representa el cuerpo principal de la pantalla del form del producto
class _PlatsScreenBody extends StatelessWidget {
  const _PlatsScreenBody({
    Key? key,
    required this.platsServices,
  }) : super(key: key);

  final PlatsServices platsServices;

  @override
  Widget build(BuildContext context) {

    // Obtenemos el provider que contiene el producto temporal
    final productForm = Provider.of<PlatFormProvider>(context);
    final plat = platsServices.selectedPlat;
    final scan = ScanModel(valor: plat.geo);

    return Scaffold(  // refactor -> Extract Widget -> _ProductScreen para generar lo de arriba
      body: SingleChildScrollView(  // Permite que el contenido se pueda desplazar si es muy largo
        child: Column(
          children: [
             // Sección para mostrar la imagen del producto y botones flotantes encima
            Stack( // Stack permite colocar widgets unos encima de otros (como capas)
              children: [
                PlatImage(platsServices.selectedPlat.foto), // Muestra la imagen del producto

                // Botón de "volver atrás"
                Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(), // Navega a la pantalla anterior
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Botón para hacer una foto con la cámara y actualizar la imagen del producto
                Positioned(
                  top: 60,
                  right: 20,
                  child: IconButton(
                    onPressed: () async{
                      // Abre la cámara o la galeria para tomar una foto y obtiene la ruta de la imagen seleccionada.
                      final ImagePicker picker = ImagePicker();

                      // Pick an image.
                      //final XFile? image = await picker.pickImage(source: ImageSource.gallery);

                      // Capture a photo.
                      final XFile? photo = await picker.pickImage(source: ImageSource.camera);

                      // Actualiza la imagen del producto usando productService.updateSelectedImage().
                      platsServices.updateSelectedImage(photo!.path);
                    },

                    icon: Icon(
                      Icons.camera_alt_outlined,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            _ProductForm(), // El formulario para editar nombre, precio y disponibilidad

            // Espacio al final para que no quede pegado al borde
            SizedBox(
              height: 100, // Espacio vacío en la parte inferior
            )
          ],
        ),
      ),

      // Botones flotantes
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
        children: [
          // botón dual, depende de lo que haya.
          FloatingActionButton(
            heroTag: 'btn-scan',
            onPressed: () {
              scan.launch(context); // El mismo ScanModel sabe a dónde llevarte
            },
            child: Icon(
              scan.tipus == 'http' ? Icons.map : Icons.location_on, // Cambiar icono dinámicamente
            ),
          ),

          // Botón a la derecha para guardar
          FloatingActionButton(
              child: platsServices.isSaving //IF
              ? CircularProgressIndicator(color: Colors.white) // true
              : Icon(Icons.save_outlined), // Icono de guardar // false
          
              onPressed: platsServices.isSaving //if
              ? null // Si se está guardando, deshabilita el botón
              : (() async { // false
                //Emmagatzemar producte
                if (!productForm.isValidForm()) { // validamos si el formulario es valido
                  return;
                } else {
                  
                  // llama a uploadImage
                  final String? imageUrl = await platsServices.uploadImage();
          
                  // Si se ha subido una imagen nueva, actualizamos la URL en el producto temporal
                  if (imageUrl != null) {
                    productForm.tempPlat.foto = imageUrl;
                  }
                  // Llama a saveOrCreateProduct() que decide si crear o actualizar
                  // en services/productServices
                  platsServices.saveOrCreateProduct(productForm.tempPlat);
                }
              })),
        ],
      ),
    );
  }
}

// Formulario para editar los datos del producto
class _ProductForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtenemos el provider que contiene el producto temporal
    final productForm = Provider.of<PlatFormProvider>(context);
    final tempProduct = productForm.tempPlat; // Producto a editar

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(), // Estilo del contenedor

        child: Form(
          // Asociamos este formulario al formKey que está en el provider (para validar más adelante)
          key: productForm.formKey, 

          // @autovalidateMode: Para que se pongan los mensajes de error o se quiten de forma automática
          autovalidateMode: AutovalidateMode.onUserInteraction, 
          child: Column(
            children: [
              SizedBox(height: 10),

              // Campo para editar el nombre
              TextFormField(
                initialValue: tempProduct.nom, // Valor inicial (nombre actual)
                onChanged: (value) => tempProduct.nom = value, // Guardamos lo que el usuario escribe
                validator: (value) {
                  if (value == null || value.length < 1)
                    return "El nom es obligatori";
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Nom del producte', 
                    labelText: 'Nom:'), // Campo para el nombre del producto
              ),

              SizedBox(height: 30),

              // Campo para editar el precio
              TextFormField(
                //initialValue: tempProduct.price.toString(),// Precio inicial como texto
                inputFormatters: [
                  // Restringe números con hasta 2 decimales
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^(\d+)?\.?\d{0,2}')
                  ),
                ],
                onChanged: (value) {
                  if (double.tryParse(value) == null) {
                    //tempProduct.price = 0; // Si no es número, se pone 0
                  } else {
                    //tempProduct.price = double.parse(value); // Convierte a número
                  }
                },
                validator: (value) {
                  if (value == null || value.length < 1)
                    return "El nom es obligatori"; // Validación básica
                },
                keyboardType: TextInputType.number, // Muestra teclado numérico
                decoration: InputDecorations.authInputDecoration(
                    hintText: '99€', labelText: 'Preu:'), // Campo para el precio del producto
              ),

              SizedBox(height: 30),

              // Interruptor para indicar si el producto está disponible o no
              SwitchListTile.adaptive(
                value: tempProduct.disponible, // Valor inicial de la disponibilidad
                title: Text('Disponible'), // Título del interruptor
                activeColor: Colors.indigo, // Color cuando el interruptor está activado
                onChanged: (value) {
                  tempProduct.disponible = value;
                  productForm.updateAvailabilityDart(value);
                  //productForm.updateAvailabilityDart(value);
                },
              ),

              SizedBox(height: 30),

            ],
          ),
        ),
      ),
    );
  }

  // Función que devuelve el BoxDecoration para el formulario
  BoxDecoration _buildBoxDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(0, 5),
              blurRadius: 5),
        ],
      );
}