// Provider que gestiona el estado del formulario para editar un producto
// Se utiliza para validar y actualizar el producto mientras se edita en la UI
import 'package:firebaseapi/models/old_plat.dart';
import 'package:flutter/material.dart';

class PlatFormProvider extends ChangeNotifier{
  // Llave global usada para acceder al estado del formulario (validación, reset, etc.)
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  // Producto temporal que se edita antes de guardarlo
  //Product tempProduct;    // Forma Dart
  late Plat tempPlat; // Forma Java

  // Constructor que recibe el producto y lo guarda como temporal
  PlatFormProvider(Plat plat){ // Forma Java
    this.tempPlat = plat;
  }

  // Verifica si el formulario es válido
  bool isValidForm(){
    return formKey.currentState?.validate() ?? false;
  }

  // Notifica a los widgets que la disponibilidad del producto ha cambiado
  updateAvailabilityDart(bool value){
    this.tempPlat.disponible = value;
    notifyListeners();
  }
}