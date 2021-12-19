import 'package:digiloger/models/digilog.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class GridViewOfPosts extends StatelessWidget {
  const GridViewOfPosts({required this.posts, Key? key}) : super(key: key);
  final List<Digilog> posts;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      shrinkWrap: true,
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int index) => ExtendedImage.network(
        posts[index].experiences.first.mediaUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
