import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project1/pages/login_page.dart';

class Signup_page extends StatefulWidget {
  const Signup_page({Key? key}) : super(key: key);

  @override
  _Signup_pageState createState() => _Signup_pageState();
}

class _Signup_pageState extends State<Signup_page> {
  TextEditingController _namecontroller = TextEditingController();
  //TextEditingController _nicknamecontroller = TextEditingController();
  //TextEditingController _phonenumbercontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  TextEditingController _confirmpasswordcontroller = TextEditingController();
  bool _securedText = true;
  bool _securedText1 = true;
  var name = '';
  var password = '';
  var confirmPassword = '';
  var _formkey = GlobalKey<FormState>();
  registration() async {
    if (password == confirmPassword) {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: name, password: password);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Registration successful',
                style: TextStyle(fontSize: 18.0))));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Loginsrc(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('Password Is Too Weak');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Password Is Too Weak',
                  style: TextStyle(fontSize: 18.0))));
        } else if (e.code == 'email-already-in-use') {
          print('Email Already Exists');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Email Already Exists',
                  style: TextStyle(fontSize: 18.0))));
        }
      }
    } else {
      print("Password Confirm doesn't match");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 15.0,
            ),
            child: Form(
                key: _formkey,
                child: ListView(children: [
                  /*Container(
                padding: EdgeInsets.fromLTRB(15.0, 120.0, 15.0, 20.0),
                child: Text('DAAN.',
                    style:
                        TextStyle(fontSize: 100.0, color: Colors.blueAccent)),
              ),*/
                  SizedBox(height: 40.0),
                  TextFormField(
                    controller: _namecontroller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter Email Address',
                        labelText: 'Email Address',
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
                  ),
                  /*TextFormField(
                    controller: _nicknamecontroller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter Nick Name',
                        labelText: 'Nick Name',
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.black,
                        )),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please Enter Nick Name';
                      if (!RegExp(r'^[a-z A-Z 0-9]+$').hasMatch(value))
                        return 'Invalid Nick Name format';
                      return null;
                    },
                  ),*/
                  /*SizedBox(height: 10.0),
                  TextFormField(
                    controller: _phonenumbercontroller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter Phone Number',
                        labelText: 'Phone Number',
                        //MaxLength: 10,
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.black,
                        )),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please Enter Phone Number';
                      if (value.length != 10)
                        return 'Invalid Phone Number format';
                      return null;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _addresscontroller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter Address',
                        labelText: 'Address',
                        prefixIcon: Icon(
                          Icons.calculate,
                          color: Colors.black,
                        )),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please Enter Address';
                      /*if (!RegExp(r'\w+@\w+\.\w+').hasMatch(value))
                    return 'Invalid E-mail Address format';*/
                      return null;
                    },
                  ),*/
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _passwordcontroller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter Password',
                        labelText: 'Password',
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.black,
                        ),
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
                        return '''Password atleast 8 characters include one upper case one lower
                  case one symbol''';
                      return null;
                    }, //password atleast 8 characters one upper case one lower case one symbol
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _confirmpasswordcontroller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Confirm Password',
                        labelText: 'Confirm Password',
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.black,
                        ),
                        suffixIcon: IconButton(
                            icon: Icon(_securedText1
                                ? Icons.remove_red_eye
                                : Icons.security),
                            onPressed: () {
                              setState(() {
                                _securedText1 = !_securedText1;
                              });
                            })),
                    obscureText: _securedText1,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please Enter Password';
                      if (_passwordcontroller.text !=
                          _confirmpasswordcontroller.text)
                        return 'Password Do Not Match ';
                      return null;
                    },
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    padding: EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                    ),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                        onPressed: () {
                          print('name' + _namecontroller.text);
                          print('password = ' + _passwordcontroller.text);
                          if (_formkey.currentState!.validate())
                            setState(() {
                              name = _namecontroller.text;
                              password = _passwordcontroller.text;
                              confirmPassword = _confirmpasswordcontroller.text;
                            });
                          registration();
                        },
                        child: Text('SIGN UP')),
                  ),
                  Container(
                      padding: EdgeInsets.only(
                        left: 10.0,
                        right: 10.0,
                      ),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Center(child: Text('GO BACK'))))
                ]))));
  }
}
