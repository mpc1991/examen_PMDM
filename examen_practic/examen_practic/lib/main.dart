import 'package:examen_practic/screens/add_contact_screen.dart';
import 'package:examen_practic/screens/details_screen.dart';
import 'package:examen_practic/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/providers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ScanListProvider()),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Material App',
            initialRoute: 'login',
            routes: {
              'login': (_) => LoginScreen(),
              'home': (_) => HomeScreen(),
              'add': (_) => AddContact(),
            }));
  }
}
