import 'dart:convert';

class Plat {
    String descripcio;
    bool disponible;
    String? foto;
    String geo;
    String nom;
    String restaurant;
    String tipus;
    String? id; // Añadido a mano

    Plat({
        required this.descripcio,
        required this.disponible,
        this.foto,
        required this.geo,
        required this.nom,
        required this.restaurant,
        required this.tipus,
        this.id, // Añadido a mano
    });

    factory Plat.fromJson(String str) => Plat.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Plat.fromMap(Map<String, dynamic> json) => Plat(
        descripcio: json["descripcio"],
        disponible: json["disponible"],
        foto: json["foto"],
        geo: json["geo"],
        nom: json["nom"],
        restaurant: json["restaurant"],
        tipus: json["tipus"],
    );

    Map<String, dynamic> toMap() => {
        "descripcio": descripcio,
        "disponible": disponible,
        "foto": foto,
        "geo": geo,
        "nom": nom,
        "restaurant": restaurant,
        "tipus": tipus,
    };

    Plat getPlat(){ // Añadido a mano
      Plat plat = new Plat(descripcio: this.descripcio, disponible: this.disponible, foto: this.foto, 
      geo: this.geo, nom: this.nom, restaurant: this.restaurant, tipus: this.tipus, id: this.id) ;

      return plat;
    }
}
