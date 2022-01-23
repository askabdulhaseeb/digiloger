import 'package:digiloger/utilities/custom_image.dart';
import 'package:digiloger/widgets/eventcardnearyou.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  double thres = 20;
  Location location = Location();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: SizedBox(
          height: 46,
          child: Image.asset(CustomImages.logo),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 15, 8, 8),
        child: Column(
          children: <Widget>[
            Center(
              child: Text(
                "Events Near You ".toUpperCase(),
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 10),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Distance: ",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20,
                ),
              ),
            ),
            Slider(
              min: 0.0,
              max: 100.0,
              value: thres,
              label: "${thres.round()} kms",
              divisions: 10,
              onChanged: (value) {
                setState(() {
                  thres = value;
                });
              },
            ),
            Expanded(
              child: FutureBuilder<LocationData?>(
                  future: getLoc(),
                  builder: (BuildContext context,
                      AsyncSnapshot<LocationData?> snapshot) {
                    if (snapshot.data != null) {
                      return EventCardNearYou(
                        locationData: snapshot.data!,
                        thres: thres,
                      );
                    } else {
                      return const SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<LocationData?> getLoc() async {
    LocationData? locationData;
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    locationData = await location.getLocation();
    location.onLocationChanged.listen((LocationData currentLocation) {
      locationData = currentLocation;
    });
    return locationData;
  }
}
