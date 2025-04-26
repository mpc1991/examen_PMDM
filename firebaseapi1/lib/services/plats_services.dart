
import 'dart:convert';

import 'package:firebaseapi/models/plat.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Clase que gestiona la lógica de platos y se comunica con Firebase
// Extiende ChangeNotifier para permitir notificar a los widgets cuando cambian los datos

class PlatsServices extends ChangeNotifier{
  // URL de FireBase SIN HHTPS
  final String _baseUrl = 'fir-api-8ad8b-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Plat> plats = []; // lista de platos
  // plato a modificar antes de guardarlo en la lista y la BBDD
  //late Plat selectedPlat; // se rellena desde home_screen en onTap().
  bool isLoading = true;

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
}
