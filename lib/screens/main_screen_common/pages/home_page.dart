import 'package:digiloger/database/digilog_api.dart';
import 'package:digiloger/models/digilog.dart';
import 'package:digiloger/services/user_local_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../utilities/custom_image.dart';
import '../../../widgets/circular_profile_image.dart';
import '../../../widgets/post_tile.dart';
import '../../chat_dashboard_screen/chat_dashboard_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
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
        actions: <Widget>[
          IconButton(
            splashRadius: 20,
            onPressed: () =>
                Navigator.of(context).pushNamed(ChatDashboardScreen.routeName),
            icon: const Icon(CupertinoIcons.chat_bubble_2),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 61,
            width: double.infinity,
            child: ListView.builder(
              itemCount: 1000,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) => SizedBox(
                width: 64,
                height: 64,
                child: CircularProfileImage(imageURL: CustomImages.domeURL),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Digilog>>(
                future: getdigilogs(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Digilog>> snapshot) {
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
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  PostTile(digilog: snapshot.data![index]),
                            );
                          } else {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "No Digilogs posted by your followers",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 14),
                                ),
                              ],
                            );
                          }
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "No Digilogs posted by your followers",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 14),
                              ),
                            ],
                          );
                        }
                      }
                  }
                }),
          ),
        ],
      ),
    );
  }

  Future<List<Digilog>> getdigilogs() async {
    List<Digilog> digilog = [];
    if (UserLocalData.getFollowings.isNotEmpty) {
      digilog = await DigilogAPI()
          .getallfirebasedigilogsbylistuid(UserLocalData.getFollowings);
    }
    return digilog;
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
}
