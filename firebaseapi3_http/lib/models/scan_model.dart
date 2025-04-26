import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:url_launcher/url_launcher.dart';

// Configurar la API KEY en androidmanifest
//android/app/src/androidmanifest
class ScanModel {
  int? id;
  String? tipus; //hhtp o ggeo
  String valor;

  ScanModel({this.id, this.tipus, required this.valor}) {
    // Determinar el tipo de url
    if (this.valor.contains('http')) {
      this.tipus = 'http';
    } else {
      this.tipus = 'geo';
    }
  }

  LatLng getLatLng() {
  String cleaned;

  if (valor.startsWith('geo:')) {
    cleaned = valor.substring(4); // Quitamos el "geo:"
  } else {
    cleaned = valor; // Directamente números: "39.5870208,2.6476544"
  }
  final latLng = cleaned.split(',');
  final latitude = double.parse(latLng[0]);
  final longitude = double.parse(latLng[1]);

  return LatLng(latitude, longitude);
  }

  // 🔥🔥 Añadimos este método dentro de la clase
  Future<void> launch(BuildContext context) async {
    if (tipus == 'http') {
      final Uri url = Uri.parse(valor);
      if (!await launchUrl(url)) {
        //throw 'No se pudo abrir $valor';
      }
    } else {
      Navigator.pushNamed(context, 'mapa', arguments: this);
    }
  }

  factory ScanModel.fromJson(String str) => ScanModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ScanModel.fromMap(Map<String, dynamic> json) =>
      ScanModel(id: json["id"], tipus: json["tipus"], valor: json["valor"]);
  Map<String, dynamic> toMap() => {"id": id, "tipus": tipus, "valor": valor};
}

// void launchScan(BuildContext context, ScanModel scan) async {
//   if (scan.tipus == 'http') {
//     final Uri url = Uri.parse(scan.valor);
//     if (!await launchUrl(url)) {
//       throw 'No se pudo abrir ${scan.valor}';
//     }
//   } else {
//     Navigator.pushNamed(context, 'mapa', arguments: scan);
//   }
//}