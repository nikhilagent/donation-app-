import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project1/form/accept.dart';
import 'package:project1/form/contactDetailsBook.dart';
import 'package:project1/form/googleMapAPI.dart';
import 'package:project1/form/googleMaps.dart';

class acceptBook extends StatefulWidget {
  const acceptBook({Key? key}) : super(key: key);

  @override
  State<acceptBook> createState() => _acceptBookState();
}

class _acceptBookState extends State<acceptBook> {
  var lat1;
  var long1;
  double lat2 = 0;
  double long2 = 0;
  final Stream<QuerySnapshot> book =
      FirebaseFirestore.instance.collection('book').snapshots();
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

    setState(() {
      lat2 = position.latitude;
      long2 = position.longitude;
      print('lat2');
      print(lat2);
      print('long2');
      print(long2);
    });
  }

  CollectionReference clothes1 =
      FirebaseFirestore.instance.collection('clothes');
  Future<void> deleteUserId(id) {
    return clothes1
        .doc(id)
        .delete()
        .then((value) => print('user deleted'))
        .catchError((error) => print('fail to delete the user:${error}'));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: book,
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
            a['id'] = document.id;
          }).toList();
          return Scaffold(
              //------------------------------------------------first list view
              body: ListView(children: [
            for (var i = 0; i < storedocs.length; i++) ...[
              Container(
                margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                padding: EdgeInsets.symmetric(vertical: 10),
                height: 500,
                width: 300,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(50.0)),
                    color: Colors.blue),
                //-------------------------------------------second nested list view
                child: Column(
                  children: [
                    Text(
                      'Name : ${data.docs[i]['Name']}',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Text(
                      'Description : ${data.docs[i]['Description']}',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    /*Text(
                      'Phone no : ${storedocs[i]['Phone no']}',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),*/
                    Text(
                      'Quantity : ${data.docs[i]['Quantity']}',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Expanded(
                      child: Image.network(data.docs[i]['Image'].toString()),
                    ),
                    Text(
                      'Download Image : ',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    /*downloading script 2nd part started*/
                    LinearProgressIndicator(
                      backgroundColor: Color.fromARGB(255, 97, 76, 175),
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      value: progress.toDouble(),
                      minHeight: 10,
                    ),
                    Center(
                      child: ElevatedButton(
                          onPressed: () async {
                            final status = await Permission.storage.request();
                            final externalDir =
                                await getExternalStorageDirectory();

                            if (status.isGranted) {
                              final id = await FlutterDownloader.enqueue(
                                  url: data.docs[i]['Image'].toString(),
                                  savedDir: externalDir!.path,
                                  fileName: "download",
                                  showNotification: true,
                                  openFileFromNotification: true);
                              print(data.docs[i]['Image'].toString());
                            } else {
                              print("Access is Denied");
                            }
                          },
                          child: Text('Download Image'),
                          style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 97, 76, 175))),
                    ),
                    /*^^^^^^^^^^^^download script 2nd part ended */
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 100),
                      child: ElevatedButton(
                        onPressed: () async {
                          print("clicked");
                          lat1 = double.parse(data.docs[i]['Latitude']);
                          long1 = double.parse(data.docs[i]['Longitude']);
                          print('lat1');
                          print(lat1);
                          print('long1');
                          print(long1);
                          print("clicked");
                          final status = await Permission.location.request();
                          if (status.isGranted) {
                            getCurrentLocation();
                          } else {
                            print('Access denied');
                          }
                          var position = await Geolocator.getCurrentPosition(
                              desiredAccuracy: LocationAccuracy.high);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => contactDetailsBook(
                                    i: i,
                                    id: storedocs[i]['id'],
                                    name: storedocs[i]['Name'],
                                    phone: storedocs[i]['Phone no'],
                                    lat1: lat1,
                                    long1: long1,
                                    lat2: position.latitude,
                                    long2: position.longitude,
                                  )));
                          deleteUserId(storedocs[i]['id']);
                        },
                        child: Text('Accept'),
                        style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 97, 76, 175),
                            minimumSize: Size(10, 40)),
                      ),
                    )
                  ],
                ),
              ),
            ]
          ]));
        });
  }
}
