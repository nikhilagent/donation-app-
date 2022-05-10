import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:project1/form/acceptBook.dart';
import 'package:project1/form/acceptClothes.dart';
import 'package:project1/form/acceptFood.dart';
import 'package:project1/form/marFormBook.dart';
import 'package:project1/form/marFormClothes.dart';
import 'package:project1/form/marFormFood.dart';
import 'package:project1/form/seeRequestBook.dart';
import 'package:project1/form/seeRequestClothes.dart';
import 'package:project1/form/seeRequestFood.dart';
import 'package:project1/pages/login_page.dart';
import 'package:project1/pages/maintab.dart';

class seeRequest extends StatefulWidget {
  const seeRequest({Key? key}) : super(key: key);

  @override
  State<seeRequest> createState() => _seeRequestState();
}

class _seeRequestState extends State<seeRequest> {
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
                  seeRequestFood(),
                  seeRequestClothes(),
                  seeRequestBook(),
                ])));
  }
}
