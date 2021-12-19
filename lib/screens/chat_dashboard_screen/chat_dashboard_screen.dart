import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../chat_screen/personal_screen.dart';
import '../../utilities/custom_image.dart';
import '../../utilities/utilities.dart';

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
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<PersonalChatScreen>(
                      builder: (BuildContext context) =>
                          PersonalChatScreen(user: index.toString()),
                    ),
                  ),
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
