import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class forgotpassword extends StatefulWidget {
  const forgotpassword({Key? key}) : super(key: key);

  @override
  _forgotpasswordState createState() => _forgotpasswordState();
}

class _forgotpasswordState extends State<forgotpassword> {
  TextEditingController _emailcontroller = TextEditingController();
  var email = '';
  var _formkey = GlobalKey<FormState>();
  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Password Reset Email Has Been Send',
              style: TextStyle(fontSize: 18.0))));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('No User Found For That Email.',
                style: TextStyle(fontSize: 18.0))));
      }
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
                child: Text('RESET PASSWORD LINK IS SEND TO YOUR EMAIL ID.',
                    style:
                        TextStyle(fontSize: 20.0, color: Colors.blueAccent)),
              ),*/
                  SizedBox(height: 240.0),
                  TextFormField(
                    controller: _emailcontroller,
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
                          print('email' + _emailcontroller.text);

                          if (_formkey.currentState!.validate())
                            setState(() {
                              email = _emailcontroller.text;
                            });
                          resetPassword();
                        },
                        child: Text('SEND E-MAIL')),
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
