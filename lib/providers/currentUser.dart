import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_responsive_dashboard/models/User.dart';
import 'package:store_responsive_dashboard/providers/laundromat.dart';
import 'package:store_responsive_dashboard/services/database.dart';

class CurrentUser extends ChangeNotifier {
  MyUser? _currentUser;

  MyUser? get getCurrentUser => _currentUser;

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> onStartUp() async {
    String retVal = "error";

    User _firebaseUser = await _auth.currentUser!;
    final uid = _firebaseUser.uid;

    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    _currentUser = MyUser.fromMap(userDoc.data() as Map<String, dynamic>);

    retVal = "success";

    notifyListeners();
    return retVal;
  }

  Future<String> signOut() async {
    String retVal = "error";

    try {
      await _auth.signOut();
      _currentUser = null;

      retVal = "success";
    } catch (e) {}
    notifyListeners();
    return retVal;
  }

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    String retVal = "error";
    try {
      UserCredential _authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (_authResult.user != null) {
        _currentUser?.uid = _authResult.user!.uid;
        _currentUser?.email = _authResult.user!.email;
        retVal = "success";
      }
    } catch (e) {
      retVal = e.toString();
      AlertDialog();
    }

    return retVal;
  }

  Future<String> updateLaundromatDetails() async {
    String retVal = "error";
    try {
      retVal = "success";
    } catch (e) {}
    notifyListeners();
    return retVal;
  }

  Future<String> signUpWithEmailAndPassword(
      String role,
      String email,
      String password,
      String firstName,
      String phoneNumber,
      String address,
      String laundromatName) async {
    String retVal = "error";
    MyUser? _user;

    try {
      UserCredential _authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      _user = MyUser(
        firstName: firstName,
        phoneNumber: phoneNumber,
        address: address,
        email: email,
        uid: _authResult.user?.uid ?? "",
        accountCreated: Timestamp.now(),
        laundromatName: laundromatName,
        role: role,
      );

// Create user in Firestore
      String _returnString = await MyDatabase().createUser(_user);
      if (_returnString == "success") {
        retVal = "success";
      }

      if (_authResult.user != null) {
        _currentUser!.uid = _authResult.user!.uid;
        _currentUser!.email = _authResult.user!.email;
        retVal = "success";
      }

      String _returnStringL = await MyDatabase().createLaundromat(_user);
      if (_returnStringL == "success") {
        retVal = "success";
      }

      if (_authResult.user != null) {
        _currentUser!.uid = _authResult.user!.uid;
        _currentUser!.email = _authResult.user!.email;
        retVal = "success";
      }
    } on PlatformException catch (e) {
      retVal = e.toString();
    } catch (e) {
      print(e);
    }

    return retVal;
  }
}
