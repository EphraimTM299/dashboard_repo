import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_responsive_dashboard/authenticate/authenticate.dart';
import 'package:store_responsive_dashboard/constants/default_button.dart';
import 'package:store_responsive_dashboard/pages/example.dart';
import 'package:store_responsive_dashboard/root.dart';
import 'package:store_responsive_dashboard/widgets/responsive.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // User created before
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    //sending verification emails
    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async {
    // call after email verification!
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return isEmailVerified
        ? MyHomepage()
        : Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Container(
                width: ResponsiveWidget.isMediumScreen(context)
                    ? 400
                    : ResponsiveWidget.isSmallScreen(context)
                        ? 300
                        : width * 0.30,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 150,
                            width: 150,
                            child: Image.asset("assets/images/mail.png")),
                        SizedBox(
                          height: 20,
                        ),
                        const Text(
                          textAlign: TextAlign.center,
                          " A Verification Email has \nbeen sent to your Email Address\n\nTo continue check your email and verify.",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        DefaultButton(
                            press: sendVerificationEmail, text: "Resend Email"),
                        const SizedBox(
                          height: 10,
                        ),
                        DefaultButton(
                            press: () {
                              FirebaseAuth.instance.signOut;
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Root()),
                                  (route) => false);
                            },
                            text: "Cancel"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
