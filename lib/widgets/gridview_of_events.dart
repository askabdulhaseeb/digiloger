import 'package:digiloger/models/event_model.dart';
import 'package:digiloger/screens/main_screen_business/pages/event_details.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class GridViewEvents extends StatelessWidget {
  const GridViewEvents({Key? key, required this.posts}) : super(key: key);
  final List<Event> posts;

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
      itemBuilder: (BuildContext context, int index) => InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => EventDetails(
                event: posts[index],
              ),
            ),
          );
        },
        child: ExtendedImage.network(
          posts[index].coverimage,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
