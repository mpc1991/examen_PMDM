import 'package:firebaseapi/screens/loading_screen.dart';
import 'package:firebaseapi/services/plats_services.dart';
import 'package:firebaseapi/widgets/card_slider.dart';
import 'package:firebaseapi/widgets/card_swiper.dart';
import 'package:firebaseapi/widgets/plat_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final platsServices = Provider.of<PlatsServices>(context);
    if (platsServices.isLoading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(title: Text('Home Screen')),

      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 600, // Por ejemplo (ajústalo si quieres)
                child: PlatCard(plats: platsServices.plats),
              ),
              CardSwiper(plats: platsServices.plats),
              CardSlider(plats: platsServices.plats),
            ],
          ),
        ),
      ),
    );
  }
}
