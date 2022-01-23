import 'package:digiloger/database/auth_methods.dart';
import 'package:digiloger/database/event_api.dart';
import 'package:digiloger/models/digilog.dart';
import 'package:digiloger/models/event_model.dart';
import 'package:digiloger/screens/auth/login_screen.dart';
import 'package:digiloger/services/user_local_data.dart';
import 'package:digiloger/utilities/custom_image.dart';
import 'package:digiloger/utilities/utilities.dart';
import 'package:digiloger/widgets/circular_profile_image.dart';
import 'package:digiloger/widgets/gridview_of_events.dart';
import 'package:flutter/material.dart';

class BusinessProfile extends StatefulWidget {
  const BusinessProfile({Key? key}) : super(key: key);

  @override
  _BusinessProfileState createState() => _BusinessProfileState();
}

class _BusinessProfileState extends State<BusinessProfile> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.all(Utilities.padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  UserLocalData.getEmail,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  splashRadius: 20,
                  onPressed: () async {
                    await AuthMethods().signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        LoginScreen.routeName, (Route<dynamic> route) => false);
                  },
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
          ),
          CircularProfileImage(imageURL: CustomImages.domeURL, radious: 50),
          const SizedBox(height: 6),
          Text(
            UserLocalData.getName,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Divider(),
          Expanded(
            child: FutureBuilder<List<Event>>(
                future: getevents(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Event>> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: CircularProgressIndicator.adaptive(),
                      );
                    default:
                      if ((snapshot.hasError)) {
                        return _errorWidget();
                      } else {
                        if (snapshot.hasData) {
                          if (snapshot.data!.isNotEmpty) {
                            return GridViewEvents(posts: snapshot.data!);
                          } else {
                            return const Text("NO Events POSTED");
                          }
                        } else {
                          return const Text("NO Events POSTED");
                        }
                      }
                  }
                }),
          )
        ],
      ),
    );
  }

  SizedBox _errorWidget() {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Column(
          children: const <Widget>[
            Icon(Icons.info, color: Colors.grey),
            Text(
              'Facing some issues',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Event>> getevents() async {
    return await EventAPI().geteventsbyuserid(userid: UserLocalData.getUID);
  }
}
