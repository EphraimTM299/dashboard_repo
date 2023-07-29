// ignore_for_file: unused_local_variable

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:get/get.dart';
import 'package:store_responsive_dashboard/constants/theme.dart';

import 'package:store_responsive_dashboard/providers/currentUser.dart';
import 'package:store_responsive_dashboard/providers/ordersData.dart';
import 'package:store_responsive_dashboard/root.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString("email");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CurrentUser()),
        ChangeNotifierProvider(create: (context) => OrdersData()),
      ],
      child: GetMaterialApp(
        title: 'Laundry Admin Dashboard',
        theme: theme(),
        home: Root(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
