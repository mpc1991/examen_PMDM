
import 'package:firebaseapi/models/plat.dart';
import 'package:flutter/material.dart';

class PlatCard extends StatelessWidget{
  final List<Plat> plats;
  const PlatCard({Key? key, required this.plats}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal:20),
      itemCount: plats.length,
      itemBuilder: (BuildContext context, int Index) { 
      final plat = plats[Index];
      return GestureDetector(
        
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal:20),
      child: Container(
        margin: EdgeInsets.only(top: 30, bottom: 50),
        width: double.infinity,
        height: 400,
        decoration: _cardBorders(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            _BackgroudWidget(plat.foto),
            _PlatDetails(plat.nom, plat.id!),
            Positioned(top: 0, right: 0, child: _PriceTag(123)), //plat.price si tiene
            if (!plat.disponible) ...[ // Condicional para añadir etiqueta
              Positioned(top: 0, left: 0, child: _Availability("Reservat")),
             ] else ...[ // Eliminar el 'else' si no queremos etiqueta 'Disponible'
              Positioned(top: 0, left: 0, child: _Availability("Disponible")),
             ]
            ],
          ),
        ),
      ),
      );}
  );
}
  BoxDecoration _cardBorders() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 7),
            blurRadius: 10,
          ),
        ],
      );
  
}

// ---------------------


class _BackgroudWidget extends StatelessWidget {
  final String? url;
   _BackgroudWidget(this.url, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 400,
        child: url == null // if
          // true
          ? Image(                                          // url es null, usa esta img
            image: AssetImage('assets/no-image.png'),
            fit: BoxFit.cover,
            ) 
          // else
          : FadeInImage(                                    // url NO es null, esa esta img
            placeholder: AssetImage('assets/jar-loading.gif'),
            image: NetworkImage(url!),
            fit: BoxFit.cover,
        )
      ),
    );
  }
}

class _PlatDetails extends StatelessWidget {
  final String name;
  final String subtitle;

  const _PlatDetails(this.name, this.subtitle,
  {Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
   return Padding(
    padding: EdgeInsets.only(right: 50),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      width: double.infinity,
      height: 80,
      decoration: _buildBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name, 
            style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
          ),
          Text(subtitle,style: TextStyle(fontSize: 10, color: Colors.white),)
        ],
      ),
    )
   );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      );
  }

  class _PriceTag extends StatelessWidget {
  final double price;
  const _PriceTag(this.price,{
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            price.toString(),
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
      width: 100,
      height: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
    );
  }
}

class _Availability extends StatelessWidget {
  final String available;

  const _Availability(this.available,{
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            available,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
      width: 100,
      height: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.red[300],
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
    );
  }
}