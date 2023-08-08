import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_web/flutter_google_places_web.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocode/geocode.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:store_responsive_dashboard/authenticate/sign_up/signup_successful.dart';
import 'package:store_responsive_dashboard/components/constants.dart';
import 'package:store_responsive_dashboard/components/keyboard.dart';
import 'package:store_responsive_dashboard/constants/default_button.dart';
import 'package:store_responsive_dashboard/constants/form_error.dart';
import 'package:store_responsive_dashboard/constants/size_config.dart';
import 'package:store_responsive_dashboard/providers/laundromat.dart';
import 'package:store_responsive_dashboard/widgets/responsive.dart';

class MoreDetails extends StatefulWidget {
  const MoreDetails({
    super.key,
  });

  @override
  State<MoreDetails> createState() => _MoreDetailsState();
}

class _MoreDetailsState extends State<MoreDetails> {
  GeoCode geoCode = GeoCode();
  @override
  void initState() {
    loadImage();
    super.initState();
  }

  Future main() async {
    GeoCode geoCode = GeoCode();

    try {
      Coordinates coordinates = await geoCode.forwardGeocoding(
          address: FlutterGooglePlacesWeb.value['name'] ?? '');

      location =
          GeoPoint(coordinates.latitude ?? 0, coordinates.longitude ?? 0);
    } catch (e) {
      print(e);
    }
  }

  // Future<GeoPoint> geoCodedResult(String laundryAddress) async {
  //   Coordinates coordinates = await geoCode.forwardGeocoding(
  //     address: address,
  //   );

  //   var latitude = coordinates.latitude;
  //   var longitude = coordinates.longitude;
  //   location = GeoPoint(latitude ?? 0.0, longitude ?? 0.0);

  //   laundryLocation = location ?? GeoPoint(0, 0);

  //   return laundryLocation;
  // }

  String address = '';
  String laundromatName = '';
  GeoPoint? location;

  String status = 'Inactive';
  String role = '';
  String numberOfLocations = '';
  String laundryT = '';
  String city = '';
  String turnAround = '';
  double distance = 0.0;
  double rating = 0.0;

  final List<String> laundryType = [
    'Laundromat',
    'Dry Cleaner',
    "Shoe Laundry",
    "Carpet Cleaner",
    "Laundromat & Dry Cleaner"
  ];

  final List<String> number = ["1", "2", "3", "4", "5 or more"];

  PlatformFile? pickedFile;
// upload to firebase
  Future uploadFile() async {
    final path = 'pricelist/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    // upload file to firebase
    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);
  }

