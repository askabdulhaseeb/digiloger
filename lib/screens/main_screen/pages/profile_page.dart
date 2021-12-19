import 'package:digiloger/database/digilog_api.dart';
import 'package:digiloger/models/digilog.dart';
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
            child: FutureBuilder<List<Digilog>>(
                future: getdigilogs(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Digilog> _digiLog = snapshot.data!;
                    if (_digiLog.isNotEmpty) {
                      return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                          ),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return /*isUrl
                                ? ExtendedImage.network(
                                    _digiLog[index].experiences[0].mediaUrl,
                                    fit: BoxFit.fill,
                                  )
                                : ExtendedImage.file(
                                    File(_digiLog[index]
                                        .experiences[0]
                                        .mediaUrl),
                                    fit: BoxFit.fill,
                                  );*/
                                tile(_digiLog[index]);
                          });
                    } else {
                      return Text(
                        "No Posted Digilogs",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 22),
                      );
                    }
                  } else {
                    return Text(
                      "No Posted Digilogs",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 22),
                    );
                  }
                }),
          )
        ],
      ),
    );
  }

  ExtendedImage tile(Digilog digiLog) {
    return ExtendedImage.network(
      digiLog.experiences.first.mediaUrl,
      fit: BoxFit.fill,
    );
  }

  Future<List<Digilog>> getdigilogs() async {
    return await DigilogAPI().getallfirebasedigilogs(UserLocalData.getUID);
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
