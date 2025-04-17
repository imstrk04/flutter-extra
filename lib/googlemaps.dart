import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  Marker? _pickedMarker;
  LatLng _initialPosition = LatLng(12.9716, 77.5946); // Default: Bangalore

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onTap(LatLng position) {
    setState(() {
      _pickedMarker = Marker(
        markerId: MarkerId('pickedLocation'),
        position: position,
        infoWindow: InfoWindow(
          title: 'Pinned Location',
          snippet: 'Lat: ${position.latitude}, Lng: ${position.longitude}',
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pick a Location")),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              onTap: _onTap,
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 12,
              ),
              markers: _pickedMarker != null ? {_pickedMarker!} : {},
            ),
          ),
          if (_pickedMarker != null)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Selected Coordinates:\nLatitude: ${_pickedMarker!.position.latitude}\nLongitude: ${_pickedMarker!.position.longitude}',
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}


// dependencies:
// flutter:
// sdk: flutter
// google_maps_flutter: ^2.5.0
