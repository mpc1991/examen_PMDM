import 'package:firebaseapi/models/plat.dart';
import 'package:flutter/material.dart';

class CardSlider extends StatelessWidget {
  // const CardSlider({Key? key}) : super(key: key);
  final List<Plat> plats;
  const CardSlider({super.key, required this.plats});

  @override
  Widget build(BuildContext context) {
    print(plats.length);

    return Container(
      width: double.infinity,
      height: 270,
      // color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'plats',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: plats.length,
              itemBuilder: (_, int index) => _MoviePoster(plat: plats[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Plat plat;

  const _MoviePoster({super.key, required this.plat});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 190,
      // color: Colors.green,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap:
                () => Navigator.pushNamed(context, 'details', arguments: plat),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child:
                  plat.foto ==
                          null // if
                      // true
                      ? Image(
                        // url es null, usa esta img
                        image: AssetImage('assets/no-image.png'),
                        fit: BoxFit.cover,
                      )
                      // else
                      : FadeInImage(
                        // url NO es null, esa esta img
                        placeholder: AssetImage('assets/jar-loading.gif'),
                        image: NetworkImage(plat.foto!),
                        fit: BoxFit.cover,
                      ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            plat.nom,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
