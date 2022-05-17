import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project1/form/accept.dart';
import 'package:project1/form/googleMapAPI.dart';
import 'package:project1/form/googleMaps.dart';
import 'package:project1/pages/maintab.dart';

class contactDetailsFood extends StatefulWidget {
  final int i;
  final String id;
  final String name;
  final String phone;
  final double lat1;
  final double long1;
  final double lat2;
  final double long2;
  const contactDetailsFood(
      {Key? key,
      required this.i,
      required this.id,
      required this.name,
      required this.phone,
      required this.lat1,
      required this.long1,
      required this.lat2,
      required this.long2})
      : super(key: key);

  @override
  State<contactDetailsFood> createState() =>
      _contactDetailsFoodState(i, id, name, phone, lat1, long1, lat2, long2);
}

class _contactDetailsFoodState extends State<contactDetailsFood> {
  int i;
  String id;
  String name;
  String phone;
  double lat1;
  double long1;
  double lat2;
  double long2;

  _contactDetailsFoodState(this.i, this.id, this.name, this.phone, this.lat1,
      this.long1, this.lat2, this.long2);
  final Stream<QuerySnapshot> food =
      FirebaseFirestore.instance.collection('food').snapshots();

  /*downloading script started */
  int progress = 0;
  ReceivePort _receivePort = ReceivePort();
  static downloadingCallback(id, status, progress) {
    ///looking up for the send port
    SendPort? sendPort = IsolateNameServer.lookupPortByName("downloading");

    ///sending the data
    sendPort!.send([id, status, progress]);
  }

  @override
  void initState() {
    super.initState();

    ///register a send port for the other isolates
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, "downloading");

    ///listening of data comming from other isolates
    _receivePort.listen((message) {
      setState(() {
        progress = message[2];
      });
    });
    FlutterDownloader.registerCallback(downloadingCallback);
  }

/*downloading script ended */
  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lastPosition = await Geolocator.getLastKnownPosition();
    print(lastPosition);
    setState(() {
      lat2 = position.latitude;
      long2 = position.longitude;
      print('** lat2: ${lat2}');
      print(lat2);
      print('** long2 ${long2}');
      print(long2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: food,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) print('Something Went Wrong');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final data = snapshot.requireData;
          final List storedocs = [];
          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map a = document.data() as Map<String, dynamic>;
            storedocs.add(a);
          }).toList();
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
                  title: Text('Daan',
                      style: TextStyle(fontSize: 34, color: Colors.black))),
              backgroundColor: Colors.white,
              //------------------------------------------------first list view
              body: ListView(children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(50.0)),
                      color: Colors.blue),
                  //-------------------------------------------second nested list view
                  child: Column(
                    children: [
                      Text(
                        'Name : ${name}',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Text(
                        'Phone no : ${phone}',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      /*^^^^^^^^^^^^download script 2nd part ended */
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 100),
                        child: ElevatedButton(
                          onPressed: () async {
                            /*lat1 = double.parse(data.docs[i]['Latitude']);
                        long1 = double.parse(data.docs[i]['Longitude']);
                        print('** lat1: ${lat1}');
                        print('** long1: ${long1}');
                        print("clicked");
                        final status = await Permission.location.request();
                        if (status.isGranted) {
                          getCurrentLocation();
                        } else {
                          print('Access denied');
                        }
                                    */
                            var position = await Geolocator.getCurrentPosition(
                                desiredAccuracy: LocationAccuracy.high);

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => googleMapAPI(
                                      lat1: lat1,
                                      long1: long1,
                                      lat2: position.latitude,
                                      long2: position.longitude,
                                    )));
                            //deleteUserId(id);
                          },
                          child: Text('LOCATION'),
                          style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 97, 76, 175),
                              minimumSize: Size(10, 40)),
                        ),
                      ),
                    ],
                  ),
                ),
              ]));
        });
  }
}
