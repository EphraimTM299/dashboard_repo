import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:store_responsive_dashboard/constants/size_config.dart';
import 'package:store_responsive_dashboard/providers/currentUser.dart';
import 'package:store_responsive_dashboard/root.dart';

class SignUpSuccess extends StatefulWidget {
  const SignUpSuccess({super.key});

  @override
  State<SignUpSuccess> createState() => _SignUpSuccessState();
}

class _SignUpSuccessState extends State<SignUpSuccess> {
  @override
  void initState() {
    Future.delayed(Duration(days: 1), () {
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(child: Root(), type: PageTransitionType.fade),
          (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: height * 0.04),
            ClipOval(
              child: Container(
                color: Colors.green[100],
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.height / 3,
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: ClipOval(
                    child: Container(
                      color: Colors.green,
                      height: MediaQuery.of(context).size.height / 8,
                      width: MediaQuery.of(context).size.height / 8,
                      child: Icon(
                        Icons.done_rounded,
                        color: Colors.white,
                        size: 120,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.3),
            Column(
              children: [
                Text(
                  'Signed Up Successfully!!!',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(30),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Welcome to teillo, We are pleased to have you Onboard",
                  style: TextStyle(fontSize: width * 0.01),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "We have sent a verification email to ${Provider.of<CurrentUser>(context, listen: false).getCurrentUser?.email}.",
                  style: TextStyle(fontSize: width * 0.01),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
