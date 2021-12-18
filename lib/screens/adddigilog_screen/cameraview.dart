import 'dart:io';
import 'package:digiloger/database/digilog_api.dart';
import 'package:digiloger/models/digilog.dart';
import 'package:digiloger/providers/digilog_provider.dart';
import 'package:digiloger/screens/adddigilog_screen/digilog_experiences.dart';
import 'package:digiloger/utilities/custom_validator.dart';
import 'package:digiloger/widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class CameraViewPage extends StatefulWidget {
  const CameraViewPage({Key? key}) : super(key: key);
  static const String routeName = '/CameraView';

  @override
  _CameraViewPageState createState() => _CameraViewPageState();
}

class _CameraViewPageState extends State<CameraViewPage> {
  String path = "";
  final TextEditingController captionController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  late DigilogProvider _provider;
  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<DigilogProvider>(context);
    path = ModalRoute.of(context)!.settings.arguments.toString();
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
          child: Form(
            key: _key,
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
                    validator: (String? value) =>
                        CustomValidator.isEmpty(value),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> copyImage() async {
    File file = new File(path);
    String fileName = file.path.split('/').last;
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/$fileName';
    await file.copy(filePath);
    return filePath;
  }

  Future<void> upload() async {
    if (_key.currentState!.validate()) {
      String filepath = await copyImage();
      Experiences exp = Experiences(
          mediaUrl: filepath,
          mediatype: "image",
          description: captionController.text);
      Digilog digilog = _provider.currentdigilog;
      digilog.experiences.add(exp);
      _provider.onUpdatedigi(digilog);
      Navigator.of(context).pushNamed(DigilogExperiences.routeName);
    }
  }
}
