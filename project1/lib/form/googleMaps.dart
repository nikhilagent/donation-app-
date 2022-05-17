import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
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

class googleMaps extends StatefulWidget {
  final double lat1;
  final double long1;
  final double lat2;
  final double long2;
  const googleMaps(
      {Key? key,
      required this.lat1,
      required this.long1,
      required this.lat2,
      required this.long2})
      : super(key: key);
  @override
  State<googleMaps> createState() => _googleMapsState(lat1, long1, lat2, long2);
}

class _googleMapsState extends State<googleMaps> {
  double lat1;
  double long1;
  double lat2;
  double long2;

  _googleMapsState(this.lat1, this.long1, this.lat2, this.long2);
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
  late LatLng currentlocation;
  late LatLng destinationlocation;

  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //set up initial location
    polylinePoints = PolylinePoints();
    this.setInitialLocation();
    //set up markers
  }

  //void setSourceAndDestinationMarkers() {}

  void setInitialLocation() {
    currentlocation = LatLng(lat1, long1);
    destinationlocation = LatLng(lat2, long2);
  }

  void setPolylines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyDZ2s8xajl-RawlvMTenyQdiM1EQKctNgE",
        PointLatLng(currentlocation.latitude, currentlocation.longitude),
        PointLatLng(
            destinationlocation.latitude, destinationlocation.longitude));
    if (result.status == 'OK') {
      print('***********status ok');
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        setState(() {
          _polylines.add(Polyline(
              width: 10,
              polylineId: PolylineId('polyline'),
              color: Colors.blue,
              points: polylineCoordinates));
        });
      });
    } else {
      print("************${result.errorMessage}");
    }
  }

  void showPinsOnMap() {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId('source'),
          position: LatLng(lat1, long1),
          infoWindow: InfoWindow(title: 'Donor', snippet: 'Donor'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)));
      _markers.add(Marker(
          markerId: MarkerId('destination'),
          position: LatLng(lat2, long2),
          infoWindow: InfoWindow(title: 'Acceptor', snippet: 'Acceptor'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen)));
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
        zoom: 16, tilt: 80, bearing: 30, target: currentlocation);
    return Scaffold(
        body: Stack(
      children: [
        Positioned.fill(
          child: Container(
              child: GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            compassEnabled: false,
            tiltGesturesEnabled: false,
            polylines: _polylines,
            markers: _markers,
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              showPinsOnMap();
              setPolylines();
            },
          )),
        )
      ],
    ));
  }
}
