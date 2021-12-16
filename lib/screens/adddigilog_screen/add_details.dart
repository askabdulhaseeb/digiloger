import 'package:digiloger/screens/adddigilog_screen/camerapage.dart';
import 'package:digiloger/utilities/custom_validator.dart';
import 'package:digiloger/utilities/utilities.dart';
import 'package:digiloger/widgets/circular_icon_button.dart';
import 'package:digiloger/widgets/custom_textformfield.dart';
import 'package:digiloger/widgets/show_loading.dart';
import 'package:flutter/material.dart';

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
  //final List<dynamic> _placeList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*locationController.addListener(() {
      _onChanged();
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Digilog',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
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
              CircularIconButton(onTap: () async {
                if (_key.currentState!.validate()) {
                  Navigator.of(context).pushNamed(CameraScreen.routeName);
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}




  /*void _onChanged() {
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
        '$baseURL?input=$input&key=$kplacesApiKey&sessiontoken=$_sessionToken';
    final response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      setState(() {});
    } else {
      throw Exception('Failed to load predictions');
    }
  }
}*/


