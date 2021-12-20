import 'package:digiloger/models/digilog.dart';
import 'package:digiloger/providers/digilog_provider.dart';
import 'package:digiloger/screens/digilog_view_screen/digilog_view.dart';
import 'package:digiloger/screens/other_user_profile/other_user_profile.dart';
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
          _footer(),
        ],
      ),
    );
  }

  Padding _footer() {
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
                onPressed: () {},
                icon: const Icon(CupertinoIcons.star, color: Colors.grey),
              ),
              IconButton(
                splashRadius: 16,
                padding: const EdgeInsets.all(0),
                onPressed: () {},
                icon:
                    const Icon(CupertinoIcons.chat_bubble, color: Colors.grey),
              ),
            ],
          ),
          const Text(
            '83 people hits in this post',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 4),
          const Text(
            'Find Thesis Writing Services Uk. Search Faster, Better & Smarter at ZapMeta Now! Web, Images & Video. Information 24/7. Wiki, News & More. 100+ Million Visitors. Trusted by Millions. The Complete Overview. Types: pdf, doc, ppt, xls, txt',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(),
          ),
          const SizedBox(height: 4),
          const Text(
            'View all 83 comments',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Padding _header(BuildContext context) {
    // TODO: username and location needs to update
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<OtherUserProfile>(
                  builder: (BuildContext context) => OtherUserProfile(
                    uid: digilog.useruid,
                    username: 'username',
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
                      builder: (BuildContext context) => OtherUserProfile(
                        uid: digilog.useruid,
                        username: 'username',
                      ),
                    ),
                  );
                },
                child: const Text('Username'),
              ),
              Text(
                digilog.location.maintext,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
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
