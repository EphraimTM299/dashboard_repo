import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocode/geocode.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:store_responsive_dashboard/authenticate/sign_up/more_details.dart';
import 'package:store_responsive_dashboard/authenticate/sign_up/signup_successful.dart';
import 'package:store_responsive_dashboard/components/constants.dart';
import 'package:store_responsive_dashboard/components/keyboard.dart';
import 'package:store_responsive_dashboard/constants/custom_surfix_icon.dart';
import 'package:store_responsive_dashboard/constants/default_button.dart';
import 'package:store_responsive_dashboard/constants/form_error.dart';
import 'package:store_responsive_dashboard/constants/size_config.dart';
import 'package:store_responsive_dashboard/providers/laundromat.dart';
import 'package:store_responsive_dashboard/widgets/autocomplate_prediction.dart';
import 'package:store_responsive_dashboard/widgets/location_list_tile.dart';
import 'package:store_responsive_dashboard/widgets/network_utility.dart';

import 'package:store_responsive_dashboard/providers/currentUser.dart';
import 'package:store_responsive_dashboard/widgets/place_auto_complate_response.dart';
import 'package:store_responsive_dashboard/widgets/responsive.dart';
import 'package:flutter_google_places_web/flutter_google_places_web.dart';

class BankAccount extends StatefulWidget {
  const BankAccount({super.key});

  @override
  State<BankAccount> createState() => _BankAccountState();
}

class _BankAccountState extends State<BankAccount> {
  var kGoogleApiKey = apiKey;

  @override
  void initState() {
    super.initState();
  }

// address
  final userAddressController = TextEditingController();
  // final LocatitonGeocoder geocoder = LocatitonGeocoder(apiKey);
  List<AutocompletePrediction> placePredictions = [];
  Timer? debounce;
  FocusNode focusNode = FocusNode();
  UploadTask? uploadTask;

// forms
  final formKey = GlobalKey<FormState>();

  // signup items
  final List<String> accountItems = [
    'Current/Transmission',
    'Savings',
  ];
  final List<String> bankNameList = [
    'FNB',
    'Nedbank',
    "RMB Private",
    "Absa",
    "Capitec",
    "African Bank",
    "Bank of Athens",
    "Bidvest Bank",
    "CitiBank"
  ];
  final List<String> laundryType = [
    'Laundromat',
    'Dry Cleaner',
    "Shoe Laundry",
    "Carpet Cleaner",
    "Laundromat & Dry Cleaner"
  ];
  final List<String> number = ["1", "2", "3", "4", "5 or more"];

// images loading
  loadImage() {
    asset = SvgPicture.asset("/icons/signUp.svg");
  }

  PlatformFile? pickedFile;
  FilePickerResult? result;
// upload to firebase
  Future uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    final path = 'pricelist/${pickedFile!.name}';
//  final ref =FirebaseStorage.instance.ref().child('$dirpath$filename');

    final file = File(pickedFile!.path!);
    Uint8List uploadfile = result?.files.single.bytes ?? Uint8List(1);

    // String filename = basename(result?.files.single.name);

    // upload file to firebase
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putData(uploadfile);

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    // Url Download
    print("Download Link:$urlDownload");
  }

