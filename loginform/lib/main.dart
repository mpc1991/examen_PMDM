import 'package:flutter/material.dart';
import 'package:loginform/providers/usuari_provider.dart';
import 'package:loginform/screens/home_screen.dart';
import 'package:loginform/screens/login_form.dart';
import 'package:provider/provider.dart';
void main() {

  runApp(AppState());
}
class AppState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(
        create: ( _ ) => UsuariProvider(),
      ),
    ],
    child: MyApp()
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var usuariProvider = Provider.of<UsuariProvider>(context, listen: false);
    usuariProvider.setUsuari('');
    usuariProvider.setContrasenya('');
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Form',
      initialRoute: 'login',
      routes: {
        'login': (_) => LoginForm(),
        'home': (_) => HomeScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}


