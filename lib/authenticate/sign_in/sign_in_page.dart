import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_responsive_dashboard/components/constants.dart';
import 'package:store_responsive_dashboard/components/keyboard.dart';
import 'package:store_responsive_dashboard/constants/custom_surfix_icon.dart';
import 'package:store_responsive_dashboard/constants/default_button.dart';
import 'package:store_responsive_dashboard/constants/form_error.dart';
import 'package:store_responsive_dashboard/pages/example.dart';

import 'package:store_responsive_dashboard/providers/currentUser.dart';
import 'package:store_responsive_dashboard/root.dart';
import 'package:store_responsive_dashboard/widgets/responsive.dart';

import '../../../constants/size_config.dart';

class SignInPage extends StatefulWidget {
  final Function toggleView;
  static String routeName = "/sign_in";

  SignInPage({
    super.key,
    required this.toggleView,
  });

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  loadImage() {
    asset = SvgPicture.asset("/icons/signIn.svg");
  }

  SvgPicture? asset;

  final CurrentUser _auth = CurrentUser();

  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  void initState() {
    loadImage();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        loading = false;
      });
    });

    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  bool? remember = false;

  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    print(width);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SafeArea(
        child: SizedBox(
          height: height,
          width: width,
          child: Row(
            children: [
              ResponsiveWidget.isSmallScreen(context)
                  ? SizedBox()
                  : Expanded(
                      child: Center(
                      child: Container(
                        height: height * 0.5,
                        child: asset,
                      ),
                    )),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: SizedBox(
                        width: ResponsiveWidget.isSmallScreen(context)
                            ? width * 0.85
                            : 400,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                    height: SizeConfig.screenHeight * 0.04),
                                Text(
                                  "Welcome Back",
                                  style: headingStyle,
                                ),
                                const Text(
                                  "Sign in with your email and password",
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                    height: SizeConfig.screenHeight * 0.08),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      buildEmailFormField(),
                                      const SizedBox(height: 10),
                                      buildPasswordFormField(),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: remember,
                                            activeColor: kPrimaryColor,
                                            onChanged: (value) {
                                              setState(() {
                                                remember = value;
                                              });
                                            },
                                          ),
                                          const Text("Remember me"),
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () {},
                                            child: const Text(
                                              "Forgot Password",
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline),
                                            ),
                                          )
                                        ],
                                      ),
                                      FormError(errors: errors),
                                      const SizedBox(height: 10),
                                      DefaultButton(
                                        text: "Continue",
                                        press: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            // setState(() {
                                            //   loading = true;
                                            // });
                                            SharedPreferences pref =
                                                await SharedPreferences
                                                    .getInstance();
                                            pref.setString("email", email);
                                            pref.setString(
                                                "password", password);

                                            KeyboardUtil.hideKeyboard(context);

                                            dynamic result = await _auth
                                                .signInWithEmailAndPassword(
                                                    email, password);

                                            if (result == "success") {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Root(),
                                                ),
                                              );
                                            } else {
                                              setState(() {
                                                loading = false;
                                                error =
                                                    "Please give me the correct details";
                                              });
                                            }
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                        child: Text(error),
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Don’t have an account? ",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        widget.toggleView();
                                      },
                                      child: const Text(
                                        "Sign Up",
                                        style: TextStyle(
                                            fontSize: 16, color: kPrimaryColor),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onChanged: (value) {
        setState(() {
          password = value;
        });

        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 6) {
          removeError(error: kShortPassError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 5) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      initialValue: email,
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) {
        setState(() {
          email = value;
        });

        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
