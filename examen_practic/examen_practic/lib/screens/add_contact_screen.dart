import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';

class AddContact extends StatelessWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scanListProvider = Provider.of<ScanListProvider>(context);
    final contact = scanListProvider.contact;
    final name_controller = TextEditingController();
    final phone_controller = TextEditingController();
    String name;
    String phone;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Añadir Contacto'),
        ),
        body: Form(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: name_controller,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: 'Nombre',
                      labelText: 'Nombre del Contacto',
                      icon: Icon(Icons.person),
                    ),
                  ),
                  TextFormField(
                    controller: phone_controller,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: 'Telefono',
                      labelText: 'Telefono del Contacto',
                      icon: Icon(Icons.phone),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      name = name_controller.text.toString();
                      phone = phone_controller.text.toString();
                      scanListProvider.nuevoContacto(name, phone);
                      Navigator.pushNamed(context, 'home');
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    disabledColor: Colors.grey,
                    elevation: 0,
                    color: Colors.deepPurple,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 80,
                        vertical: 10,
                      ),
                      child: const Text(
                        'Insertar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
