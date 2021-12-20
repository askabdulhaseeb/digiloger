import 'package:digiloger/database/chat_api.dart';
import 'package:digiloger/models/app_user.dart';
import 'package:digiloger/models/chats.dart';
import 'package:digiloger/models/messages.dart';
import 'package:digiloger/services/user_local_data.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import '../../utilities/custom_image.dart';
import '../../utilities/utilities.dart';

class PersonalChatScreen extends StatefulWidget {
  const PersonalChatScreen(
      {required this.otherUser, required this.chat, Key? key})
      : super(key: key);
  final AppUser otherUser;
  final Chat chat;
  @override
  State<PersonalChatScreen> createState() => _PersonalChatScreenState();
}

class _PersonalChatScreenState extends State<PersonalChatScreen> {
  final TextEditingController _text = TextEditingController();
  late String chatID;
  // late Chat chat;
  void _init() async {
    chatID = ChatAPI.getChatID(othersUID: widget.otherUser.uid);
    // await ChatAPI().fetchMessages(chatID);
    // chat = await ChatAPI().fetchChat(chatID);
  }

  void _onListener() => setState(() {});
  @override
  void initState() {
    _text.addListener(_onListener);
    _init();
    super.initState();
  }

  @override
  void dispose() {
    _text.removeListener(_onListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Utilities.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<List<Messages>>(
                  stream: ChatAPI().fetchMessages(chatID).asStream(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Messages>> snapshot) {
                    if (snapshot.hasData) {
                      final List<Messages>? _messages = snapshot.data;
                      return ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        itemCount: _messages!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Material(
                            child: SizedBox(
                              child: _MessageTile(
                                boxWidth: _size.width * 0.65,
                                message: _messages[index],
                                displayName: (_messages[index].sendBy ==
                                        UserLocalData.getUID)
                                    ? UserLocalData.getName
                                    : widget.otherUser.name,
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
            ),
            _chatTextFormField(context),
            SizedBox(height: Utilities.padding),
          ],
        ),
      ),
    );
  }

  Padding _chatTextFormField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Utilities.padding),
      child: TextFormField(
        controller: _text,
        decoration: InputDecoration(
          hintText: 'Text Message',
          suffixIcon: (_text.text.isNotEmpty)
              ? IconButton(
                  splashRadius: 20,
                  onPressed: () async {
                    await ChatAPI().sendMessage(
                      Chat(
                          chatID: chatID,
                          persons: [UserLocalData.getUID, widget.otherUser.uid],
                          lastMessage: _text.text.trim(),
                          time: DateTime.now().toString()),
                      Messages(
                          messageID:
                              DateTime.now().microsecondsSinceEpoch.toString(),
                          message: _text.text.trim(),
                          timestamp: DateTime.now().toString(),
                          sendBy: UserLocalData.getUID),
                    );
                    _text.clear();
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.send,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : IconButton(
                  splashRadius: 20,
                  onPressed: () {},
                  icon: Icon(
                    Icons.attachment,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Utilities.borderRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Utilities.borderRadius),
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      titleSpacing: 0,
      title: Row(
        children: <Widget>[
          ExtendedImage.network(
            CustomImages.domeURL,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
            cache: true,
            shape: BoxShape.circle,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.otherUser.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white),
                ),
                // TODO: online/offline need to fix
                const Text(
                  'online / offline',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageTile extends StatelessWidget {
  const _MessageTile({
    Key? key,
    required this.message,
    required this.displayName,
    required this.boxWidth,
  }) : super(key: key);
  final Messages message;
  final String displayName;
  final double boxWidth;
  @override
  Widget build(BuildContext context) {
    final bool isMe = UserLocalData.getUID == message.sendBy;
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Wrap(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              // : const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                // Message Container Design
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(24),
                  bottomRight: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(24),
                  topRight: const Radius.circular(24),
                  bottomLeft: isMe
                      ? const Radius.circular(24)
                      : const Radius.circular(0),
                ),
                color: isMe
                    ? Theme.of(context).primaryColor
                    : const Color(0xfff0f0fA),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        displayName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: (isMe) ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: boxWidth,
                        child: Text(
                          message.message,
                          style: TextStyle(
                            color: (isMe) ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        message.timestamp,
                        style: TextStyle(
                          color: (isMe) ? Colors.white70 : Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
