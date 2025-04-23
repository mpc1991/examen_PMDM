import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loginform/providers/usuari_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var usuariProvider = Provider.of<UsuariProvider>(context);
    var usuari = usuariProvider.usuari;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              usuariProvider.setUsuari('');
              usuariProvider.setContrasenya('');
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome, $usuari!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
