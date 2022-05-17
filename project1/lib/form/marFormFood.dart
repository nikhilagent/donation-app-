import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project1/form/marButton.dart';
import 'package:project1/pages/buttons.dart';

class marFormFood extends StatefulWidget {
  const marFormFood({Key? key}) : super(key: key);

  @override
  State<marFormFood> createState() => _marFormFoodState();
}

class _marFormFoodState extends State<marFormFood> {
  CollectionReference marfood =
      FirebaseFirestore.instance.collection('marfood');
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _languagecontroller = TextEditingController();
  TextEditingController _authorcontroller = TextEditingController();
  TextEditingController _nicknamecontroller = TextEditingController();
  TextEditingController _phonenumbercontroller = TextEditingController();
  var name = '';
  var lang = '';
  var author = '';
  var lat = ''; //add
  var long = ''; //pin
  var nickname = '';
  var phno = '';
//File? _image;
//String? downloadURL;
  final imagePicker = ImagePicker();
  var _formkey = GlobalKey<FormState>();
  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lastPosition = await Geolocator.getLastKnownPosition();

    setState(() {
      lat = "${position.latitude}";
      long = "${position.longitude}";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Got Your Location ', style: TextStyle(fontSize: 18.0))));
    });
  }

/*imagepicker() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Select A Photo', style: TextStyle(fontSize: 18.0))));
      }
    });
  }
*/
//adding data to database
  Future<void> adddata() {
    return marfood
        .add({
          'Name': name,
          'Type': nickname,
          'Phone no': phno,
          'Quantity': lang,
          'Description': author,
          'Latitude': lat,
          'Longitude': long,
          //'Image': downloadURL
        })
        .then((value) => print('Value Added'))
        .catchError((error) => print('adding user failed $error '));
  }

//uploading the image to firebase storage
/*uploadImage() async {
    final id = DateTime.now().toString();
    Reference ref = FirebaseStorage.instance.ref().child('${id}/images');
    await ref.putFile(_image!);
    downloadURL = await ref.getDownloadURL();
    //print(downloadURL);
  }*/

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
                        builder: (context) => marButton(),
                      ),
                      ((route) => false));
                }),
            title: Text('Daan',
                style: TextStyle(fontSize: 34, color: Colors.black))),
        backgroundColor: Colors.white,
        body: Form(
            key: _formkey,
            child: ListView(children: [
              /*Center(
                  child: Text('DAAN',
                      style:
                          TextStyle(color: Colors.lightBlue, fontSize: 50.0))),
              */
              SizedBox(
                height: 30.0,
              ),
              Container(
                  child: TextFormField(
                controller: _namecontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Name',
                    labelText: 'Name',
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.black,
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please Enter Name';
                  if (!RegExp(r'^[a-z A-Z 0-9]+$').hasMatch(value))
                    return 'Invalid Name format';
                  return null;
                },
              )),
              SizedBox(
                height: 10,
              ),
              Container(
                  child: TextFormField(
                controller: _nicknamecontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Type Of Food',
                    labelText: 'Food',
                    prefixIcon: Icon(
                      Icons.book_online_rounded,
                      color: Colors.black,
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please Enter Name';
                  if (!RegExp(r'^[a-z A-Z 0-9]+$').hasMatch(value))
                    return 'Invalid Name format';
                  return null;
                },
              )),
              SizedBox(
                height: 10,
              ),
              Container(
                  child: TextFormField(
                controller: _authorcontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Description Of Food',
                    labelText: 'Description Of Food',
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.black,
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please Enter Name';
                  if (!RegExp(r'^[a-z A-Z 0-9]+$').hasMatch(value))
                    return 'Invalid Name format';
                  return null;
                },
              )),
              SizedBox(
                height: 10,
              ),
              Container(
                  child: TextFormField(
                controller: _languagecontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Quantity Of Food',
                    labelText: 'Quantity Of Food',
                    prefixIcon: Icon(
                      Icons.language,
                      color: Colors.black,
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please Enter Name';
                  if (!RegExp(r'^[a-z A-Z 0-9]+$').hasMatch(value))
                    return 'Invalid Name format';
                  return null;
                },
              )),
              SizedBox(
                height: 10,
              ),
              Container(
                  child: TextFormField(
                maxLength: 10,
                controller: _phonenumbercontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Phone Number',
                    labelText: 'Phone Number',
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Colors.black,
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please Enter Phone Number';
                  if (!RegExp(r'^[0-9]').hasMatch(value))
                    return 'Invalid Name format';
                  if (value.length != 10) return 'Invalid Phone Number format';
                  return null;
                },
              )),
              SizedBox(height: 10.0),
              Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 0.5,
                  ),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                      onPressed: () async {
                        final status = await Permission.location.request();
                        if (status.isGranted) {
                          getCurrentLocation();
                        } else
                          print('Access denied');
                      },
                      child: Text('location'))),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10,
                ),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                    onPressed: () {
                      print('Name' + _namecontroller.text);
                      print('nick name' + _nicknamecontroller.text);
                      print('phonenumber = ' + _phonenumbercontroller.text);
                      print('Author ' + _authorcontroller.text);
                      print('Language ' + _languagecontroller.text);
                      //print(downloadURL);
                      if (_formkey.currentState!.validate())
                        setState(() {
                          name = _namecontroller.text;
                          nickname = _nicknamecontroller.text;
                          phno = _phonenumbercontroller.text;
                          author = _authorcontroller.text;
                          lang = _languagecontroller.text;
                          adddata();
                        });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Request Completed ',
                              style: TextStyle(fontSize: 18.0))));
                    },
                    child: Text('MAKE A REQUEST')),
              ),
            ])));
  }
}
