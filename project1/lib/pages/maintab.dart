import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project1/form/accept.dart';
import 'package:project1/pages/buttons.dart';
import 'package:project1/pages/login_page.dart';

class MainTab extends StatefulWidget {
  MainTab({Key? key}) : super(key: key);

  @override
  _MainTabState createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final List<Tab> topTabs = <Tab>[
    Tab(icon: Icon(Icons.camera_alt)),
    Tab(text: 'LIST'),
    Tab(text: 'DONATION'),
    Tab(text: 'REQUESTS'),
  ];
  @override
  void initState() {
    _tabController = TabController(
        length: topTabs.length,
        initialIndex: 1,
        vsync: this); //indexes of tab in toptabs for initialIndex
    super.initState();
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
                      builder: (context) => Loginsrc(),
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
        body: Center(
            child: SingleChildScrollView(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(5.0, 5.0, 2.5, 5.0),
              child: ElevatedButton(
                  onPressed: () {
                    print('Button Is Pressed');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => buttons()));
                  },
                  child: Text('Donate', style: TextStyle(fontSize: 20.0)),
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(20),
                      minimumSize: Size(350.0, 50.0))),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(2.5, 5.0, 5.0, 5.0),
              child: ElevatedButton(
                  onPressed: () {
                    print('Button Is Accept Pressed');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => accept()));
                  },
                  child: Text('Accept', style: TextStyle(fontSize: 20.0)),
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10), minimumSize: Size(350, 50))),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(5.0, 5.0, 2.5, 5.0),
              child: ElevatedButton(
                  onPressed: () {},
                  child:
                      Text('Make A Request', style: TextStyle(fontSize: 20.0)),
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10), minimumSize: Size(350, 50))),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(2.5, 5.0, 5.0, 5.0),
              child: ElevatedButton(
                  onPressed: () {},
                  child: Text('See Request', style: TextStyle(fontSize: 20.0)),
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10), minimumSize: Size(350, 50))),
            )
          ],
        ))));
  }
}
