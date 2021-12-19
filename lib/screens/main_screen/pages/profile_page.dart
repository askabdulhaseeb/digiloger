import 'package:digiloger/database/auth_methods.dart';
import 'package:digiloger/database/digilog_api.dart';
import 'package:digiloger/models/digilog.dart';
import 'package:digiloger/screens/auth/login_screen.dart';
import 'package:digiloger/utilities/utilities.dart';
import 'package:flutter/material.dart';
import '../../../services/user_local_data.dart';
import '../../../utilities/custom_image.dart';
import '../../../widgets/circular_profile_image.dart';
import '../../../widgets/gridview_of_posts.dart';
import '../../../widgets/user_post_and_followers_count.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

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
          UserPostAndFollowersCount(
            post: UserLocalData.getPost.length,
            followers: UserLocalData.getFollowers.length,
            followings: UserLocalData.getFollowings.length,
          ),
          const SizedBox(height: 20),
          const Divider(),
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
                            return GridViewOfPosts(posts: snapshot.data!);
                          } else {
                            return const Text("NO DIGILOGS POSTED");
                          }
                        } else {
                          return const Text("NO DIGILOGS POSTED");
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

  Future<List<Digilog>> getdigilogs() async {
    return await DigilogAPI().getallfirebasedigilogsbyuid(UserLocalData.getUID);
  }
}
