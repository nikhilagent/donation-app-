import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project1/form/accept.dart';
import 'package:project1/form/acceptBook.dart';
import 'package:project1/form/acceptClothes.dart';
import 'package:project1/form/acceptFood.dart';
import 'package:project1/pages/login_page.dart';
import 'package:project1/pages/maintab.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class googleMapAPI extends StatefulWidget {
  final double lat1;
  final double long1;
  final double lat2;
  final double long2;
  const googleMapAPI(
      {Key? key,
      required this.lat1,
      required this.long1,
      required this.lat2,
      required this.long2})
      : super(key: key);

  @override
  State<googleMapAPI> createState() =>
      _googleMapAPIState(lat1, long1, lat2, long2);
}

class _googleMapAPIState extends State<googleMapAPI> {
  double lat1;
  double long1;
  double lat2;
  double long2;

  _googleMapAPIState(this.lat1, this.long1, this.lat2, this.long2);

  Set<Marker> _marker = {};

  final Set<Polyline> polyline = {};

  void _onMapCreated(GoogleMapController _controller) {
    setState(() {
      _marker.add(Marker(
          markerId: MarkerId('ID-1'),
          position: LatLng(lat1, long1),
          infoWindow: InfoWindow(title: 'Donor', snippet: 'Donor'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)));

      _marker.add(Marker(
          markerId: MarkerId('ID-2'),
          position: LatLng(lat2, long2),
          infoWindow: InfoWindow(title: 'Acceptor', snippet: 'Acceptor'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainTab(),
                  ),
                  ((route) => false));
            }),
        title: Text('Google Map',
            style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
      body: GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(lat1, long1),
          zoom: 15,
        ),
        onMapCreated: _onMapCreated,
        markers: _marker,
      ),
    );
  }
}
