import 'package:digiloger/database/digilog_api.dart';
import 'package:digiloger/database/user_api.dart';
import 'package:digiloger/models/app_user.dart';
import 'package:digiloger/models/digilog.dart';
import 'package:digiloger/providers/digilog_provider.dart';
import 'package:digiloger/screens/digilog_view_screen/digilog_view.dart';
import 'package:digiloger/screens/other_user_profile/other_user_profile.dart';
import 'package:digiloger/services/user_local_data.dart';
import 'package:digiloger/widgets/comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:provider/provider.dart';
import '../utilities/custom_image.dart';
import '../widgets/circular_profile_image.dart';

class PostTile extends StatelessWidget {
  const PostTile({Key? key, required this.digilog}) : super(key: key);
  final Digilog digilog;

  @override
  Widget build(BuildContext context) {
    DigilogProvider _provider = Provider.of<DigilogProvider>(context);
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _header(context),
          InkWell(
            onTap: () {
              _provider.onUpdatedigi(digilog);
              Navigator.of(context).pushNamed(DigilogView.routeName);
            },
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: ExtendedImage.network(
                digilog.experiences.first.mediaUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // _footer(),
          _FooterButtons(digilog: digilog),
        ],
      ),
    );
  }

  // Padding _footer() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 8),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       mainAxisSize: MainAxisSize.min,
  //       children: <Widget>[
  //         Row(
  //           children: <Widget>[
  //             IconButton(
  //               splashRadius: 16,
  //               padding: const EdgeInsets.all(0),
  //               onPressed: () {},
  //               icon: const Icon(CupertinoIcons.star, color: Colors.grey),
  //             ),
  //             IconButton(
  //               splashRadius: 16,
  //               padding: const EdgeInsets.all(0),
  //               onPressed: () {},
  //               icon:
  //                   const Icon(CupertinoIcons.chat_bubble, color: Colors.grey),
  //             ),
  //           ],
  //         ),
  //         digilog.likes.length > 0
  //             ? Text(
  //                 digilog.likes.toString() + ' people hits in this post',
  //                 style: const TextStyle(
  //                     fontSize: 14, fontWeight: FontWeight.w300),
  //               )
  //             : const Text(
  //                 'Be first to like this post',
  //                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
  //               ),
  //         const SizedBox(height: 4),
  //         Text(
  //           'Title: ' + digilog.title,
  //           maxLines: 2,
  //           overflow: TextOverflow.ellipsis,
  //           style: const TextStyle(),
  //         ),
  //         const SizedBox(height: 4),
  //         digilog.comments.isNotEmpty
  //             ? Text(
  //                 'View all' + digilog.comments.length.toString() + ' comments',
  //                 style: const TextStyle(
  //                     fontSize: 14, fontWeight: FontWeight.w300),
  //               )
  //             : Container(),
  //         const SizedBox(height: 4),
  //       ],
  //     ),
  //   );
  // }

  Widget _header(BuildContext context) {
    return FutureBuilder<AppUser>(
        future: UserAPI().getInfo(uid: digilog.useruid),
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
                if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<OtherUserProfile>(
                                  builder: (BuildContext context) =>
                                      OtherUserProfile(
                                    uid: digilog.useruid,
                                    username: snapshot.data!.name,
                                  ),
                                ),
                              );
                            },
                            child: CircularProfileImage(
                              imageURL: CustomImages.domeURL,
                              radious: 24,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<OtherUserProfile>(
                                      builder: (BuildContext context) =>
                                          OtherUserProfile(
                                        uid: digilog.useruid,
                                        username: snapshot.data!.name,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(snapshot.data!.name),
                              ),
                              Text(
                                digilog.location.maintext,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            splashRadius: 16,
                            onPressed: () {},
                            icon: const Icon(Icons.more_horiz),
                          )
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<OtherUserProfile>(
                                  builder: (BuildContext context) =>
                                      OtherUserProfile(
                                    uid: digilog.useruid,
                                    username: 'Anoynomous User',
                                  ),
                                ),
                              );
                            },
                            child: CircularProfileImage(
                              imageURL: CustomImages.domeURL,
                              radious: 24,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<OtherUserProfile>(
                                      builder: (BuildContext context) =>
                                          OtherUserProfile(
                                        uid: digilog.useruid,
                                        username: 'Anoynomous User',
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Anoynomous User'),
                              ),
                              Text(
                                digilog.location.maintext,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            splashRadius: 16,
                            onPressed: () {},
                            icon: const Icon(Icons.more_horiz),
                          )
                        ],
                      ),
                    );
                  }
                } else {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<OtherUserProfile>(
                                builder: (BuildContext context) =>
                                    OtherUserProfile(
                                  uid: digilog.useruid,
                                  username: 'Anoynomous User',
                                ),
                              ),
                            );
                          },
                          child: CircularProfileImage(
                            imageURL: CustomImages.domeURL,
                            radious: 24,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<OtherUserProfile>(
                                    builder: (BuildContext context) =>
                                        OtherUserProfile(
                                      uid: digilog.useruid,
                                      username: 'Anoynomous User',
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Anoynomous User'),
                            ),
                            Text(
                              digilog.location.maintext,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          splashRadius: 16,
                          onPressed: () {},
                          icon: const Icon(Icons.more_horiz),
                        )
                      ],
                    ),
                  );
                }
              }
          }
        });
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

class _FooterButtons extends StatefulWidget {
  const _FooterButtons({required this.digilog, Key? key}) : super(key: key);
  final Digilog digilog;

  @override
  __FooterButtonsState createState() => __FooterButtonsState();
}

class __FooterButtonsState extends State<_FooterButtons> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                splashRadius: 16,
                padding: const EdgeInsets.all(0),
                onPressed: () async {
                  if (widget.digilog.likes.contains(UserLocalData.getUID)) {
                    widget.digilog.likes.remove(UserLocalData.getUID);
                  } else {
                    widget.digilog.likes.add(UserLocalData.getUID);
                  }
                  setState(() {});
                  await DigilogAPI().updateLikes(
                    pid: widget.digilog.digilogid,
                    likes: widget.digilog.likes,
                  );
                },
                icon: (widget.digilog.likes.contains(UserLocalData.getUID))
                    ? const Icon(Icons.star)
                    : const Icon(
                        Icons.star_border,
                        color: Colors.grey,
                      ),
              ),
              IconButton(
                splashRadius: 16,
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => CommentPopup(
                      digilog: widget.digilog,
                    ),
                  );
                },
                icon:
                    const Icon(CupertinoIcons.chat_bubble, color: Colors.grey),
              ),
            ],
          ),
          widget.digilog.likes.isNotEmpty
              ? Text(
                  '${widget.digilog.likes.length} people hits in this post',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w300),
                )
              : const Text(
                  'Be first to like this post',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                ),
          const SizedBox(height: 4),
          Text(
            'Title: ' + widget.digilog.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(),
          ),
          const SizedBox(height: 4),
          widget.digilog.comments.isNotEmpty
              ? Text(
                  'View all ${widget.digilog.comments.length} comments',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w300),
                )
              : Container(),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
