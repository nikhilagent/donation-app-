import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:project1/form/acceptFood.dart';
import 'package:project1/pages/login_page.dart';
import 'package:project1/pages/maintab.dart';

class accept extends StatefulWidget {
  const accept({Key? key}) : super(key: key);

  @override
  State<accept> createState() => _acceptState();
}

class _acceptState extends State<accept> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
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
                    style: TextStyle(fontSize: 34, color: Colors.black)),
                bottom: TabBar(
                  //controller:controller
                  tabs: [
                    Tab(
                      text: 'FOOD',
                    ),
                    Tab(
                      text: 'CLOTHES',
                    ),
                    Tab(
                      text: 'BOOKS',
                    ),
                  ],
                )),
            body: TabBarView(
                //controller:controller
                children: [
                  acceptFood(),
                  Container(
                      child: Center(
                          child: Text('clothes',
                              style: TextStyle(fontSize: 50.0)))),
                  Container(
                      child: Center(
                          child:
                              Text('books', style: TextStyle(fontSize: 50.0))))
                ])));
  }
}
