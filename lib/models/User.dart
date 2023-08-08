// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  String uid;
  String firstName;
  String phoneNumber;
  String laundromatName;
  String? email;
  Timestamp accountCreated;

  MyUser(
      {required this.firstName,
      required this.phoneNumber,
      required this.laundromatName,
      required this.email,
      required this.uid,
      required this.accountCreated});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'Name': firstName,
      'Phone': phoneNumber,
      'Email': email,
      'AccountCreated': accountCreated,
    };
  }

  factory MyUser.fromMap(Map<String, dynamic> map) {
    return MyUser(
      uid: map['uid'] as String,
      firstName: map['userName'] as String,
      phoneNumber: map['userPhone'] as String,
      email: map['userEmail'] != null ? map['userEmail'] as String : null,
      accountCreated: map['accountCreated'] as Timestamp,
      laundromatName: map['laundromatName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MyUser.fromJson(String source) =>
      MyUser.fromMap(json.decode(source) as Map<String, dynamic>);
}