// selecting the file
  Future selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  // banking
  String bankAccountNumber = "";
  String branchCode = "";
  String bankName = "";
  String bankAccountType = "";
  String bankAccountName = "";
  String accountHolder = '';

  SvgPicture? asset;

  String? selectedValue;

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
    print(Provider.of<Laundry>(context, listen: false).bankName);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            SizedBox(
              height: 200,
              width: width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 18, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Account balances",
                          style: TextStyle(fontSize: 25),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: width * 0.30,
                          child: Text(
                            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever\nsince the 1500s,",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: width * .45,
                    height: height * 0.15,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          color: Colors.grey[200],
                          child: Totals(
                              subTotal: 300, deliveryFee: 50, Total: 350)),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(left: 18, top: 20, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Payout Details",
                        style: TextStyle(fontSize: 25),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: width * 0.3,
                        child: Text(
                          "Lorem Ipsum is simply dummy text of the printing and \ntypesetting industry. Lorem Ipsum has been the industry's standard dummy text ever\nsince the 1500s,",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Column(
                  children: [
                    Container(
                      width: width * .45,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 2,
                          color: Colors.grey[100],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: SizedBox(
                            width: ResponsiveWidget.isSmallScreen(context)
                                ? width * 0.85
                                : 400,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  const SizedBox(height: 15), // 4%

                                  Text(
                                    "Please complete the following bank account details.",
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 20),
                                  Column(
                                    children: [
                                      Form(
                                        key: formKey,
                                        child: Column(
                                          children: [
                                            Text("Bank Account Details",
                                                style: headingStyle),
                                            const SizedBox(height: 15),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: SizedBox(
                                                      width: width * .15,
                                                      child:
                                                          buildAccountDropdown()),
                                                ),
                                                SizedBox(
                                                  width: 25,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                      width: width * .15,
                                                      child:
                                                          buildAccountTypeDropdown()),
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 30),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: SizedBox(
                                                      width: width * .15,
                                                      child:
                                                          buildBranchFormField()),
                                                ),
                                                SizedBox(
                                                  width: 25,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                      width: width * .15,
                                                      child:
                                                          buildBranchCodeFormField()),
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 30),

                                            Row(
                                              children: [
                                                Expanded(
                                                  child: SizedBox(
                                                      width: width * .15,
                                                      child:
                                                          buildAccountNumberFormField()),
                                                ),
                                                SizedBox(
                                                  width: 25,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                      width: width * .15,
                                                      child:
                                                          buildAccountHolder()),
                                                )
                                              ],
                                            ),
                                            // SizedBox(
                                            //     height:
                                            //         pickedFile?.name == null
                                            //             ? 15
                                            //             : 0),
                                            // pickedFile?.name == null
                                            //     ? SizedBox()
                                            //     : SizedBox(
                                            //         height: 100,
                                            //         child: Center(
                                            //           child: Row(
                                            //             mainAxisAlignment:
                                            //                 MainAxisAlignment
                                            //                     .center,
                                            //             children: [
                                            //               Icon(Icons
                                            //                   .file_copy_outlined),
                                            //               SizedBox(
                                            //                 width: 5,
                                            //               ),
                                            //               Text(pickedFile
                                            //                       ?.name ??
                                            //                   ''),
                                            //             ],
                                            //           ),
                                            //         ),
                                            //       ),
                                            // pickedFile?.name == null
                                            //     ? Text(
                                            //         "Please Upload Bank Account Confirmation")
                                            //     : SizedBox(),
                                            // SizedBox(
                                            //     height:
                                            //         pickedFile?.name == null
                                            //             ? 15
                                            //             : 0),
                                            // pickedFile?.name == null
                                            //     ? SizedBox(
                                            //         width: width * 0.10,
                                            //         height:
                                            //             getProportionateScreenHeight(
                                            //                 60),
                                            //         child: ElevatedButton(
                                            //           style: TextButton
                                            //               .styleFrom(
                                            //             shape: RoundedRectangleBorder(
                                            //                 borderRadius:
                                            //                     BorderRadius
                                            //                         .circular(
                                            //                             15)),
                                            //             primary: Colors.white,
                                            //             backgroundColor:
                                            //                 Colors.blue[300],
                                            //           ),
                                            //           onPressed: () {
                                            //             selectFile();
                                            //           },
                                            //           child: Text(
                                            //             "Select File",
                                            //             style: TextStyle(
                                            //               fontSize:
                                            //                   getProportionateScreenWidth(
                                            //                       18),
                                            //               color: Colors.white,
                                            //             ),
                                            //           ),
                                            //         ),
                                            //       )
                                            //     : SizedBox(),
                                            // SizedBox(
                                            //     height:
                                            //         pickedFile?.name == null
                                            //             ? 15
                                            //             : 0),
                                            FormError(errors: errors),
                                            const SizedBox(height: 15),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                SizedBox(
                                                  width: width * .10,
                                                  height:
                                                      getProportionateScreenHeight(
                                                          60),
                                                  child: TextButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        side: BorderSide(
                                                            color:
                                                                kPrimaryColor),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                        primary: Colors.white,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                      ),
                                                      onPressed: () {},
                                                      child: Text(
                                                        "Cancel",
                                                        style: TextStyle(
                                                            color:
                                                                kPrimaryColor),
                                                      )),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                SizedBox(
                                                  width: width * .10,
                                                  child: DefaultButton(
                                                    text: "Save",
                                                    press: () async {
                                                      if (formKey.currentState!
                                                          .validate()) {
                                                        setState(() {
                                                          loading = true;
                                                          Provider.of<Laundry>(
                                                                  context,
                                                                  listen: false)
                                                              .updateBankDetails(
                                                                  bankAccountName,
                                                                  bankAccountNumber,
                                                                  branchCode,
                                                                  accountHolder,
                                                                  bankAccountType);
                                                        });

                                                        KeyboardUtil
                                                            .hideKeyboard(
                                                                context);
                                                        Provider.of<Laundry>(
                                                                context,
                                                                listen: false)
                                                            .updateBankAccount(
                                                                context);
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
              ],
            ),
          ],
        ));
  }

  Widget buildAccountDropdown() {
    return DropdownButtonFormField2<String>(
      style: TextStyle(fontSize: 16),
      isDense: true,
      isExpanded: false,
      decoration: InputDecoration(
        focusColor: Colors.transparent,
        labelText: "Bank",
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
        // Add Horizontal padding using menuItemStyleData.padding so it matches
        // the menu padding when button's width is not specified.

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        // Add more decoration..
      ),
      hint: const Text(
        'Bank Name',
        // style: TextStyle(fontSize: 14),
      ),
      items: bankNameList
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
          return 'Please Select your Bank Name';
        }
        return null;
      },
      onChanged: (value) {
        bankAccountName = value ?? '';
      },
      onSaved: (value) {
        selectedValue = value.toString();
      },
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 0),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
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
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  Widget buildAccountTypeDropdown() {
    return DropdownButtonFormField2<String>(
      isDense: true,
      isExpanded: false,
      decoration: InputDecoration(
        labelText: "Account Type",
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
        // Add Horizontal padding using menuItemStyleData.padding so it matches
        // the menu padding when button's width is not specified.

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        // Add more decoration..
      ),
      hint: const Text(
        'Account Type',
        // style: TextStyle(fontSize: 14),
      ),
      items: accountItems
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
          return 'Please Select your Bank Type';
        }
        return null;
      },
      onChanged: (value) {
        bankAccountType = value ?? '';
      },
      onSaved: (value) {
        selectedValue = value.toString();
      },
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 0),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
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
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  TextFormField buildBranchCodeFormField() {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          branchCode = value;
        });

        if (value.isNotEmpty) {
          removeError(error: kBusinessNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kBusinessNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Branch Code",
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
        hintText: "Branch Code",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildAccountHolderFormField() {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          branchCode = value;
        });

        if (value.isNotEmpty) {
          removeError(error: kBusinessNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kBusinessNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Account Holder",
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
        hintText: "Account Holder",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildAccountHolder() {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          accountHolder = value;
        });

        if (value.isNotEmpty) {
          removeError(error: kBusinessNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kBusinessNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Account Holder",
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
        hintText: " Account Holder",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "/icons/Mail.svg"),
      ),
    );
  }

  TextFormField buildBranchFormField() {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          bankAccountName = value;
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
        labelText: "Branch Name",
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
        hintText: "Branch Name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "/icons/User.svg"),
      ),
    );
  }

  TextFormField buildAccountNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          bankAccountNumber = value;
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
        labelText: "Account Number",
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
        hintText: "Account Number",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "/icons/Phone.svg"),
      ),
    );
  }
}

class Totals extends StatelessWidget {
  const Totals({
    super.key,
    required this.subTotal,
    required this.deliveryFee,
    required this.Total,
  });

  final double subTotal;
  final double deliveryFee;
  final double Total;

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 100, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Current Balance",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 17,
                ),
              ),
              Text(
                '${subTotal.toStringAsFixed(2)}',
                style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.black),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 50.0,
            right: 100,
            top: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Available for Payout",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 17,
                ),
              ),
              Text(
                '${deliveryFee.toStringAsFixed(2)}',
                style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.black),
              )
            ],
          ),
        ),
      ],
    );
  }
}
