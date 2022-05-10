import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project1/form/marFormBook.dart';
import 'package:project1/form/clothesForm.dart';
import 'package:project1/form/foodForm.dart';
import 'package:project1/form/marFormClothes.dart';
import 'package:project1/form/marFormFood.dart';
import 'package:project1/pages/maintab.dart';

class marButton extends StatefulWidget {
  const marButton({Key? key}) : super(key: key);

  @override
  State<marButton> createState() => _marButtonState();
}

class _marButtonState extends State<marButton> {
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
          title:
              Text('Daan', style: TextStyle(fontSize: 34, color: Colors.black)),
          /*bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.black,
              tabs: topTabs,
            )*/
        ),
        backgroundColor: Colors.white,
        body: Center(
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
              Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => marFormFood()));
                      },
                      child: Text(
                        'Food',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(350.0, 150.0)))),
              Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => marFormClothes()));
                      },
                      child: Text(
                        'Clothes',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(350.0, 150.0)))),
              Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => marFormBook()));
                      },
                      child: Text(
                        'Books',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(350.0, 150.0)))),
            ]))));
  }
}
