import 'package:digiloger/utilities/custom_image.dart';
import 'package:digiloger/widgets/circular_profile_image.dart';
import 'package:digiloger/widgets/post_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: SizedBox(
          height: 46,
          child: Image.asset(CustomImages.logo),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.chat_bubble_2),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 61,
            width: double.infinity,
            child: ListView.builder(
              itemCount: 1000,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => SizedBox(
                width: 64,
                height: 64,
                child: CircularProfileImage(imageURL: CustomImages.domeURL),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 1000,
              itemBuilder: (context, index) => const PostTile(),
            ),
          ),
        ],
      ),
    );
  }
}
