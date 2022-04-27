import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project1/assets/tshirticon_icon.dart';
import 'package:project1/pages/buttons.dart';

class clothesForm extends StatefulWidget {
  const clothesForm({Key? key}) : super(key: key);

  @override
  State<clothesForm> createState() => _clothesFormState();
}

class _clothesFormState extends State<clothesForm> {
  File? file;
  CollectionReference clothes =
      FirebaseFirestore.instance.collection('clothes');
  TextEditingController _desccontroller = TextEditingController();
  TextEditingController _qtycontroller = TextEditingController();
  TextEditingController _addcontroller = TextEditingController();
  TextEditingController _pincontroller = TextEditingController();
  TextEditingController _nicknamecontroller = TextEditingController();
  TextEditingController _phonenumbercontroller = TextEditingController();
  var desc = '';
  var qty = '';
  var add = '';
  var pin = '';
  var nickname = '';
  var phno = '';
  File? _image;
  String? downloadURL;
  final imagePicker = ImagePicker();
  var _formkey = GlobalKey<FormState>();
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
    return clothes
        .add({
          'Name': nickname,
          'Phone no': phno,
          'Description': desc,
          'Quantity': qty,
          'Address': add,
          'Pincode': pin,
          'Image': downloadURL
        })
        .then((value) => print('Value Added'))
        .catchError((error) => print('adding user failed $error '));
  }

//uploading the image to firebase storage
  uploadImage() async {
    Reference ref = FirebaseStorage.instance.ref().child('images');
    await ref.putFile(_image!);
    downloadURL = await ref.getDownloadURL();
    //print(downloadURL);
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
                      builder: (context) => buttons(),
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
                    hintText: 'Eg:Shirt for male or female or kids',
                    labelText: 'Clothes Description',
                    labelStyle: TextStyle(fontSize: 20),
                    hintStyle: TextStyle(
                      fontSize: 20.0,
                    ),
                    prefixIcon: Icon(
                      Tshirticon.t_shirt,
                      color: Colors.black,
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please Enter Clothes details';
                  return null;
                },
                maxLines: 3,
              )),
              SizedBox(height: 20.0),
              Container(
                  child: TextFormField(
                controller: _qtycontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Eg Number of clothes',
                    labelText: 'Quantity',
                    labelStyle: TextStyle(fontSize: 20),
                    hintStyle: TextStyle(
                      fontSize: 20.0,
                    ),
                    prefixIcon: Icon(
                      Icons.numbers_sharp,
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
              Text('Address:', style: TextStyle(fontSize: 20.0)),
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
                    return 'Please Enter Address details';
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
              )),
              SizedBox(height: 10.0),
              Center(
                child: Text('Upload image'),
              ),
              SizedBox(height: 10.0),
              Expanded(
                  child: Center(
                child: Container(
                    height: 400,
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
                      print('Address ' + _addcontroller.text);
                      print('Pin code ' + _pincontroller.text);
                      print(downloadURL);
                      if (_formkey.currentState!.validate())
                        setState(() {
                          nickname = _nicknamecontroller.text;
                          phno = _phonenumbercontroller.text;
                          desc = _desccontroller.text;
                          qty = _qtycontroller.text;
                          add = _addcontroller.text;
                          pin = _pincontroller.text;
                          adddata();
                        });
                    },
                    child: Text('DONATE')),
              ),
            ])));
  }
}
