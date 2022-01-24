import 'package:digiloger/database/digilog_api.dart';
import 'package:digiloger/database/user_api.dart';
import 'package:digiloger/models/app_user.dart';
import 'package:digiloger/models/digilog.dart';
import 'package:digiloger/screens/other_user_profile/other_user_profile.dart';
import 'package:digiloger/services/user_local_data.dart';
import 'package:flutter/material.dart';

class CommentPopup extends StatefulWidget {
  const CommentPopup({required this.digilog, Key? key}) : super(key: key);
  final Digilog digilog;
  @override
  State<CommentPopup> createState() => _CommentPopupState();
}

class _CommentPopupState extends State<CommentPopup> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: (widget.digilog.comments.isEmpty)
                    ? const Center(
                        child: Text(
                          'No comments available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.separated(
                        itemCount: widget.digilog.comments.length,
                        itemBuilder: (BuildContext context, int index) =>
                            _CommentTile(
                          comment: widget.digilog.comments[index],
                        ),
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(thickness: 1),
                      ),
              ),
              _TestFormField(
                pid: widget.digilog.digilogid,
                comments: widget.digilog.comments,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _TestFormField extends StatefulWidget {
  const _TestFormField({
    required this.pid,
    required this.comments,
    Key? key,
  }) : super(key: key);
  final String pid;
  final List<Comments> comments;
  @override
  __TestFormFieldState createState() => __TestFormFieldState();
}

class __TestFormFieldState extends State<_TestFormField> {
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
    return TextFormField(
      controller: _text,
      decoration: InputDecoration(
        hintText: 'write comment here ...',
        suffixIcon: (_text.text.isNotEmpty)
            ? IconButton(
                splashRadius: 20,
                onPressed: () async {
                  final String _uid = UserLocalData.getUID;
                  Comments _comment = Comments(
                    uid: _uid,
                    message: _text.text.trim(),
                    // timestamp: DateTime.now().microsecondsSinceEpoch.toString(),
                    likes: [],
                  );
                  widget.comments.add(_comment);
                  await DigilogAPI().updateComment(
                    pid: widget.pid,
                    comments: widget.comments,
                  );
                  _text.clear();
                  setState(() {});
                },
                icon: Icon(
                  Icons.send,
                  color: Theme.of(context).primaryColor,
                ),
              )
            : const SizedBox(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({required this.comment, Key? key}) : super(key: key);
  final Comments comment;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppUser>(
        future: UserAPI().getInfo(uid: comment.uid),
        builder: (BuildContext context, AsyncSnapshot<AppUser> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          } else {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Facing some issues'),
              );
            } else {
              final AppUser _user = snapshot.data!;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<OtherUserProfile>(
                        builder: (BuildContext context) => OtherUserProfile(
                          username: _user.email,
                          uid: _user.uid,
                        ),
                      ),
                    ),
                    child: Text(
                      _user.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(comment.message),
                  const SizedBox(height: 2),
                ],
              );
            }
          }
        });
  }
}
