import 'package:firebaseapi/screens/mapa_screen.dart';
import 'package:firebaseapi/screens/old_home_screen.dart';
import 'package:firebaseapi/screens/old_plat_form_screen.dart';
import 'package:firebaseapi/services/old_plats_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
void main(){
  runApp(AppState());
}

class AppState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(
        create: ( _ ) => PlatsServices(), // creamos un productServices
      ),
    ],
    child: MyApp()
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase API',
      initialRoute: 'home',
      routes: {
        'home': (_) => HomeScreen(),
        'plat': (_) => ProductScreen(),
        'mapa': (_) => MapaScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}