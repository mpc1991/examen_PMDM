import 'package:firebaseapi/screens/loading_screen.dart';
import 'package:firebaseapi/services/old_plats_services.dart';
import 'package:firebaseapi/widgets/old_plat_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final platsServices = Provider.of<PlatsServices>(context);
    if (platsServices.isLoading) return LoadingScreen();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),

      body: ListView.builder(
        itemCount: platsServices.plats.length,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
          child: PlatCard(plat: platsServices.plats[index]),
          onTap: () {
            //platsServices.newPicture = null;
            //platsServices.selectedProduct = platsServices.plats[index].getProduct();
            //Navigator.of(context).pushNamed('product');
          },
        ),
      )
    );
  }
}

