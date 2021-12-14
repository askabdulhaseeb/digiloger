import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:digiloger/utilities/custom_image.dart';
import 'package:digiloger/widgets/circular_profile_image.dart';

class PostTile extends StatelessWidget {
  const PostTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _header(),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ExtendedImage.network(
              CustomImages.domeURL,
              fit: BoxFit.cover,
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
            children: [
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

  Padding _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        children: [
          CircularProfileImage(imageURL: CustomImages.domeURL, radious: 24),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Text('Username'),
              Text(
                'Location',
                style: TextStyle(fontSize: 12, color: Colors.grey),
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
