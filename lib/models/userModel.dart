import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? id;
  String? uid;
  String? name;
  String? email;
  String? pass;

  String? tokenDevice;
  int? age;

  UserModel(
      {this.id,
      this.uid,
      this.name,
      this.email,
      this.pass,
      this.tokenDevice,
      this.age});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        id: map['id'],
        uid: map['uid'],
        name: map['name'],
        email: map['email'],
        tokenDevice: map['tokenDevice'],
        age: map['age']);
  }

  static String toMap(UserModel user) {
    return json.encode(user);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'name': name,
        'email': email,
        'pass': pass,
        'tokenDevice': tokenDevice,
        'age': age
      };

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return UserModel(
        id: map['id'],
        uid: map['uid'],
        name: map['name'],
        email: map['email'],
        tokenDevice: map['tokenDevice'],
        age: map['age']);
  }
}