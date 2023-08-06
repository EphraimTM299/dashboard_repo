import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_responsive_dashboard/authenticate/authenticate.dart';

import 'package:store_responsive_dashboard/pages/example.dart';
import 'package:store_responsive_dashboard/pages/orders.dart';
import 'package:store_responsive_dashboard/pages/verification_email.dart';
import 'package:store_responsive_dashboard/providers/currentUser.dart';

enum AuthStatus { notLoggedIn, loggedIn }

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  bool loading = true;

  AuthStatus _authStatus = AuthStatus.notLoggedIn;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    // get state, check current user
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);

    String _returnString = await _currentUser.onStartUp();

    if (_returnString == "success") {
      setState(() {
        _authStatus = AuthStatus.loggedIn;
      });
    }
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic retVal;
    switch (_authStatus) {
      case AuthStatus.notLoggedIn:
        retVal = Authenticate();
        break;
      case AuthStatus.loggedIn:
        retVal = Authenticate();
        break;
      default:
    }

    return loading ? Container() : retVal;
  }
}
