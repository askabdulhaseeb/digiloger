import 'package:digiloger/database/digilog_api.dart';
import 'package:digiloger/models/digilog.dart';
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
          const SizedBox(height: 60),
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
            followings: UserLocalData.getFollows.length,
          ),
          const SizedBox(height: 20),
          const Divider(),
          Expanded(
            child: GridViewOfPosts(
              posts: <String>[
                CustomImages.domeURL,
                CustomImages.domeURL,
                CustomImages.domeURL,
                CustomImages.domeURL,
                CustomImages.domeURL,
                CustomImages.domeURL,
                CustomImages.domeURL,
                CustomImages.domeURL,
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<List<Digilog>> getdigilogs() async {
    return await DigilogAPI().getallfirebasedigilogs(UserLocalData.getUID);
  }
}
