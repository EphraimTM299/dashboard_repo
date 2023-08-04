import 'package:flutter/material.dart';
import 'package:flutter_google_places_web/flutter_google_places_web.dart';
import 'package:store_responsive_dashboard/components/constants.dart';

const kGoogleApiKey = "API_KEY";

class TestLocation extends StatefulWidget {
  @override
  _TestLocationState createState() => _TestLocationState();
}

class _TestLocationState extends State<TestLocation> {
  String test = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(top: 150),
          width: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Address autocomplete',
              ),
              FlutterGooglePlacesWeb(
                apiKey: apiKey,
                components: "country:za",
                proxyURL: 'https://cors-anywhere.herokuapp.com/',
                required: false,
              ),
              TextButton(
                onPressed: () {
                  print(FlutterGooglePlacesWeb.value[
                      'name']); // '1600 Amphitheatre Parkway, Mountain View, CA, USA'
                  print(FlutterGooglePlacesWeb
                      .value['streetAddress']); // '1600 Amphitheatre Parkway'
                  print(FlutterGooglePlacesWeb.value['city']); // 'CA'
                  print(FlutterGooglePlacesWeb.value['country']);
                  setState(() {
                    test = FlutterGooglePlacesWeb.value['name'] ?? '';
                  });
                },
                child: Text('Press to test'),
              ),
              Text(test),
            ],
          ),
        ),
      ),
    );
  }
}
