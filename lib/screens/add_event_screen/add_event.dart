import 'dart:io';
import 'package:digiloger/database/event_api.dart';
import 'package:digiloger/models/digilog.dart';
import 'package:digiloger/models/event_model.dart';
import 'package:digiloger/models/places_predictions.dart';
import 'package:digiloger/providers/main_bottom_nav_bar_provider.dart';
import 'package:digiloger/screens/adddigilog_screen/add_details.dart';
import 'package:digiloger/services/user_local_data.dart';
import 'package:digiloger/utilities/custom_validator.dart';
import 'package:digiloger/widgets/circular_icon_button.dart';
import 'package:digiloger/widgets/custom_textformfield.dart';
import 'package:digiloger/widgets/custom_toast.dart';
import 'package:digiloger/widgets/show_loading.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({Key? key}) : super(key: key);

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  late String imgUrl;
  File? file = null;
  Uuid uuid = const Uuid();
  String? _sessionToken = "";
  int? _date;
  int? _month;
  int? _year;
  bool loading = false;
  final List<int> _dateList = <int>[for (int i = 1; i <= 31; i++) i];
  final List<int> _monthList = <int>[for (int i = 1; i <= 12; i++) i];
  final List<int> _yearList = <int>[
    for (int i = DateTime.now().year; i >= 1900; i--) i
  ];
  late Location _location = Location(lat: 0.00, long: 0.00, maintext: "");
  List<PlacesPredictions> _placeList = <PlacesPredictions>[];

  @override
  void initState() {
    super.initState();
    locationController.addListener(() {
      _onChanged();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Add Event',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: InkWell(
                    onTap: getimage,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 150,
                          width: 250,
                          child: Card(
                            color: Colors.white70,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                            margin: const EdgeInsets.all(5),
                            child: Center(
                              child: setavtar(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 8.0),
                  child: Form(
                    key: _key,
                    child: Column(
                      children: <Widget>[
                        CustomTextFormField(
                          title: 'Event Name',
                          controller: eventNameController,
                          hint: 'Event Name',
                          validator: (String? value) =>
                              CustomValidator.isEmpty(value),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        CustomTextFormField(
                          title: 'Event Description ',
                          controller: descController,
                          hint: 'Its an art exibition',
                          validator: (String? value) =>
                              CustomValidator.isEmpty(value),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            ' Event Date:',
                            style:
                                TextStyle(fontSize: 18, color: Colors.black54),
                          ),
                        ),
                        _dobDropdown(context),
                        const SizedBox(
                          height: 30,
                        ),
                        CustomTextFormField(
                          title: 'Event Location',
                          controller: locationController,
                          hint: 'Event Location',
                          validator: (String? value) =>
                              CustomValidator.isEmpty(value),
                        ),
                        (_placeList.isNotEmpty && _location.lat == 0.00)
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 16.0,
                                ),
                                child: ListView.separated(
                                  padding: const EdgeInsets.all(0),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return PredictionTile(
                                      predictions: _placeList[index],
                                      getplace: getPlace,
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const Divider();
                                  },
                                  itemCount: _placeList.length,
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                ),
                              )
                            : Container(),
                        const SizedBox(
                          height: 40,
                        ),
                        CircularIconButton(onTap: () async {
                          setState(() {
                            loading = true;
                          });
                          if (_key.currentState!.validate()) {
                            Event event = Event(
                                name: eventNameController.text.trim(),
                                description: descController.text.trim(),
                                hostuid: UserLocalData.getUID,
                                location: _location,
                                coverimage: file!.path);
                            await EventAPI().addEvent(event);
                            CustomToast.successToast(message: "Event Added");
                            setState(() {
                              eventNameController.clear();
                              descController.clear();
                              locationController.clear();
                              _location =
                                  Location(lat: 0.00, long: 0.00, maintext: "");
                              file = null;
                              _date = null;
                              _month = null;
                              _year = null;
                              loading = false;
                            });
                            Provider.of<MainBottomNavBarProvider>(context)
                                .onTabTapped(0);
                          }
                        }),
                        const SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  void _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(locationController.text);
  }

  Future<void> getSuggestion(String input) async {
    const String kplacesApiKey = "AIzaSyA8_u99oNuNQPAzaq46GCvIBikYpUQABMA";
    //const String type = '(regions)';
    const String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    final String request =
        '$baseURL?input=$input&key=$kplacesApiKey&sessiontoken=$_sessionToken&components=country:pk';
    Dio dio = Dio();
    final Response<Map<String, dynamic>> response =
        await dio.getUri(Uri.parse(request));
    if (response.statusCode == 200) {
      var predictions = response.data!["predictions"];
      var placeslist = (predictions as List)
          .map((e) => PlacesPredictions.fromJson(e))
          .toList();
      setState(() {
        _placeList = placeslist;
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  Future<void> getPlace(String placeid) async {
    const String kplacesApiKey = "AIzaSyA8_u99oNuNQPAzaq46GCvIBikYpUQABMA";
    //const String type = '(regions)';
    const String baseURL =
        'https://maps.googleapis.com/maps/api/place/details/json';
    final String request = '$baseURL?place_id=$placeid&key=$kplacesApiKey';
    Dio dio = Dio();
    final Response<Map<String, dynamic>> response =
        await dio.getUri(Uri.parse(request));
    if (response.statusCode == 200) {
      Location location = Location(
          lat: response.data!['result']['geometry']['location']['lat'],
          long: response.data!['result']['geometry']['location']['lng'],
          maintext: response.data!['result']['name']);
      setState(() {
        _location = location;
        _placeList.clear();
        locationController.text = _location.maintext;
      });
    } else {}
  }

  Row _dobDropdown(BuildContext context) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 4),
        DropdownButton<int>(
          menuMaxHeight: MediaQuery.of(context).size.height * 0.7,
          underline: const SizedBox(),
          hint: const Text("Date"),
          value: _date,
          items: _dateList
              .map((int e) => DropdownMenuItem<int>(
                    value: e,
                    child: Text('$e'),
                  ))
              .toList(),
          onChanged: (int? value) {
            setState(() {
              _date = value!;
            });
          },
        ),
        DropdownButton<int>(
          menuMaxHeight: MediaQuery.of(context).size.height * 0.7,
          underline: const SizedBox(),
          hint: const Text("Month"),
          value: _month,
          items: _monthList
              .map((int e) => DropdownMenuItem<int>(
                    value: e,
                    child: Text('$e'),
                  ))
              .toList(),
          onChanged: (int? value) {
            setState(() {
              _month = value!;
            });
          },
        ),
        DropdownButton<int>(
          menuMaxHeight: MediaQuery.of(context).size.height * 0.7,
          underline: const SizedBox(),
          hint: const Text("Year"),
          value: _year,
          items: _yearList
              .map((int e) => DropdownMenuItem<int>(
                    value: e,
                    child: Text('$e'),
                  ))
              .toList(),
          onChanged: (int? value) {
            setState(() {
              _year = value!;
            });
          },
        ),
      ],
    );
  }

  Future<void> getimage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image;
    await Permission.photos.request();

    if (Platform.isIOS) {
      final PermissionStatus permissionStatus = await Permission.storage.status;
      if (permissionStatus.isGranted) {
        try {
          image = await _picker.pickImage(
            source: ImageSource.gallery,
            maxWidth: 1800,
            maxHeight: 1800,
          );
        } catch (ex) {
          return;
        }
        if (image != null) {
          setState(() {
            file = File(image!.path);
          });
        }
      }
    } else {
      final PermissionStatus permissionStatus = await Permission.photos.status;
      if (permissionStatus.isGranted) {
        image = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1800,
          maxHeight: 1800,
        );
        if (image != null) {
          setState(() {
            file = File(image!.path);
          });
        }
      }
    }
  }

  Widget setavtar() {
    if (file != null) {
      return Image.file(file!);
    } else {
      return Icon(
        Icons.add_a_photo,
        color: Theme.of(context).primaryColor,
        size: 50,
      );
    }
  }
}
