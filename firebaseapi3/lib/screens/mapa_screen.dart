import 'dart:async';

import 'package:firebaseapi/models/scan_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Configurar la API KEY en androidmanifest
//android/app/src/androidmanifest

class MapaScreen extends StatefulWidget {
  const MapaScreen({Key? key}) : super(key: key);

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
      
  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context)!.settings.arguments as ScanModel;
    
    final CameraPosition _puntInicial = CameraPosition(
    target: scan.getLatLng(),
    zoom: 17,
    tilt: 50,
  );
    
    Set<Marker> markers = new Set<Marker>();
    markers.add(new Marker(
      markerId: MarkerId('id1'),
      position: scan.getLatLng()
    ));

    // añadir, appbar
    // flecha para volver atrás, 
    // icono para centrar
    // botón abajo derecha para cambiar las capas entre normal e hybrido
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps'),
        actions: [
          IconButton(onPressed: () async {
            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(CameraUpdate.newCameraPosition(_puntInicial));
          }, 
          icon: Icon(Icons.my_location)
          )
        ],
      ),
      body:GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        markers: markers,
        initialCameraPosition: _puntInicial,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
