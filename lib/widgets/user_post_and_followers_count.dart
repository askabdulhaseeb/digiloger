import 'package:digiloger/services/user_local_data.dart';
import 'package:flutter/material.dart';

class UserPostAndFollowersCount extends StatelessWidget {
  const UserPostAndFollowersCount({
    required this.post,
    required this.followers,
    required this.followings,
    Key? key,
  }) : super(key: key);
  final int post;
  final int followers;
  final int followings;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _NumInfoWidget(
          number: post,
          title: 'Posts',
        ),
        _NumInfoWidget(
          number: followers,
          title: 'Followers',
        ),
        _NumInfoWidget(
          number: followings,
          title: 'Followings',
        ),
      ],
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
