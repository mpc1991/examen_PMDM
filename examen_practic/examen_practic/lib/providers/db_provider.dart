import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/contact_model.dart';
export '../models/contact_model.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database?> get database async {
    if (_database != null) return _database!;

    _database ??= await initDB();

    return _database;
  }

  Future<Database?> initDB() async {
// Path de donde almacenamos la base de datos
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB.db');

    //Crear base de datos
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE Contactos(
            id INTEGER PRIMARY KEY,
            name TEXT,
            phone TEXT
          )
        ''');
    });
  }

// Creación de registros
  Future<int> nuevoContactoRaw(ContactModel nuevoContacto) async {
    final id = nuevoContacto.id;
    final name = nuevoContacto.name;
    final phone = nuevoContacto.phone;

    final db = await database;

    final res = await db!.rawInsert('''INSERT into Contactos(id, name, phone)
    VALUES($id,$name,$phone)''');

    return res;
  }

  Future<int> nuevoContacto(ContactModel nuevoContacto) async {
    final db = await database;
    final res = await db!.insert('Contactos', nuevoContacto.toJson());
    return res;
  }

// SELECT - Obtención de información
  Future<ContactModel?> getById(int id) async {
    final db = await database;
    final res = await db!.query('Contactos', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? ContactModel.fromJson(res.first) : null;
  }

  Future<ContactModel?> getByName(String name) async {
    final db = await database;
    final res =
        await db!.query('Contactos', where: 'name = ?', whereArgs: [name]);

    return res.isNotEmpty ? ContactModel.fromJson(res.first) : null;
  }

  Future<List<ContactModel>?> getAllScans() async {
    final db = await database;
    final res = await db!.query('Contactos');

    return res.isNotEmpty
        ? res.map((s) => ContactModel.fromJson(s)).toList()
        : [];
  }

  // Eliminar registros
  Future<int?> deleteScan(int id) async {
    final db = await database;
    final res = await db!.delete('Contactos', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int?> deleteAll() async {
    final db = await database;
    final res = await db!.rawDelete('DELETE FROM Contactos');
    return res;
  }
}
