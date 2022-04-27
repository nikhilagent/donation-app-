import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project1/form/accept.dart';

class acceptFood extends StatefulWidget {
  const acceptFood({Key? key}) : super(key: key);

  @override
  State<acceptFood> createState() => _acceptFoodState();
}

class _acceptFoodState extends State<acceptFood> {
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
          print(storedocs[1]['Image']);
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
                      style: TextStyle(
                          fontSize: 20, color: Color.fromARGB(255, 90, 48, 48)),
                    ),
                    Image.network(data.docs[i]['Image'].toString()),
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
                                  url: data.docs[1]['Image'].toString(),
                                  savedDir: externalDir!.path,
                                  fileName: "download",
                                  showNotification: true,
                                  openFileFromNotification: true);
                              print(data.docs[1]['Image'].toString());
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
                        onPressed: () {
                          AlertDialog(
                            title: Text('Do You Accept'),
                            content: Text('Do You Want To Coontinue?'),
                            actions: [
                              TextButton(onPressed: () {}, child: Text('NO')),
                              TextButton(onPressed: () {}, child: Text('YES'))
                            ],
                            elevation: 24.0,
                          );
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
