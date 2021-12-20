import 'package:digiloger/database/chat_api.dart';
import 'package:digiloger/database/digilog_api.dart';
import 'package:digiloger/database/user_api.dart';
import 'package:digiloger/models/app_user.dart';
import 'package:digiloger/models/digilog.dart';
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
                      _FollowAndMessageButton(otherUser: _user!),
                      const Divider(),
                      Expanded(
                        child: FutureBuilder<List<Digilog>>(
                          future: getdigilogs(_user),
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
                                      return GridViewOfPosts(
                                          posts: snapshot.data!);
                                    } else {
                                      return const Text("NO DIGILOGS POSTED");
                                    }
                                  } else {
                                    return const Text("NO DIGILOGS POSTED");
                                  }
                                }
                            }
                          },
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

  Future<List<Digilog>> getdigilogs(AppUser otherUser) async {
    return await DigilogAPI().getallfirebasedigilogsbyuid(otherUser.uid);
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
      titleSpacing: 0,
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

class _FollowAndMessageButton extends StatefulWidget {
  const _FollowAndMessageButton({required this.otherUser, Key? key})
      : super(key: key);

  final AppUser otherUser;
  @override
  __FollowAndMessageButtonState createState() =>
      __FollowAndMessageButtonState();
}

class __FollowAndMessageButtonState extends State<_FollowAndMessageButton> {
  static const double _height = 32;
  final BorderRadius _borderRadius = BorderRadius.circular(4);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
            child: (widget.otherUser.followers!.contains(UserLocalData.getUID))
                ? InkWell(
                    onTap: () async {
                      await UserAPI().followOrUnfollow(widget.otherUser);
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
                : (!widget.otherUser.followers!
                            .contains(UserLocalData.getUID) &&
                        widget.otherUser.followings!
                            .contains(UserLocalData.getUID))
                    ? InkWell(
                        onTap: () async {
                          await UserAPI().followOrUnfollow(widget.otherUser);
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
                          await UserAPI().followOrUnfollow(widget.otherUser);
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
              onTap: () {
                print(ChatAPI.getChatID(othersUID: widget.otherUser.uid));
                // Navigator.of(context).push(
                //   MaterialPageRoute<PersonalChatScreen>(
                //     builder: (BuildContext context) => PersonalChatScreen(
                //       user: widget.uid,
                //     ),
                //   ),
                // );
              },
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
}
