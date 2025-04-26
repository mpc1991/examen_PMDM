import 'package:firebaseapi/screens/loading_screen.dart';
import 'package:firebaseapi/services/user_service.dart';
import 'package:firebaseapi/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final userService = Provider.of<UserService>(context);
    if (userService.isLoading) return LoadingScreen();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),

      body: ListView.builder(
        itemCount: userService.users.length,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
          child: UserCard(user: userService.users[index]),
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

