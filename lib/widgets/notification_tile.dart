import 'package:digiloger/services/user_local_data.dart';
import 'package:digiloger/utilities/custom_image.dart';
import 'package:digiloger/utilities/utilities.dart';
import 'package:digiloger/widgets/circular_profile_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: <Widget>[
          SizedBox(width: Utilities.padding / 2),
          CircularProfileImage(imageURL: CustomImages.domeURL),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                RichText(
                  maxLines: 2,
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <InlineSpan>[
                      TextSpan(
                        text: '${UserLocalData.getName} ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: Utilities.demoParagraph,
                      ),
                    ],
                  ),
                ),
                const Text(
                  'few seconds ago',
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // TODO: if any one follow there will show Follow back button
          SizedBox(
            height: 50,
            width: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ExtendedImage.network(
                CustomImages.domeURL,
                fit: BoxFit.fill,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(width: Utilities.padding / 2),
        ],
      ),
    );
  }
}
