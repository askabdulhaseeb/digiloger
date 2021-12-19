import 'package:digiloger/database/user_api.dart';
import 'package:digiloger/models/app_user.dart';
import 'package:digiloger/services/user_local_data.dart';
import 'package:digiloger/widgets/circular_profile_image.dart';
import 'package:digiloger/widgets/gridview_of_posts.dart';
import 'package:digiloger/widgets/user_post_and_followers_count.dart';
import 'package:flutter/material.dart';

class OtherUserProfile extends StatefulWidget {
  const OtherUserProfile({required this.username, required this.uid, Key? key})
      : super(key: key);
  final String username;
  final String uid;
  @override
  _OtherUserProfileState createState() => _OtherUserProfileState();
}

class _OtherUserProfileState extends State<OtherUserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: FutureBuilder<AppUser>(
        future: UserAPI().getInfo(uid: widget.uid),
        builder: (BuildContext context, AsyncSnapshot<AppUser> snapshot) {
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
                if ((snapshot.hasData)) {
                  final AppUser? _user = snapshot.data;
                  return Column(
                    children: <Widget>[
                      CircularProfileImage(
                        imageURL: _user?.imageURL ?? '',
                        radious: 50,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _user?.name ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      UserPostAndFollowersCount(
                        post: _user?.posts?.length ?? 0,
                        followers: _user?.followers?.length ?? 0,
                        followings: _user?.followings?.length ?? 0,
                      ),
                      _followAndMessage(_user!),
                      const Divider(),
                      const Expanded(
                        child: GridViewOfPosts(
                          posts: <String>[
                            'https://cdn.pixabay.com/photo/2015/10/30/20/13/sunrise-1014712_1280.jpg',
                            'https://cdn.pixabay.com/photo/2017/01/20/00/30/maldives-1993704_1280.jpg',
                          ],
                        ),
                      )
                    ],
                  );
                } else {
                  return _errorWidget();
                }
              }
          }
        },
      ),
    );
  }

  Padding _followAndMessage(AppUser otherUser) {
    const double _height = 32;
    final BorderRadius _borderRadius = BorderRadius.circular(4);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
            child: (otherUser.followers!.contains(UserLocalData.getUID))
                ? InkWell(
                    onTap: () async {
                      await UserAPI().followOrUnfollow(otherUser);
                      setState(() {});
                    },
                    borderRadius: _borderRadius,
                    child: Container(
                      height: _height,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: _borderRadius,
                      ),
                      child: const Text('Following'),
                    ),
                  )
                : (!otherUser.followers!.contains(UserLocalData.getUID) &&
                        otherUser.followings!.contains(UserLocalData.getUID))
                    ? InkWell(
                        onTap: () async {
                          await UserAPI().followOrUnfollow(otherUser);
                          setState(() {});
                        },
                        borderRadius: _borderRadius,
                        child: Container(
                          height: _height,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: _borderRadius,
                          ),
                          child: const Text(
                            'Follow Back',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: () async {
                          await UserAPI().followOrUnfollow(otherUser);
                          setState(() {});
                        },
                        borderRadius: _borderRadius,
                        child: Container(
                          height: _height,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            color: Theme.of(context).primaryColor,
                            borderRadius: _borderRadius,
                          ),
                          child: const Text(
                            'Follow',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: InkWell(
              onTap: () {},
              child: Container(
                height: _height,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('Message'),
              ),
            ),
          ),
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

  AppBar _appbar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      title: Text(widget.username),
      actions: <Widget>[
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert_outlined),
        ),
      ],
    );
  }
}
