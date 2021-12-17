import 'package:digiloger/database/digilog_api.dart';
import 'package:digiloger/models/digilog.dart';
import 'package:digiloger/providers/digilog_provider.dart';
import 'package:digiloger/utilities/custom_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DigilogExperiences extends StatefulWidget {
  const DigilogExperiences({Key? key}) : super(key: key);
  static const String routeName = '/DigilogExperinces';
  @override
  _DigilogExperiencesState createState() => _DigilogExperiencesState();
}

class _DigilogExperiencesState extends State<DigilogExperiences> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DigilogProvider _provider = Provider.of<DigilogProvider>(context);
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
          child: FutureBuilder<Digilog>(
              future: loaddigilog(_provider.currentid),
              builder: (context, snapshot) {
                Digilog _digiLog = snapshot.data!;
                return Column(
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
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 0, 10.0, 0),
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
                );
              }),
        ),
      ),
    );
  }

  void back() {}

  void post() {}

  void save() {}

  Future<Digilog> loaddigilog(int index) async {
    final Digilog _digiLog;
    _digiLog = await DigilogAPI().getdigilog(index);
    return _digiLog;
  }
}
