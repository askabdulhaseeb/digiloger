import 'package:digiloger/models/digilog.dart';
import 'package:digiloger/providers/digilog_provider.dart';
import 'package:digiloger/screens/digilog_view_screen/digilog_view.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GridViewOfPosts extends StatelessWidget {
  const GridViewOfPosts({required this.posts, Key? key}) : super(key: key);
  final List<Digilog> posts;

  @override
  Widget build(BuildContext context) {
    DigilogProvider _provider = Provider.of<DigilogProvider>(context);

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      shrinkWrap: true,
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int index) => InkWell(
        onTap: () {
          _provider.onUpdatedigi(posts[index]);
          Navigator.of(context).pushNamed(DigilogView.routeName);
        },
        child: ExtendedImage.network(
          posts[index].experiences.first.mediaUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
