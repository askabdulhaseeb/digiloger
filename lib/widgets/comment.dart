import 'package:digiloger/database/digilog_api.dart';
import 'package:digiloger/models/digilog.dart';
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          comment.uid,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(comment.message),
        const SizedBox(height: 2),
        Row(
          children: <Widget>[
            const Spacer(),
            Text(
              comment.timestamp,
              textAlign: TextAlign.end,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        )
      ],
    );
  }
}
