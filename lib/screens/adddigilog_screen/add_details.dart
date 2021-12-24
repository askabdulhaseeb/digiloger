import 'package:digiloger/models/digilog.dart';
import 'package:digiloger/models/places_predictions.dart';
import 'package:digiloger/providers/digilog_provider.dart';
import 'package:digiloger/screens/adddigilog_screen/camerapage.dart';
import 'package:digiloger/services/user_local_data.dart';
import 'package:digiloger/utilities/custom_validator.dart';
import 'package:digiloger/utilities/utilities.dart';
import 'package:digiloger/widgets/circular_icon_button.dart';
import 'package:digiloger/widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart';

class AddDetails extends StatefulWidget {
  const AddDetails({Key? key}) : super(key: key);
  static const String routeName = '/AddDetails';

  @override
  _AddDetailsState createState() => _AddDetailsState();
}

class _AddDetailsState extends State<AddDetails> {
  final TextEditingController _digititle = TextEditingController();
  final TextEditingController _digilocation = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  Uuid uuid = const Uuid();
  String? _sessionToken = "";
  Location _location = Location(lat: 0.00, long: 0.00, maintext: "");
  List<PlacesPredictions> _placeList = [];
  @override
  void initState() {
    super.initState();
    _digilocation.addListener(() {
      _onChanged();
    });
  }

  @override
  Widget build(BuildContext context) {
    DigilogProvider _provider = Provider.of<DigilogProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Digilog',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Utilities.padding),
          child: Form(
            key: _key,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 60),
                CustomTextFormField(
                  title: 'Digilog Title',
                  controller: _digititle,
                  hint: 'Digilog Title',
                  validator: (String? value) => CustomValidator.isEmpty(value),
                ),
                CustomTextFormField(
                  title: 'Digilog Location',
                  controller: _digilocation,
                  hint: 'Digilog Location',
                  validator: (String? value) => CustomValidator.isEmpty(value),
                ),
                (_placeList.isNotEmpty && _location.lat == 0.00)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: ListView.separated(
                          padding: const EdgeInsets.all(0),
                          itemBuilder: (BuildContext context, int index) {
                            return PredictionTile(
                              predictions: _placeList[index],
                              getplace: getPlace,
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider();
                          },
                          itemCount: _placeList.length,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                        ),
                      )
                    : Container(),
                CircularIconButton(onTap: () async {
                  if (_key.currentState!.validate()) {
                    Digilog digilog = Digilog(
                        useruid: UserLocalData.getUID,
                        location: _location,
                        postedTime: DateTime.now().toString(),
                        title: _digititle.text);

                    _provider.onUpdatedigi(digilog);
                    Navigator.of(context).pushNamed(CameraScreen.routeName);
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_digilocation.text);
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
        _digilocation.text = _location.maintext;
      });
    } else {
      print('Failed to load predictions');
    }
  }
}

class PredictionTile extends StatelessWidget {
  const PredictionTile(
      {Key? key, required this.predictions, required this.getplace})
      : super(key: key);
  final PlacesPredictions predictions;
  final Function getplace;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        getplace(predictions.placeId);
      },
      child: Column(
        children: <Widget>[
          const SizedBox(
            width: 10,
          ),
          Row(
            children: <Widget>[
              const Icon(Icons.add_location),
              const SizedBox(
                width: 14.0,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    predictions.mainText,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  Text(
                    predictions.secondaryText,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                ],
              ))
            ],
          )
        ],
      ),
    );
  }
}
