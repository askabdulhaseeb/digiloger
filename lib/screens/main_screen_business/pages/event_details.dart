import 'package:digiloger/database/user_api.dart';
import 'package:digiloger/models/app_user.dart';
import 'package:digiloger/models/digilog.dart';
import 'package:digiloger/models/event_model.dart';
import 'package:digiloger/utilities/custom_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({Key? key, required this.event}) : super(key: key);
  final Event event;
  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(40.0, 0, 0, 0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.event.name,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 22),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 150,
              width: 150,
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                margin: const EdgeInsets.all(5),
                child: ExtendedImage.network(
                  widget.event.coverimage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _NumInfoWidget(
                  number: widget.event.attendeeslist.length,
                  title: 'Going',
                ),
                _NumInfoWidget(
                  number: widget.event.intrestedlist.length,
                  title: 'Interested',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.event.description,
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 35),
            (widget.event.reviews.isNotEmpty)
                ? SizedBox(
                    width: 100,
                    height: 100,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(0),
                      itemBuilder: (BuildContext context, int index) {
                        return FutureBuilder<AppUser>(
                            future: getuser(widget.event.reviews[index].uid),
                            builder: (BuildContext context,
                                AsyncSnapshot<AppUser> snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return const SizedBox(
                                    height: double.infinity,
                                    width: double.infinity,
                                    child: CircularProgressIndicator.adaptive(),
                                  );
                                default:
                                  if ((snapshot.hasError)) {
                                    return _errorWidget();
                                  } else {
                                    if (snapshot.hasData) {
                                      if (snapshot.data != null) {
                                        return listtile(
                                            widget.event.reviews[index],
                                            snapshot.data!);
                                      } else {
                                        return listtile(
                                            widget.event.reviews[index], null);
                                      }
                                    }
                                  }
                              }
                              return listtile(
                                  widget.event.reviews[index], null);
                            });
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },
                      itemCount: widget.event.reviews.length,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                    ),
                  )
                : Text(
                    "No Reviews posted by attendees",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        fontSize: 14),
                  ),
          ],
        ),
      ),
    );
  }

  Widget listtile(Comments review, AppUser? user) {
    if (user != null) {
      return ListTile(
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
          user.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          review.message,
          style: const TextStyle(color: Colors.grey),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          review.likes.toString() + "Likes",
          style: const TextStyle(color: Colors.grey),
        ),
      );
    } else {
      return ListTile(
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
        title: const Text(
          "Anoymous",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          review.message,
          maxLines: 1,
          style: const TextStyle(color: Colors.grey),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          review.likes.toString() + "Likes",
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }
  }

  Future<AppUser> getuser(String uid) async {
    return UserAPI().getInfo(uid: uid);
  }

  SizedBox _errorWidget() {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Column(
          children: const <Widget>[
            Icon(Icons.info, color: Colors.grey),
            Text(
              'Facing some issues',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _NumInfoWidget extends StatelessWidget {
  const _NumInfoWidget({required this.number, required this.title, Key? key})
      : super(key: key);
  final int number;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          number.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(title)
      ],
    );
  }
}
