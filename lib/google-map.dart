import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class googleMap extends StatefulWidget {
  @override
  _googleMapState createState() => _googleMapState();
}

class _googleMapState extends State<googleMap> {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(145.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
      ),
    );
    // return Scaffold(
    //     appBar:AppBar(
    //       title: Text(
    //         "谷歌地图",
    //         style: TextStyle(
    //           color: Colors.white,
    //           fontWeight: FontWeight.w900,
    //         ),
    //       ),
    //     ),
    //   body: GoogleMap(
    //     onMapCreated: _onMapCreated,
    //     initialCameraPosition: CameraPosition(
    //       target: _center,
    //       zoom: 11.0,
    //     ),
    //   ),
    // );
  }
}
