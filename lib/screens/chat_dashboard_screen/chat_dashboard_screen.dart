import 'package:digiloger/utilities/custom_image.dart';
import 'package:digiloger/utilities/utilities.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatDashboardScreen extends StatelessWidget {
  const ChatDashboardScreen({Key? key}) : super(key: key);
  static const String routeName = '/ChatDashboardScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Inbox'),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            splashRadius: 20,
            onPressed: () {},
            icon: const Icon(CupertinoIcons.add),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Utilities.padding),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(CupertinoIcons.search),
                hintText: 'Search',
                enabledBorder: UnderlineInputBorder(),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 100,
                itemBuilder: (BuildContext context, int index) => ListTile(
                  onTap: () {},
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: ExtendedImage.network(
                      CustomImages.domeURL,
                      width: 70,
                      height: 74,
                      fit: BoxFit.cover,
                      cache: true,
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: Text(
                    'Name of User $index',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    Utilities.demoParagraph,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