// selecting the file
  Future selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  final formKey = GlobalKey<FormState>();
  final List<String> roleItems = ['Manager', 'Owner'];

  loadImage() {
    asset = SvgPicture.asset("/icons/signUp.svg");
  }

  SvgPicture? asset;
  String? selectedValue;

  String error = '';

  // final CurrentUser _auth = CurrentUser();
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
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text("Business Details",
                                              style: headingStyle),
                                          const SizedBox(height: 15),
                                          buildLaundryTypeDropdown(),
                                          const SizedBox(height: 15),
                                          FlutterGooglePlacesWeb(
                                            decoration: InputDecoration(
                                              labelText: "Address",
                                              hintText:
                                                  "Enter your Business Address",
                                            ),
                                            apiKey: apiKey,
                                            components: "country:za",
                                            proxyURL:
                                                'https://cors-anywhere.herokuapp.com/',
                                            required: true,
                                          ),
                                          const SizedBox(height: 15),
                                          buildNumberOfLocations(),
                                          const SizedBox(height: 15),
                                          buildTurnAroundTimeFormField(),
                                          FormError(errors: errors),
                                          SizedBox(
                                              height: pickedFile?.name == null
                                                  ? 15
                                                  : 0),
                                          pickedFile?.name == null
                                              ? SizedBox()
                                              : SizedBox(
                                                  height: 100,
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(Icons
                                                            .file_copy_outlined),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(pickedFile?.name ??
                                                            ''),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                          pickedFile?.name == null
                                              ? Text(
                                                  "Please Upload a copy of your Pricelist")
                                              : SizedBox(),
                                          SizedBox(
                                              height: pickedFile?.name == null
                                                  ? 15
                                                  : 0),
                                          pickedFile?.name == null
                                              ? SizedBox(
                                                  width: width * 0.10,
                                                  height:
                                                      getProportionateScreenHeight(
                                                          60),
                                                  child: ElevatedButton(
                                                    style: TextButton.styleFrom(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15)),
                                                      primary: Colors.white,
                                                      backgroundColor:
                                                          Colors.blue[300],
                                                    ),
                                                    onPressed: () {
                                                      selectFile();
                                                    },
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
                                                )
                                              : SizedBox(),
                                          SizedBox(
                                              height: pickedFile?.name == null
                                                  ? 15
                                                  : 0),
                                          const SizedBox(height: 15),
                                          DefaultButton(
                                            text: "Complete  Registration",
                                            press: () async {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  address =
                                                      FlutterGooglePlacesWeb
                                                              .value['name'] ??
                                                          '';
                                                  city = FlutterGooglePlacesWeb
                                                          .value['city'] ??
                                                      '';

                                                  main();
                                                });

                                                // Provider.of<Laundry>(context,
                                                //         listen: false)
                                                //     .updateBusinessData(
                                                //         address,
                                                //         laundromatName,
                                                //         city,
                                                //         rating,
                                                //         turnAround,
                                                //         laundromatName,
                                                //         location ??
                                                //             GeoPoint(0, 0),
                                                //         distance,
                                                //         laundryT,
                                                //         numberOfLocations);

                                                // Delay and wait for coordinates
                                                Future.delayed(
                                                    Duration(seconds: 2), () {
                                                  // Provider.of<Laundry>(context,
                                                  //         listen: false)
                                                  //     .createLaundromat(
                                                  //         context);
                                                });

                                                // update the data
                                                // Provider.of<Laundry>(context,
                                                //         listen: false)
                                                //     .updateBusinessData(
                                                //         address,
                                                //         laundromatName,
                                                //         city,
                                                //         rating,
                                                //         turnAround,
                                                //         laundromatName,
                                                //         location ??
                                                //             GeoPoint(0, 0),
                                                //         distance,
                                                //         laundryT,
                                                //         numberOfLocations);

                                                // Provider.of<Laundry>(context,
                                                //         listen: false)
                                                //     .createLaundromat(context);

                                                // Navigator.push(
                                                //     context,
                                                //     PageTransition(
                                                //         child: SignUpSuccess(),
                                                //         type: PageTransitionType
                                                //             .fade));

                                                KeyboardUtil.hideKeyboard(
                                                    context);
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

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

  Widget buildLaundryTypeDropdown() {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        // Add Horizontal padding using menuItemStyleData.padding so it matches
        // the menu padding when button's width is not specified.

        labelText: "Business Type",

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        // Add more decoration..
      ),
      hint: const Text(
        'Business Type',
        // style: TextStyle(fontSize: 14),
      ),
      items: laundryType
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
          return 'Please Select Business TYpe';
        }
        return null;
      },
      onChanged: (value) {
        laundryT = value ?? '';
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
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  Widget buildNumberOfLocations() {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        // Add Horizontal padding using menuItemStyleData.padding so it matches
        // the menu padding when button's width is not specified.
        focusColor: Colors.white,
        hoverColor: Colors.white,
        fillColor: Colors.white,
        labelText: "Locations",
        hintText: "Enter Number of Locations",
        border: OutlineInputBorder(
          gapPadding: 4,
          borderRadius: BorderRadius.circular(15),
        ),
        // Add more decoration..
      ),
      hint: const Text(
        'Number of Locations',
        // style: TextStyle(fontSize: 14),
      ),
      items: number
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
          return 'Please Select the number 0f Locations';
        }
        return null;
      },
      onChanged: (value) {
        numberOfLocations = value ?? '';
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
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  TextFormField buildTurnAroundTimeFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          turnAround = value;
          main();
        });

        if (value.isNotEmpty) {
          removeError(error: kTurnAroundNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kTurnAroundNullError);
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
