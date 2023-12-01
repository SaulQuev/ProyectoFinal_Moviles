import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(20.541763206393515, -100.81241889046707),
    zoom: 14.4746,
  );


  static const CameraPosition _Campus1 = CameraPosition(
      //bearing: 192.8334901395799,
      target: LatLng(20.5386975,-100.8195249),
     // tilt: 59.440717697143555,
      zoom: 18.543);

  static const CameraPosition _Campus2 = CameraPosition(
      //bearing: 192.8334901395799,
      target: LatLng(20.54102586022767, -100.81327379343351),
     // tilt: 59.440717697143555,
      zoom: 18.543);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton.extended(
            onPressed: _goToTheCampus1,
            label: const Text('TecNMCelayaCampus 1'),
            icon: const Icon(Icons.location_city),
          ),
        ),
        const SizedBox(height: 16),
        FloatingActionButton.extended(
          onPressed: _goToTheCampus2,
          label: const Text('TecNMCelayaCampus 2'),
          icon: const Icon(Icons.location_city),
          backgroundColor: Colors.green,
        ),
        ],
      ),
      
    );
  }

  Future<void> _goToTheCampus1() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_Campus1));
  }
  Future<void> _goToTheCampus2() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_Campus2));
  }
}