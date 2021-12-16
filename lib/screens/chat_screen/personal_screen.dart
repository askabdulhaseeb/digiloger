import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import 'package:digiloger/utilities/custom_image.dart';
import 'package:digiloger/utilities/utilities.dart';

class PersonalChatScreen extends StatefulWidget {
  const PersonalChatScreen({required this.user, Key? key}) : super(key: key);
  final int user;
  @override
  State<PersonalChatScreen> createState() => _PersonalChatScreenState();
}

class _PersonalChatScreenState extends State<PersonalChatScreen> {
  final TextEditingController _text = TextEditingController();
  void _onListener() => setState(() {});
  @override
  void initState() {
    _text.addListener(_onListener);
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
              child: ListView.builder(
                shrinkWrap: true,
                reverse: true,
                itemCount: widget.user + 2,
                itemBuilder: (BuildContext context, int index) {
                  return Material(
                    child: SizedBox(
                      child: MessageTile(
                        boxWidth: _size.width * 0.65,
                        message: 'Utilities.demoParagraph sad sdsa dsd sd sdd',
                        sendBy: 'Send By',
                        isMe: index % 2 == 0 ? true : false,
                        displayTime: 'few seconds ago',
                      ),
                    ),
                  );
                },
              ),
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
                  onPressed: () {},
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Name of User ${widget.user}',
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
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  const MessageTile({
    Key? key,
    required this.message,
    required this.sendBy,
    required this.displayTime,
    required this.boxWidth,
    this.isMe = false,
  }) : super(key: key);
  final String message;
  final bool isMe;
  final String sendBy;
  final String displayTime;
  final double boxWidth;
  @override
  Widget build(BuildContext context) {
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
                        // User name
                        (sendBy == null) ? '' : sendBy,
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
                          message,
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
                        displayTime,
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
