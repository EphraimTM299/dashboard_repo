import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_responsive_dashboard/models/products.dart';
import 'package:store_responsive_dashboard/providers/currentUser.dart';

class Laundry extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//  userDetails

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

  int? bankAccountNumber;
  String? bankName;
  int? branchCode;
  String? accountHolder;

  // update use data

  void updateUserData(
    // user

    String newUserName,
    String newPhoneNumber,
    String newRole,
    String newEmail,
  ) {
    userName = newUserName;
    phoneNumber = newPhoneNumber;
    role = newRole;
    email = newEmail;

    // Notify Listners
    notifyListeners();
  }

// business data update

  void updateBusinessData(
      String newAddress,
      String newName,
      String newCity,
      double newRating,
      String newTurnAround,
      String newLaundromatName,
      GeoPoint newLocation,
      double newDistance,
      String newLaundryType,
      String newNumberOfLocations) {
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
  }

  void updateBankDetails(String newBankName, int newAccountNumber,
      int newBranchCode, String newAccountHolder) {
    branchCode = newBranchCode;
    bankAccountNumber = newAccountNumber;
    accountHolder = newAccountHolder;
    bankName = newBankName;

    // Notify Listners
    notifyListeners();
  }

  void createLaundromat(BuildContext context) {
    _firestore.collection("laundromat").add({
      "uid":
          Provider.of<CurrentUser>(context, listen: false).getCurrentUser?.uid,
      "laundryType": laundryType,
      "laundromatName": laundromatName,
      "accountCreated": Timestamp.now(),
      "status": "Inactive",
      "rating": rating,
      "distance": distance,
      "turnAround": turnAround,
      "special_offers": specialOffers,
      "imagePath": "",
      "city": city,
      "numberOfLocation": numberOfLocations,
      "address": address,
      "role": role,
      "location": location,
      "email": email,
      "userName": userName,
      "userPhone": phoneNumber,
      "userEmail": email,
      "userUid":
          Provider.of<CurrentUser>(context, listen: false).getCurrentUser?.uid
    });
  }

  notifyListeners();
}
