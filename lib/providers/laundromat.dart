import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_responsive_dashboard/models/User.dart';
import 'package:store_responsive_dashboard/models/products.dart';
import 'package:store_responsive_dashboard/providers/currentUser.dart';

class Laundry extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//  userDetails
  String? uid;
  String? userName;
  String? phoneNumber;
  String? role;
  String? email;

//  laundromat details

  String? address;
  String? laundromatName;
  String? imagePath;
  GeoPoint? location;
  String? laundryType;

  List<Products>? products;
  double? distance;
  double? rating;
  String? city;
  String? turnAround;
  String? specialOffers;
  String? numberOfLocations;

  // banking

  String? bankAccountNumber;
  String? bankName;
  String? branchCode;
  String? accountHolder;
  String? accountType;

  // update use data

  void updateUserData(
      // user

      String newUserName,
      String newPhoneNumber,
      String newRole,
      String newEmail,
      String newLaundromatName) {
    userName = newUserName;
    phoneNumber = newPhoneNumber;
    role = newRole;
    email = newEmail;
    laundromatName = newLaundromatName;

    // Notify Listners
    notifyListeners();
  }

// business data update

  void updateBusinessData(
    String newUserName,
    String newPhoneNumber,
    String newRole,
    String newEmail,
    String newLaundromatName,
    String newAddress,
    String newName,
    String newCity,
    double newRating,
    String newTurnAround,
    GeoPoint newLocation,
    double newDistance,
    String newLaundryType,
    String newNumberOfLocations,
    String newUid,
  ) {
    // variables

    turnAround = newTurnAround;
    rating = newRating;
    address = newAddress;
    laundryType = newLaundryType;
    distance = newDistance;
    turnAround = newTurnAround;
    city = newCity;
    location = newLocation;
    numberOfLocations = newNumberOfLocations;
    laundromatName = newLaundromatName;
    userName = newUserName;
    phoneNumber = newPhoneNumber;
    role = newRole;
    email = newEmail;
    uid = newUid;
    laundromatName = newLaundromatName;
    if (location != null) {
      print("userUpdated");
    }
  }

  void updateBankDetails(String newBankName, String newAccountNumber,
      String newBranchCode, String newAccountHolder, String newAccountType) {
    branchCode = newBranchCode;
    bankAccountNumber = newAccountNumber;
    accountHolder = newAccountHolder;
    bankName = newBankName;
    accountType = newAccountType;

    // Notify Listners
    notifyListeners();
    if (branchCode != null) {
      print("Branch Code");
    }
  }

  Future updateBankAccount(context) async {
    await _firestore
        .collection("laundromat")
        .doc(
            "${Provider.of<CurrentUser>(context, listen: false).getCurrentUser?.uid}")
        .update({
      "branchCode": branchCode,
      "bankAccountNumber": bankAccountNumber,
      "accountHolder": accountHolder,
      "bankName": bankName,
      "accountType": accountType
    });
  }

  // Future<String> createLaundromat(MyUser? user) async {
  //   String retVal = "error";

  //   try {
  //     await _firestore.collection("laundromat").doc(user?.uid).set({
  //       "laundryType": laundryType,
  //       "laundromatName": laundromatName,
  //       "accountCreated": Timestamp.now(),
  //       "status": "Inactive",
  //       "rating": rating,
  //       "distance": distance,
  //       "deliveryPrice": 0,
  //       "turnAround": turnAround,
  //       "special_offers": specialOffers,
  //       "imagePath": "",
  //       "city": city,
  //       "numberOfLocations": numberOfLocations,
  //       "address": address,
  //       "role": role,
  //       "location": location,
  //       "email": email,
  //       "userName": userName,
  //       "userPhone": phoneNumber,
  //       "userEmail": email,
  //       "userUid": user?.uid
  //     });
  //     retVal = "success";
  //   } catch (e) {
  //     print(e);
  //   }

  //   return retVal;
  // }

  void createLaundromat1(context, String? userUid) async {
    await _firestore.collection("laundromat").doc(userUid).set({
      "laundryType": laundryType,
      "laundromatName": laundromatName,
      "accountCreated": Timestamp.now(),
      "status": "Inactive",
      "rating": rating,
      "distance": distance,
      "deliveryPrice": 0,
      "turnAround": turnAround,
      "special_offers": specialOffers,
      "imagePath": "",
      "city": city,
      "numberOfLocations": numberOfLocations,
      "address": address,
      "role": role,
      "location": location,
      "email": email,
      "userName": userName,
      "userPhone": phoneNumber,
      "userEmail": email,
      "userUid": userUid
    });
  }

  notifyListeners();
}
