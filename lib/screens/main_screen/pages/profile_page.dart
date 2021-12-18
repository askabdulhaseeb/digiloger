import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import '../../../services/user_local_data.dart';
import '../../../utilities/custom_image.dart';
import '../../../widgets/circular_profile_image.dart';

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _NumInfoWidget(
                number: UserLocalData.getPost.length,
                title: 'Posts',
              ),
              _NumInfoWidget(
                number: UserLocalData.getFollowers.length,
                title: 'Followers',
              ),
              _NumInfoWidget(
                number: UserLocalData.getFollows.length,
                title: 'Followings',
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              shrinkWrap: true,
              itemCount: 1000,
              itemBuilder: (BuildContext context, int index) =>
                  ExtendedImage.network(
                CustomImages.domeURL,
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _NumInfoWidget extends StatelessWidget {
  const _NumInfoWidget({required this.number, required this.title, Key? key})
      : super(key: key);
  final int number;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          number.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(title)
      ],
    );
  }
}
