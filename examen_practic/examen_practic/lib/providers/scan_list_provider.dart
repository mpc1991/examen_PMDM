import 'package:flutter/material.dart';
import 'package:examen_practic/providers/db_provider.dart';

class ScanListProvider extends ChangeNotifier {
  List<ContactModel> contact = [];

  Future<ContactModel> nuevoContacto(String name, String phone) async {
    final nuevoContacto = ContactModel(name: name, phone: phone);
    final id = await DBProvider.db.nuevoContacto(nuevoContacto);
    nuevoContacto.id = id;
    contact.add(nuevoContacto);
    notifyListeners();
    return nuevoContacto;
  }

  loadScans() async {
    final contact = await DBProvider.db.getAllScans();
    this.contact = [...?contact];
    notifyListeners();
  }

  deleteAll() async {
    await DBProvider.db.deleteAll();
    contact = [];
    notifyListeners();
  }

  deleteScansByID(int? id) async {
    await DBProvider.db.deleteScan(id!);
  }
}
