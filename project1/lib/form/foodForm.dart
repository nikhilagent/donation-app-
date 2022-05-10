import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project1/pages/buttons.dart';

class foodForm extends StatefulWidget {
  const foodForm({Key? key}) : super(key: key);

  @override
  State<foodForm> createState() => _foodFormState();
}

class _foodFormState extends State<foodForm> {
  @override
  File? file;
  CollectionReference food = FirebaseFirestore.instance.collection('food');
  TextEditingController _desccontroller = TextEditingController();
  TextEditingController _qtycontroller = TextEditingController();
  TextEditingController _latcontroller = TextEditingController();
  TextEditingController _longcontroller = TextEditingController();
  TextEditingController _nicknamecontroller = TextEditingController();
  TextEditingController _phonenumbercontroller = TextEditingController();
  var desc = '';
  var qty = '';
  var lat = ''; //add
  var long = ''; //qty
  var nickname = '';
  var phno = '';
  File? _image;
  String? downloadURL;
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

  /*selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Select A Photo', style: TextStyle(fontSize: 18.0))));
    } else {
      final path = result.files.single.path!;
      setState(() {
        file = File(path);
      });
    }
  }*/
  //selection of images from gallery
  imagepicker() async {
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

//adding data to database
  Future<void> adddata() {
    return food
        .add({
          'Name': nickname,
          'Phone no': phno,
          'Description': desc,
          'Quantity': qty,
          'Latitude': lat,
          'Longitude': long,
          'Image': downloadURL
        })
        .then((value) => print('Value Added'))
        .catchError((error) => print('adding user failed $error '));
  }

//uploading the image to firebase storage
  uploadImage() async {
    final id = DateTime.now().toString();
    Reference ref = FirebaseStorage.instance.ref().child('${id}/images');
    await ref.putFile(_image!);
    downloadURL = await ref.getDownloadURL();
    print(downloadURL);
  }

  Widget build(BuildContext context) {
    //final fileName = file != null ? basename(file!.path) : 'No File Selected';
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => buttons(),
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
                controller: _nicknamecontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Name',
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
                maxLength: 10,
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
                  if (value.length != 10) return 'Invalid Phone Number format';
                  return null;
                },
              )),
              SizedBox(height: 10.0),
              Container(
                  child: TextFormField(
                controller: _desccontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Eg:Veg,Aloo ki Sabji and 1 Roti',
                    labelText: 'Food Description',
                    labelStyle: TextStyle(fontSize: 20),
                    hintStyle: TextStyle(
                      fontSize: 20.0,
                    ),
                    prefixIcon: Icon(
                      Icons.fastfood,
                      color: Colors.black,
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please Enter Food details';
                  return null;
                },
                maxLines: 5,
              )),
              SizedBox(height: 20.0),
              Container(
                  child: TextFormField(
                controller: _qtycontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'eg how many persons can eat',
                    labelText: 'Quantity',
                    labelStyle: TextStyle(fontSize: 20),
                    hintStyle: TextStyle(
                      fontSize: 20.0,
                    ),
                    prefixIcon: Icon(
                      Icons.set_meal,
                      color: Colors.black,
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please Enter Quantity details';
                  if (!RegExp(r'[^a-z A-Z]').hasMatch(value))
                    return 'Invalid Quantity Format';
                  return null;
                },
              )),
              SizedBox(height: 20.0),
              /*Text('Address:', style: TextStyle(fontSize: 20.0)),
              Container(
                  child: TextFormField(
                controller: _addcontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Address',
                    labelText: 'Address',
                    labelStyle: TextStyle(fontSize: 20),
                    hintStyle: TextStyle(
                      fontSize: 20.0,
                    ),
                    prefixIcon: Icon(
                      Icons.location_on,
                      color: Colors.black,
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please Enter address details';
                  return null;
                },
                maxLines: 3,
              )),
              SizedBox(height: 20.0),
              Container(
                  child: TextFormField(
                maxLength: 6,
                controller: _pincontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Pin-Code',
                    labelText: 'Enter Pin-Code',
                    labelStyle: TextStyle(fontSize: 20),
                    hintStyle: TextStyle(
                      fontSize: 20.0,
                    ),
                    prefixIcon: Icon(
                      Icons.pin,
                      color: Colors.black,
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please Enter pin-code details';
                  else if (value.length != 6) return 'Enter correct pin code';
                  return null;
                },
              )),*/
              SizedBox(height: 10.0),
              Center(
                child: Text('Upload image'),
              ),
              SizedBox(height: 10.0),
              Expanded(
                  child: Center(
                child: Container(
                    height: 300,
                    width: 320,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: Colors.blueAccent)),
                    child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: _image == null
                                  ? Center(child: Text('No Image Selected'))
                                  : Image.file(_image!),
                            )
                          ]),
                    )),
              )),
              Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 2.5,
                  ),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                      onPressed: () {
                        // selectFile();
                        imagepicker();
                      },
                      child: Text('Select Photo'))),
              // Text(fileName, style: TextStyle(fontSize: 15.0)),
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
                      onPressed: () {
                        // selectFile();
                        if (_image != null)
                          uploadImage().whenComplete(() {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Photo Successfully Uploaded',
                                    style: TextStyle(fontSize: 18.0))));
                          });
                        else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Select A Photo First',
                                  style: TextStyle(fontSize: 18.0))));
                        }
                      },
                      child: Text('Upoald Photo'))),
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
                      print('nick name' + _nicknamecontroller.text);
                      print('phonenumber = ' + _phonenumbercontroller.text);
                      print('Descrption ' + _desccontroller.text);
                      print('Qantity ' + _qtycontroller.text);
                      print('Address ' + _latcontroller.text);
                      print('Pin code ' + _longcontroller.text);
                      print(downloadURL);
                      if (_formkey.currentState!.validate())
                        setState(() {
                          nickname = _nicknamecontroller.text;
                          phno = _phonenumbercontroller.text;
                          desc = _desccontroller.text;
                          qty = _qtycontroller.text;
                          adddata();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Donation Completed',
                                  style: TextStyle(fontSize: 18.0))));
                        });
                    },
                    child: Text('DONATE')),
              ),
            ])));
  }
}
