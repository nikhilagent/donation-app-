import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:project1/form/acceptFood.dart';
import 'package:firebase_core/firebase_core.dart';

class Users {
  final String name;
  final String phno;
  final String desc;
  final String qty;
  final String add;
  final String pin;
  final String downloadURL;
  User(
      {this.name,
      this.phno,
      this.desc,
      this.qty,
      this.add,
      this.pin,
      this.downloadURL});

  Map<String, dynamic> toJson() => {
        'Name': name,
        'Phone no': phno,
        'Description': desc,
        'Quantity': qty,
        'Address': add,
        'Pincode': pin,
        'Image': downloadURL,
      };
      static UserfromJson(Map<String,dynamic json>)User(
       name:json['name'],
        phno:json['Phone no'],
       desc:json['Description'],
       qty:json['Quantity'],
       add:json['Address'],
       pin:json['Pincode'],
       downloadURL:json['Image'],
      );
}


Stream<List<User>> readusers() =>
    FirebaseFirestore.instance.collection('food').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => User.fromJSON(doc.data())).toList());