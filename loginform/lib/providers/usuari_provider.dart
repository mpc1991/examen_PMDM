import 'package:flutter/material.dart';

class UsuariProvider extends ChangeNotifier {
  String _usuari = '';
  String _contrasenya = '';

  //UsuariProvider(this._usuari, this._contrasenya);
  UsuariProvider();

  String get usuari => _usuari;
  String get contrasenya => _contrasenya;

  void setUsuari(String usuari) {
    _usuari = usuari;
  }

  void setContrasenya(String contrasenya) {
    _contrasenya = contrasenya;
  }
}