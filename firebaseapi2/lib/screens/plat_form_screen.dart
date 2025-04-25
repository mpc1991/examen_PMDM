import 'package:firebaseapi/services/old_plats_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Pantalla principal para mostrar y editar un producto

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlatsServices platsServices = Provider.of<PlatsServices>(context);

    return ChangeNotifierProvider(
      create: ( _ ) => PlatFormProvider(platsServices.selectedProduct),
      child: _ProductScreenBody(productService: productService)
    );
  }
}

// Esta clase representa el cuerpo principal de la pantalla de producto
class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.productService,
  }) : super(key: key);

  final ProductsService productService;

  @override
  Widget build(BuildContext context) {

    // Obtenemos el provider que contiene el producto temporal
    final productForm = Provider.of<ProductFormProvider>(context);

    return Scaffold(  // refactor -> Extract Widget -> _ProductScreen para generar lo de arriba
      body: SingleChildScrollView(  // Permite que el contenido se pueda desplazar si es muy largo
        child: Column(
          children: [
             // Sección para mostrar la imagen del producto y botones flotantes encima
            Stack( // Stack permite colocar widgets unos encima de otros (como capas)
              children: [
                ProductImage(productService.selectedProduct.picture), // Muestra la imagen del producto
                
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
                      productService.updateSelectedImage(photo!.path);
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

      // Botón flotante para guardar el producto
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
          child: productService.isSaving //IF
          ? CircularProgressIndicator(color: Colors.white) // true
          : Icon(Icons.save_outlined), // Icono de guardar // false

          onPressed: productService.isSaving //if
          ? null // Si se está guardando, deshabilita el botón
          : (() async { // false
            //Emmagatzemar producte
            if (!productForm.isValidForm()) { // validamos si el formulario es valido
              return;
            } else {
              
              // llama a uploadImage
              final String? imageUrl = await productService.uploadImage();

              // Si se ha subido una imagen nueva, actualizamos la URL en el producto temporal
              if (imageUrl != null) {
                productForm.tempProduct.picture = imageUrl;
              }
              // Llama a saveOrCreateProduct() que decide si crear o actualizar
              // en services/productServices
              productService.saveOrCreateProduct(productForm.tempProduct);

              
            }

          })),
    );
  }
}

// Formulario para editar los datos del producto
class _ProductForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtenemos el provider que contiene el producto temporal
    final productForm = Provider.of<ProductFormProvider>(context);
    final tempProduct = productForm.tempProduct; // Producto a editar

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
                initialValue: tempProduct.name, // Valor inicial (nombre actual)
                onChanged: (value) => tempProduct.name = value, // Guardamos lo que el usuario escribe
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
                initialValue: tempProduct.price.toString(),// Precio inicial como texto
                inputFormatters: [
                  // Restringe números con hasta 2 decimales
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^(\d+)?\.?\d{0,2}')
                  ),
                ],
                onChanged: (value) {
                  if (double.tryParse(value) == null) {
                    tempProduct.price = 0; // Si no es número, se pone 0
                  } else {
                    tempProduct.price = double.parse(value); // Convierte a número
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
                value: tempProduct.available, // Valor inicial de la disponibilidad
                title: Text('Disponible'), // Título del interruptor
                activeColor: Colors.indigo, // Color cuando el interruptor está activado
                onChanged: (value) {
                  tempProduct.available = value;
                  productForm.updateAvailability();
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