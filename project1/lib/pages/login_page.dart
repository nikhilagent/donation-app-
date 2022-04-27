import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project1/pages/Signup_page.dart';
import 'package:project1/pages/forgotpassword.dart';
import 'package:project1/pages/maintab.dart';

class Loginsrc extends StatefulWidget {
  const Loginsrc({Key? key}) : super(key: key);

  @override
  _LoginsrcState createState() => _LoginsrcState();
}

class _LoginsrcState extends State<Loginsrc> {
  bool _securedText = true;
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  var name = '';
  var password = '';
  var _formkey = GlobalKey<FormState>();
  userlogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: name, password: password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainTab(),
        ),
      );
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        print('No User Found For That Email');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('No User Found For That Email',
                style: TextStyle(fontSize: 18.0))));
      } else if (e.code == 'wrong-password') {
        print('Wrong Password Entered By User');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Wrong Password Entered By User',
                style: TextStyle(fontSize: 18.0))));
      }
      print("asdf $e");
    }
  }

  //editing controller
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Form(
            key: _formkey,
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 110.0, 15.0, 20.0),
                  child: Text('DAAN.',
                      style:
                          TextStyle(fontSize: 80.0, color: Colors.blueAccent)),
                ),
                SizedBox(height: 40.0),
                Container(
                    padding: EdgeInsets.only(
                      top: 0,
                      bottom: 0,
                      right: 10.0,
                      left: 10.0,
                    ),
                    child: TextFormField(
                      controller: _namecontroller,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter Email Address',
                          labelText: 'Email Address',
                          labelStyle: TextStyle(fontSize: 20),
                          hintStyle: TextStyle(
                            fontSize: 20.0,
                          ),
                          prefixIcon: Icon(
                            Icons.mail,
                            color: Colors.black,
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Please Enter E-mail Address';
                        if (!RegExp(r'\w+@\w+\.\w+').hasMatch(value))
                          return 'Invalid E-mail Address format';
                        return null;
                      },
                    )),
                SizedBox(height: 10.0),
                Container(
                    padding: EdgeInsets.only(
                        top: 0, bottom: 0, left: 10.0, right: 10.0),
                    child: TextFormField(
                      controller: _passwordcontroller,
                      decoration: InputDecoration(
                          hintText: 'Enter Password',
                          labelText: 'Password',
                          labelStyle: TextStyle(fontSize: 20),
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(
                            fontSize: 20.0,
                          ),
                          prefixIcon: Icon(Icons.security),
                          suffixIcon: IconButton(
                              icon: Icon(_securedText
                                  ? Icons.remove_red_eye
                                  : Icons.security),
                              onPressed: () {
                                setState(() {
                                  _securedText = !_securedText;
                                });
                              })),
                      obscureText: _securedText,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Please Enter Password';
                        if (!RegExp(
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~]).{8,}$')
                            .hasMatch(value))
                          return '''password atleast 8 characters include one upper case one lower
  case one symbol''';
                        return null;
                      }, //password atleast 8 characters one upper case one lower case one symbol
                    )),
                SizedBox(height: 10.0),
                Container(
                    padding: EdgeInsets.only(left: 200),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => forgotpassword()));
                      },
                      child: Text('Forgot Password',
                          style:
                              TextStyle(color: Colors.lightBlue, fontSize: 20)),
                    )),
                SizedBox(height: 10.0),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                      onPressed: () {
                        print('name' + _namecontroller.text);
                        print('password' + _passwordcontroller.text);
                        if (_formkey.currentState!.validate())
                          setState(() {
                            name = _namecontroller.text;
                            password = _passwordcontroller.text;
                          });
                        userlogin();
                      },
                      child: Text('login')),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('New To Daan?',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20.0,
                      )),
                  SizedBox(
                    width: 5.0,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Signup_page()));
                    },
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 20,
                      ),
                    ),
                  )
                ]),
              ],
            )));
  }
}
//To Read Input from the user then we use controller