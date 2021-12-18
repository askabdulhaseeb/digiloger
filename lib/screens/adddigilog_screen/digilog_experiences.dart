import 'package:digiloger/database/digilog_api.dart';
import 'package:digiloger/models/digilog.dart';
import 'package:digiloger/providers/digilog_provider.dart';
import 'package:digiloger/providers/main_bottom_nav_bar_provider.dart';
import 'package:digiloger/screens/adddigilog_screen/camerapage.dart';
import 'package:digiloger/screens/main_screen/main_screen.dart';
import 'package:digiloger/widgets/custom_toast.dart';
import 'package:digiloger/widgets/show_loading.dart';
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
    MainBottomNavBarProvider _navBar =
        Provider.of<MainBottomNavBarProvider>(context);
    final DigilogProvider _provider = Provider.of<DigilogProvider>(context);
    final Digilog _digiLog = _provider.currentdigilog;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: TextButton(
          onPressed: () async => {
            showLoadingDislog(context),
            await DigilogAPI().postDigilog(_digiLog),
            CustomToast.successToast(message: "Digilog Posted Successfully"),
            _navBar.onTabTapped(0),
            Navigator.of(context).pushNamedAndRemoveUntil(
              MainScreen.routeName,
              (Route<dynamic> route) => false,
            ),
          },
          child: Text(
            "Post",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async => {
              showLoadingDislog(context),
              await DigilogAPI().savedigilog(_digiLog),
              CustomToast.successToast(message: "Digilog Saved Successfully"),
              _navBar.onTabTapped(0),
              Navigator.of(context).pushNamedAndRemoveUntil(
                MainScreen.routeName,
                (Route<dynamic> route) => false,
              ),
            },
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
                          onTap: () => {
                            Navigator.of(context)
                                .pushNamed(CameraScreen.routeName),
                          },
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
                        final uri =
                            Uri.tryParse(_digiLog.experiences[index].mediaUrl);

                        final bool isUrl = uri != null &&
                            uri.hasAbsolutePath &&
                            uri.scheme.startsWith('http');
                        return Card(
                          elevation: 1,
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                              child: isUrl
                                  ? ExtendedImage.network(
                                      _digiLog.experiences[index].mediaUrl,
                                      fit: BoxFit.fill,
                                    )
                                  : ExtendedImage.file(
                                      File(
                                          _digiLog.experiences[index].mediaUrl),
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
}
