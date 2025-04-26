import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:firebaseapi/models/plat.dart';

class CardSwiper extends StatelessWidget {
  final List<Plat> plats;
  const CardSwiper({super.key, required this.plats});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final String? url;

    return Container(
      width: double.infinity,
      // Aquest multiplicador estableix el tant per cent de pantalla ocupada 50%
      height: size.height * 0.5,
      // color: Colors.red,
      child: Swiper(
        itemCount: plats.length,
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.6,
        itemHeight: size.height * 0.4,
        itemBuilder: (BuildContext context, int index) {
          final plat = plats[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'details', arguments: plat);
            },
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
          );
        },
      ),
    );
  }
}
