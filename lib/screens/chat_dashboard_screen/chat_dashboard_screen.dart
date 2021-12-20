import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digiloger/database/user_api.dart';
import 'package:digiloger/models/app_user.dart';
import 'package:digiloger/models/chats.dart';
import 'package:digiloger/services/user_local_data.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../chat_screen/personal_screen.dart';
import '../../utilities/custom_image.dart';
import '../../utilities/utilities.dart';

class ChatDashboardScreen extends StatefulWidget {
  const ChatDashboardScreen({Key? key}) : super(key: key);
  static const String routeName = '/ChatDashboardScreen';
  @override
  State<ChatDashboardScreen> createState() => _ChatDashboardScreenState();
}

class _ChatDashboardScreenState extends State<ChatDashboardScreen> {
  // Chat chat = Chat(
  //     chatID: 'chatID',
  //     persons: ['persons'],
  //     lastMessage: 'lastMessage',
  //     time: 'time');
  Future<List<AppUser>> _users(List<Chat> chat) async {
    List<AppUser> _otherUser = <AppUser>[];
    for (Chat tempChat in chat) {
      String _tempUID = '';
      if (tempChat.persons[0] == UserLocalData.getUID) {
        _tempUID = tempChat.persons[1];
      } else {
        _tempUID = tempChat.persons[0];
      }
      _otherUser.add(await UserAPI().getInfo(uid: _tempUID));
    }
    return _otherUser;
  }

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
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .where('persons', arrayContains: UserLocalData.getUID)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      default:
                        if (snapshot.hasData) {
                          List<Chat> chat = <Chat>[];
                          for (QueryDocumentSnapshot<Map<String, dynamic>> doc
                              in snapshot.data!.docs) {
                            chat.add(Chat.fromDoc(doc));
                          }

                          return (snapshot.data!.docs.isEmpty)
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const <Widget>[
                                      Icon(Icons.mark_chat_unread_outlined),
                                      SizedBox(height: 8),
                                      Text(
                                        'No chat available',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                )
                              : _showChatsTile(chat);
                        } else {
                          return _errorWidget();
                        }
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }

  FutureBuilder<List<AppUser>> _showChatsTile(List<Chat> chat) {
    return FutureBuilder<List<AppUser>>(
        future: _users(chat),
        builder:
            (BuildContext context, AsyncSnapshot<List<AppUser>> otherUsers) {
          switch (otherUsers.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            default:
              if (otherUsers.hasData) {
                return ListView.builder(
                    itemCount: chat.length,
                    itemBuilder: (BuildContext context, int index) {
                      String _otherUid = chat[index].persons[0];
                      if (chat[index].persons[0] == UserLocalData.getUID) {
                        _otherUid = chat[index].persons[1];
                      } else {
                        _otherUid = chat[index].persons[0];
                      }
                      AppUser _secPerson = otherUsers.data!.firstWhere(
                          (AppUser element) => element.uid == _otherUid);
                      return ListTile(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<PersonalChatScreen>(
                            builder: (BuildContext context) =>
                                PersonalChatScreen(
                              otherUser: _secPerson,
                              chat: chat[index],
                            ),
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
                          _secPerson.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          chat[index].lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          chat[index].time,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      );
                    });
              } else {
                return _errorWidget();
              }
          }
        });
  }

  Column _errorWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: const <Widget>[
        Icon(Icons.report, color: Colors.grey),
        Text(
          'Some issue found',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
