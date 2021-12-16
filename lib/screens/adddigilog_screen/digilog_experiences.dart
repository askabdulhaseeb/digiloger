import 'package:digiloger/models/digilog_model.dart';
import 'package:digiloger/utilities/custom_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class DigilogExperiences extends StatefulWidget {
  const DigilogExperiences({Key? key}) : super(key: key);
  static const String routeName = '/DigilogExperinces';
  @override
  _DigilogExperiencesState createState() => _DigilogExperiencesState();
}

class _DigilogExperiencesState extends State<DigilogExperiences> {
  late Digilog _digiLog;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loaddigilog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: TextButton(
          onPressed: post,
          child: Text(
            "Post",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: save,
            child: Text(
              "Save",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _digiLog.title,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 500,
                child: GridView.count(
                  crossAxisCount: 3,
                  children: List<Widget>.generate(
                    _digiLog.experiences.length + 1,
                    (int index) {
                      if (index == _digiLog.experiences.length) {
                        return InkWell(
                          onTap: () => {},
                          child: Card(
                            elevation: 1,
                            child: Center(
                              child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      10.0, 0, 10.0, 0),
                                  child: Icon(
                                    Icons.add,
                                    color: Theme.of(context).primaryColor,
                                    size: 60,
                                  )),
                            ),
                          ),
                        );
                      } else {
                        return Card(
                          elevation: 1,
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                              child: ExtendedImage.network(
                                CustomImages.domeURL,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void back() {}

  void post() {}

  void save() {}

  void load() {}

  void loaddigilog() {}
}
