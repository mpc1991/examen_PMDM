import 'dart:io';

import 'package:flutter/material.dart';

class PlatImage extends StatelessWidget {
  final String? url; 

  // Constructor que recibe la URL de la imagen.
  const PlatImage(
    this.url, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 10, left: 10, top: 10),
      child: Container(
        decoration: _buildBoxDecoration(),
        width: double.infinity,
        height: 450,
        child: Opacity( // Aplicamos opacidad a la imagen para darle que se vean los botones
          opacity: 0.9,
          child: ClipRRect( // Redondear las esquinas del contenedor.
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            child: getImage(url), // Se crea un widget para mostrar aqui
          )
        ),
      ),
    );
  }

  // Función para construir la decoración del contenedor de la imagen (bordes redondeados y sombra).
  BoxDecoration _buildBoxDecoration() => BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            )
          ]);

  // Lógica para ver qué imagen devolvemos segun el contenido de URL
  Widget getImage(String? url){
    if (url == null) {        
      // Si no hay imagen, se muestra una imagen por defecto desde los assets
      return Image.asset(          
        'assets/no-image.png',
        fit: BoxFit.cover,
        );
    } else if (url.startsWith('http')) {
      // Si la URL apunta a una imagen de Internet, se usa FadeInImage para mostrar una carga progresiva
      return FadeInImage(
        placeholder: AssetImage('assets/jar-loading.gif'),
        image: NetworkImage(url!), // Si empieza por HTTP, devolvemos la URL
        fit: BoxFit.cover);
    } else {
      // Si la URL es una ruta local, se carga la imagen desde el dispositivo
      return Image.file(
        File(url), // Devolvemos la imagen local
        fit: BoxFit.cover,
      );
    }
  }
}