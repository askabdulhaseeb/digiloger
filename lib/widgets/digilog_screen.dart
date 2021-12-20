import 'package:digiloger/database/user_api.dart';
import 'package:digiloger/models/app_user.dart';
import 'package:digiloger/models/digilog.dart';
import 'package:digiloger/providers/digilog_provider.dart';
import 'package:digiloger/utilities/custom_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DigilogScreen extends StatefulWidget {
  const DigilogScreen({Key? key, required this.digilog, required this.index})
      : super(key: key);
  final Digilog digilog;
  final int index;

  @override
  _DigilogScreenState createState() => _DigilogScreenState();
}

class _DigilogScreenState extends State<DigilogScreen> {
  @override
  Widget build(BuildContext context) {
    return getBody(widget.digilog, widget.index);
  }

  Widget getBody(Digilog digilog, int index) {
    Size size = MediaQuery.of(context).size;
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
                    return MainItem(
                      size: size,
                      caption: digilog.experiences[index].description,
                      profileImg: snapshot.data!.imageURL!,
                      likes: digilog.likes.toString(),
                      comments: digilog.comments.length.toString(),
                      imageUrl: digilog.experiences[index].mediaUrl,
                      name: snapshot.data!.name,
                    );
                  } else {
                    return MainItem(
                      size: size,
                      caption: digilog.experiences[index].description,
                      profileImg: CustomImages.domeURL,
                      likes: digilog.likes.toString(),
                      comments: digilog.comments.length.toString(),
                      imageUrl: digilog.experiences[index].mediaUrl,
                      name: "Anoymous User",
                    );
                  }
                } else {
                  return MainItem(
                    size: size,
                    caption: digilog.experiences[index].description,
                    profileImg: CustomImages.domeURL,
                    likes: digilog.likes.toString(),
                    comments: digilog.comments.length.toString(),
                    imageUrl: digilog.experiences[index].mediaUrl,
                    name: "Anoymous User",
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

class MainItem extends StatefulWidget {
  const MainItem(
      {Key? key,
      required this.size,
      required this.name,
      required this.caption,
      required this.profileImg,
      required this.likes,
      required this.comments,
      required this.imageUrl})
      : super(key: key);
  final String imageUrl;
  final String name;
  final String caption;
  final String profileImg;
  final String likes;
  final String comments;
  final Size size;

  @override
  _MainItemState createState() => _MainItemState();
}

class _MainItemState extends State<MainItem> {
  bool isShowPlaying = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: widget.size.height,
        width: widget.size.width,
        child: Stack(
          children: <Widget>[
            Container(
              height: widget.size.height,
              width: widget.size.width,
              decoration: const BoxDecoration(color: Colors.black),
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Container(
                      decoration: const BoxDecoration(),
                      child: ExtendedImage.network(
                        widget.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: widget.size.height,
              width: widget.size.width,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 20, bottom: 10),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          child: Row(
                        children: <Widget>[
                          LeftPanel(
                            size: widget.size,
                            name: widget.name,
                            caption: widget.caption,
                          ),
                          RightPanel(
                            size: widget.size,
                            likes: widget.likes,
                            comments: widget.comments,
                            profileImg: widget.profileImg,
                          )
                        ],
                      ))
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}

class RightPanel extends StatelessWidget {
  const RightPanel({
    Key? key,
    required this.size,
    required this.likes,
    required this.comments,
    required this.profileImg,
  }) : super(key: key);
  static const String _fontFamily = 'TikTokIcons';
  final String likes;
  final String comments;
  final String profileImg;

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: size.height,
        child: Column(
          children: <Widget>[
            Container(
              height: size.height * 0.3,
            ),
            Expanded(
                child: Column(
              children: <Widget>[
                getProfile(profileImg),
                getIcons(Icons.star, likes, 35.0),
                getIcons(Icons.comment, comments, 35.0),
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget getIcons(IconData icon, String count, double size) {
    return Column(
      children: <Widget>[
        Icon(icon, color: Colors.white, size: size),
        const SizedBox(
          height: 5,
        ),
        Text(
          count,
          style: const TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
        )
      ],
    );
  }

  Widget getProfile(String img) {
    return SizedBox(
      width: 50,
      height: 60,
      child: Stack(
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              shape: BoxShape.circle,
            ),
            child: ExtendedImage.network(
              img,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
              bottom: 3,
              left: 18,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF3A5899),
                ),
                child: const Center(
                    child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 15,
                )),
              ))
        ],
      ),
    );
  }
}

class LeftPanel extends StatelessWidget {
  const LeftPanel({
    Key? key,
    required this.size,
    required this.name,
    required this.caption,
  }) : super(key: key);
  final String name;
  final String caption;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.8,
      height: size.height,
      decoration: const BoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            name,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            caption,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
