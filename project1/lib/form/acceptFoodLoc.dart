import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project1/form/acceptBook.dart';
import 'package:project1/form/acceptClothes.dart';
import 'package:project1/form/acceptFood.dart';
import 'package:project1/pages/login_page.dart';
import 'package:project1/pages/maintab.dart';

class acceptFoodLoc extends StatefulWidget {
  const acceptFoodLoc({Key? key}) : super(key: key);

  @override
  State<acceptFoodLoc> createState() => _acceptFoodLocState();
}

class _acceptFoodLocState extends State<acceptFoodLoc> {
  String location = "";
  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lastPosition = await Geolocator.getLastKnownPosition();

    setState(() {
      location = "${position.latitude},${position.longitude}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('location')),
        body: Center(
            child: Column(children: [
          Text(location),
          ElevatedButton(
              onPressed: () async {
                final status = await Permission.location.request();
                if (status.isGranted) {
                  getCurrentLocation();
                } else
                  print('Access denied');
              },
              child: Text('location'))
        ])));
  }
}
