import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:store_responsive_dashboard/components/constants.dart';
import 'package:store_responsive_dashboard/components/keyboard.dart';
import 'package:store_responsive_dashboard/constants/default_button.dart';
import 'package:store_responsive_dashboard/constants/form_error.dart';
import 'package:store_responsive_dashboard/providers/currentUser.dart';
import 'package:store_responsive_dashboard/root.dart';

class LaundryDetails extends StatefulWidget {
  const LaundryDetails({super.key});

  @override
  State<LaundryDetails> createState() => _LaundryDetailsState();
}

class _LaundryDetailsState extends State<LaundryDetails> {
  final formKey = GlobalKey<FormState>();
  final List<String> roleItems = ['Staff', 'Manager', 'Owner'];

  String? selectedValue;

  String userName = '';
  String phoneNumber = '';
  String address = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  String laundromatName = '';
  String location = '';
  String status = 'Inactive';
  String role = '';

  String error = '';
  bool loading = false;

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
    return loading
        ? Container()
        : Scaffold(
            body: Center(
            child: SafeArea(
              child: SizedBox(
                width: 350,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 15), // 4%
                        Text("Register Business", style: headingStyle),
                        const SizedBox(
                          height: 10,
                        ),

                        const Text(
                          "Step 2",
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        Column(
                          children: [
                            Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  DropdownButtonFormField2<String>(
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      // Add Horizontal padding using menuItemStyleData.padding so it matches
                                      // the menu padding when button's width is not specified.
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 16),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      // Add more decoration..
                                    ),
                                    hint: const Text(
                                      'How many locations',
                                      // style: TextStyle(fontSize: 14),
                                    ),
                                    items: roleItems
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                    // fontSize: 14,
                                                    ),
                                              ),
                                            ))
                                        .toList(),
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please select number of locations';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      role = value ?? '';
                                    },
                                    onSaved: (value) {
                                      selectedValue = value.toString();
                                    },
                                    buttonStyleData: const ButtonStyleData(
                                      padding: EdgeInsets.only(right: 8),
                                    ),
                                    iconStyleData: const IconStyleData(
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.black45,
                                      ),
                                      iconSize: 24,
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  buildBusinessPhoneFormField(),
                                  const SizedBox(height: 15),
                                  buildCityFormField(),
                                  const SizedBox(height: 15),
                                  buildServicesOfferedField(),
                                  const SizedBox(height: 15),
                                  buildTurnAroundFormField(),
                                  const SizedBox(height: 15),
                                  FormError(errors: errors),
                                  const SizedBox(height: 10),
                                  DefaultButton(
                                    text: "Register",
                                    press: () async {
                                      if (formKey.currentState!.validate()) {
                                        setState(() {
                                          loading = true;
                                        });

                                        KeyboardUtil.hideKeyboard(context);

                                        dynamic result = await _auth
                                            .signUpWithEmailAndPassword(
                                                email,
                                                password,
                                                userName,
                                                phoneNumber,
                                                laundromatName,
                                                context);

                                        if (result == "success") {
                                          setState(() {
                                            loading = false;
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Root(),
                                              ),
                                              (route) => false,
                                            );
                                          });
                                        } else {
                                          setState(() {
                                            loading = false;
                                          });
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ));
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
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildServicesOfferedField() {
    return TextFormField(
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
        labelText: "Services Offered",
        hintText: "How many services do you offer",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  TextFormField buildCityFormField() {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          userName = value;
        });

        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "City Located",
        hintText: "Enter the City",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildBusinessPhoneFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onChanged: (value) {
        setState(() {
          phoneNumber = value;
        });
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Business Phone",
        hintText: "Enter your Business Phone",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildTurnAroundFormField() {
    return TextFormField(
      obscureText: true,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && password == confirmPassword) {
          removeError(error: kMatchPassError);
        }
        confirmPassword = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((password != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "TurnAround Time",
        hintText: "What is your Turnaround time?",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildLaundryNameFormField() {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          laundromatName = value;
        });

        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Laundromat Name",
        hintText: "Enter your Laundromat Name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
