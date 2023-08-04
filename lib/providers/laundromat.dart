import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  // GeoPoint? location;
  String? laundryType;

  // List?<Products> products;
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

      // laundromat
      String newAddress,
      String newName,
      String newCity,
      double newRating,
      String newTurnAround,
      double newDistance,
      String newLaundryType,
      String newNumberOfLocations) {
    address = newAddress;
    laundromatName = newName;
    laundryType = newLaundryType;
    distance = newDistance;
    turnAround = newTurnAround;
    city = newCity;

    // Notify Listners
    notifyListeners();
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
    _firestore.collection("laundromat").doc().set({
      "uid":
          Provider.of<CurrentUser>(context, listen: false).getCurrentUser?.uid,
      "Name": Provider.of<CurrentUser>(context, listen: false)
          .getCurrentUser
          ?.firstName,
      "Email": Provider.of<CurrentUser>(context, listen: false)
          .getCurrentUser
          ?.email,
      "Phone": Provider.of<CurrentUser>(context, listen: false)
          .getCurrentUser
          ?.phoneNumber,
      "address": Provider.of<CurrentUser>(context, listen: false)
          .getCurrentUser
          ?.address,
      "name": Provider.of<CurrentUser>(context, listen: false)
          .getCurrentUser
          ?.laundromatName,
      "AccountCreated": Timestamp.now(),
      "status": "Inactive",
      "rating": rating,
      "distance": distance,
      "turnAround": turnAround,
      "special_offers": specialOffers,
      "imagePath": "",
      "city": city,
      "numberOfLocation": numberOfLocations,
      "role": role
    });
  }
}
