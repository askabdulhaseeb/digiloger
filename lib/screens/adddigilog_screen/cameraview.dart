import 'dart:io';
import 'package:digiloger/screens/adddigilog_screen/digilog_experiences.dart';
import 'package:digiloger/widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';

class CameraViewPage extends StatefulWidget {
  const CameraViewPage({Key? key}) : super(key: key);
  static const String routeName = '/CameraView';

  @override
  _CameraViewPageState createState() => _CameraViewPageState();
}

class _CameraViewPageState extends State<CameraViewPage> {
  String downloadUrl = "";
  final TextEditingController captionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final String path = ModalRoute.of(context)!.settings.arguments.toString();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {},
        ),
        actions: <Widget>[
          TextButton(
            onPressed: upload,
            child: Text(
              "Add",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 500,
                width: 500,
                child: InkWell(
                  onTap: () => {},
                  child: Image.file(
                    File(path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 500,
                child: CustomTextFormField(
                  controller: captionController,
                  title: "Caption",
                  hint: "Stay at ABC Hotel",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> upload() async {
    Navigator.of(context).pushNamed(DigilogExperiences.routeName);
  }
}
