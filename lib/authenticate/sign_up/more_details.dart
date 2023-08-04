import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:store_responsive_dashboard/authenticate/sign_up/signup_successful.dart';
import 'package:store_responsive_dashboard/components/constants.dart';
import 'package:store_responsive_dashboard/components/keyboard.dart';
import 'package:store_responsive_dashboard/constants/custom_surfix_icon.dart';
import 'package:store_responsive_dashboard/constants/default_button.dart';
import 'package:store_responsive_dashboard/constants/form_error.dart';
import 'package:store_responsive_dashboard/constants/size_config.dart';
import 'package:store_responsive_dashboard/providers/currentUser.dart';
import 'package:store_responsive_dashboard/providers/laundromat.dart';
import 'package:store_responsive_dashboard/widgets/responsive.dart';

class MoreDetails extends StatefulWidget {
  const MoreDetails({super.key});

  @override
  State<MoreDetails> createState() => _MoreDetailsState();
}

class _MoreDetailsState extends State<MoreDetails> {
  @override
  void initState() {
    loadImage();
    super.initState();
  }

  final formKey = GlobalKey<FormState>();
  final List<String> roleItems = ['Manager', 'Owner'];

  loadImage() {
    asset = SvgPicture.asset("/icons/signUp.svg");
  }

  SvgPicture? asset;
  String? selectedValue;
  String turnAround = '';
  String status = 'Inactive';

  String city = ' ';
  String error = '';
  bool loading = true;

  final CurrentUser _auth = CurrentUser();
  final jobRole = TextEditingController();

  // void _signUpUser(String email, String password, BuildContext context) async {
  //   CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);

  //   try {
  //     if (await _currentUser.signUpWithEmailAndPassword(email, password)) {
  //       print("user signed up");
  //     }
  //   } catch (e) {}
  // }

  void displayMessage(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              icon: Icon(Icons.error),
              title: (Text(message)),
            ));
  }

  bool remember = false;
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
    print(Provider.of<Laundry>(context, listen: false).email);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: height,
          width: width,
          child: Row(
            children: [
              ResponsiveWidget.isSmallScreen(context)
                  ? const SizedBox()
                  : Expanded(
                      child: Center(
                        child: Container(
                          height: height * .65,
                          child: asset,
                        ),
                      ),
                    ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: SizedBox(
                        width: ResponsiveWidget.isSmallScreen(context)
                            ? width * 0.85
                            : 400,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 15), // 4%
                                Text("Register Business - Step 2",
                                    style: headingStyle),
                                const SizedBox(
                                  height: 10,
                                ),

                                Text(
                                  "Join the Team, Let's build together.",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 15),
                                Column(
                                  children: [
                                    Form(
                                      key: formKey,
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 15),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          buildTurnAroundTimeFormField(),
                                          const SizedBox(height: 15),
                                          Text(
                                              "Please Upload a pdf or picture of your Pricelist"),
                                          const SizedBox(height: 15),
                                          SizedBox(
                                            width: width * 0.10,
                                            height:
                                                getProportionateScreenHeight(
                                                    60),
                                            child: ElevatedButton(
                                              style: TextButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                primary: Colors.white,
                                                backgroundColor:
                                                    Colors.blue[300],
                                              ),
                                              onPressed: () {},
                                              child: Text(
                                                "Upload Pricelist",
                                                style: TextStyle(
                                                  fontSize:
                                                      getProportionateScreenWidth(
                                                          18),
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          FormError(errors: errors),
                                          const SizedBox(height: 15),
                                          DefaultButton(
                                            text: "Complete  Registration",
                                            press: () async {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  loading = true;
                                                });

                                                Navigator.push(
                                                    context,
                                                    PageTransition(
                                                        child: SignUpSuccess(),
                                                        type: PageTransitionType
                                                            .fade));

                                                // await UserSimplePreferences
                                                //     .setUserEmail(email);
                                                // await UserSimplePreferences.setUserName(
                                                //     userName);
                                                // await UserSimplePreferences
                                                //     .setUserPhone(phoneNumber);

                                                KeyboardUtil.hideKeyboard(
                                                    context);

                                                // dynamic result = await _auth
                                                //     .signUpWithEmailAndPassword(
                                                //         role,
                                                //         email,
                                                //         password,
                                                //         userName,
                                                //         phoneNumber,
                                                //         address,
                                                //         laundromatName);

                                                // if (result == "success") {
                                                //   setState(() {
                                                //     loading = false;
                                                //     Navigator
                                                //         .pushAndRemoveUntil(
                                                //       context,
                                                //       MaterialPageRoute(
                                                //         builder: (context) =>
                                                //             LaundryDetails(),
                                                //       ),
                                                //       (route) => false,
                                                //     );
                                                //   });
                                                // } else {
                                                //   setState(() {
                                                //     loading = false;
                                                //   });
                                                // }

                                                Provider.of<Laundry>(context,
                                                        listen: false)
                                                    .createLaundromat(context);
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     const Text(
                                //       "Already a user? ",
                                //       style: TextStyle(fontSize: 18),
                                //     ),
                                //     GestureDetector(
                                //       onTap: () {},
                                //       child: const Text(
                                //         "Sign In",
                                //         style: TextStyle(
                                //             fontSize: 18, color: kPrimaryColor),
                                //       ),
                                //     ),
                                //   ],
                                // ),

                                const SizedBox(height: 15),

                                Text(
                                  'By continuing your confirm that you agree \nwith our Terms and Conditions',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 15),
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
        ));
  }

  TextFormField buildCityFormField() {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          city = value;
        });

        if (value.isNotEmpty) {
          removeError(error: kcitylNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kcitylNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Turn Around Time",
        hintText: "e.g. 24 hrs",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "/icons/Mail.svg"),
      ),
    );
  }

  TextFormField buildTurnAroundTimeFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          turnAround = value;
        });

        if (value.isNotEmpty) {
          removeError(error: kcitylNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kcitylNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Turn Around Time",
        hintText: "e.g. 24 or 48 hrs",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "/icons/User.svg"),
      ),
    );
  }
}
