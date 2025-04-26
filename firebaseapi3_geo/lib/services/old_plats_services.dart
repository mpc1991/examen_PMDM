
import 'dart:convert';
import 'dart:io';

import 'package:firebaseapi/models/old_plat.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Clase que gestiona la lógica de platos y se comunica con Firebase
// Extiende ChangeNotifier para permitir notificar a los widgets cuando cambian los datos

class PlatsServices extends ChangeNotifier{
  // URL de FireBase SIN HHTPS
  final String _baseUrl = 'fir-api-8ad8b-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Plat> plats = []; // lista de platos
  // plato a modificar antes de guardarlo en la lista y la BBDD
  late Plat selectedPlat; // se rellena desde home_screen en onTap().
  //late Plat selectedPlat; // se rellena desde home_screen en onTap().
  bool isLoading = true;
  bool isSaving = false;
  File? newPicture; // contendrá la imagen a subir

  // Constructor
  PlatsServices(){
    this.loadPlats();
  }

  // Método asincrónico para cargar productos desde Firebase
  Future loadPlats() async {
    isLoading = true; // Indicamos que estamos cargando datos
    notifyListeners(); // Notificamos a los widgets que dependen de este provider

    // Construimos la URL para hacer la petición GET a Firebase
    final url = Uri.https(_baseUrl, 'plats.json');
    final respuesta = await http.get(url);
    print(respuesta);

     // Convertimos la respuesta JSON en un mapa de productos
    final Map<String, dynamic> platMaps = json.decode(respuesta.body);

    // Recorremos cada producto recibido y lo agregamos a la lista
    plats.clear();
    platMaps.forEach((key, value) {
      final tempProduct = Plat.fromMap(value); // Convertimos el JSON a un objeto Product
      tempProduct.id = key; // Asignamos el ID del producto desde la base de datos
      plats.add(tempProduct); // Lo añadimos a la lista de productos
    });

    isLoading = false;
    notifyListeners(); // Notificamos a los widgets para actualizar la UI
  }

  // Almacena temporalmente una nueva imagen y actualiza el producto actual con la nueva ruta de la imagen
  void updateSelectedImage(String path){ // Recibimos el path de la img
    this.newPicture = null;
    this.newPicture = File.fromUri(Uri(path: path)); // Almacenamos el path en newPicture
    this.selectedPlat.foto = path; // Setter al atributo picture

    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (this.newPicture == null) {
      return null;
    } else {
      this.isSaving = true;
      notifyListeners();

      final url;
      final imageUploadRequest;
      final file;
      final streamResponse;
      final response;
      final decodeData;

      // URL POST de cloudinary
      // https://api.cloudinary.com/v1_1/<cloud name>/<resource_type>/upload
      url = Uri.parse('https://api.cloudinary.com/v1_1/dq6ayqckh/image/upload?upload_preset=PMDM05-MPC'); 

      imageUploadRequest = http.MultipartRequest('POST', url);

      file = await http.MultipartFile.fromPath('file', newPicture!.path);

      imageUploadRequest.files.add(file);

      streamResponse = await imageUploadRequest.send();
      response = await http.Response.fromStream(streamResponse); // respuesta
      
      if (response.statusCode != 200 && response.statusCode != 201) {
        print('Hi ha agut un error: productService.uploadImage');
        print(response.body);

        return null;
      }

      decodeData = json.decode(response.body);
      return decodeData['secure_url'];
    }
  }

  // Guardar los cambios en el producto
  Future saveOrCreateProduct (Plat product) async {
    isSaving = true;
    notifyListeners();

      if (product.id == null) {
        // Creant producte
        await createProduct(product);

      } else {
        // Actualitzant producte
        await updateProduct(product);
      }

    isSaving = false;
    notifyListeners();
  }
  Future<String> updateProduct (Plat product) async {
    // Construimos la URL para hacer la petición PUT a Firebase
    final url = Uri.https(_baseUrl, 'plats/${product.id}.json'); // ruta principal/id
    final respuesta = await http.put(url, body: product.toJson()); // Hacemos la petición HTTP PUT = modificar

    // Actualiza la lista local de productos
    // LoadProducts vacía la lista y vuelve a llenarla con los productos actuales.
    await loadPlats();

    // Forma para quitar el producto de la lista local sin llamar a loadProducts
    // más eficiente al no tener que volver a cargar la lista de la BBDD
    //final index = this.products.indexWhere((element) => element.id == product.id);
    //this.products[index] = product;

    return product.id!;
  }

    Future<String> createProduct (Plat product) async {
    // Construimos la URL para hacer la petición PUT a Firebase
    final url = Uri.https(_baseUrl, 'plats.json'); // ruta principal
    final respuesta = await http.post(url, body: product.toJson()); // Hacemos la petición HTTP POST = añadir
    final decodeData = json.decode(respuesta.body); // mapa de datos para poder acceder a sus atributos
    print (decodeData['name']); // Acceso a un atributo en concreto (id)

    // Asignamos el id al producto que nos han pasado
    product.id = (decodeData['name']);  // setter tipo dart

    // Actualiza la lista local de productos
    // LoadProducts vacía la lista y vuelve a llenarla con los productos actuales.
    //await loadProducts();

    // Forma para añadir el producto de la lista local sin llamar a loadProducts
    // más eficiente al no tener que volver a cargar la lista de la BBDD
    this.plats.add(product); // Añadimos el producto a la lista

    return product.id!;
  }

  void setProduct(Plat product) {
    this.selectedPlat = product;
  }
}
