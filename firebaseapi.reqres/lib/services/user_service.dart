
import 'dart:convert';

import 'package:firebaseapi/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Clase que gestiona la lógica de platos y se comunica con Firebase
// Extiende ChangeNotifier para permitir notificar a los widgets cuando cambian los datos

class UserService extends ChangeNotifier{
  // URL de FireBase SIN HHTPS
  final String _baseUrl = 'reqres.in';
  final List<User> users = []; // lista de platos
  // plato a modificar antes de guardarlo en la lista y la BBDD
  //late Plat selectedPlat; // se rellena desde home_screen en onTap().
  bool isLoading = true;

  // Constructor
  UserService(){
    this.loadPlats();
  }

  // Método asincrónico para cargar productos desde Firebase
  Future loadPlats() async {
    isLoading = true; // Indicamos que estamos cargando datos
    notifyListeners(); // Notificamos a los widgets que dependen de este provider

    // Construimos la URL para hacer la petición GET a Firebase
    final url = Uri.https(_baseUrl, 'api/users', {'page' : '2'});
    final respuesta = await http.get(url);
    print(respuesta);

     // Convertimos la respuesta JSON en un mapa de productos
    //final Map<String, dynamic> usertMaps = json.decode(respuesta.body); // <-- Firebase
    final usuaris = Usuaris.fromJson(respuesta.body); // <-- reqres.in

    // Recorremos cada producto recibido y lo agregamos a la lista
    users.clear();
    // usertMaps.forEach((key, value) { // <-- Firebase
    //   final tempProduct = User.fromMap(value); 
    //   tempProduct.id = key as int; 
    //   users.add(tempProduct); 
    // });
    users.addAll(usuaris.data); //<-- reqres.in

    isLoading = false;
    notifyListeners(); // Notificamos a los widgets para actualizar la UI
  }
}
