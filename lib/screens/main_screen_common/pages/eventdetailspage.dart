import 'package:digiloger/database/event_api.dart';
import 'package:digiloger/database/user_api.dart';
import 'package:digiloger/models/app_user.dart';
import 'package:digiloger/models/digilog.dart';
import 'package:digiloger/models/event_model.dart';
import 'package:digiloger/providers/main_bottom_nav_bar_provider.dart';
import 'package:digiloger/services/user_local_data.dart';
import 'package:digiloger/utilities/custom_image.dart';
import 'package:digiloger/utilities/utilities.dart';
import 'package:digiloger/widgets/custom_text_button.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventDetailPage extends StatefulWidget {
  const EventDetailPage({Key? key, required this.event}) : super(key: key);
  final Event event;

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  bool isgoing = false;
  bool isintres = false;
  bool _iskeyboard = false;
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _iskeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    setstatus();
    MainBottomNavBarProvider _navBar =
        Provider.of<MainBottomNavBarProvider>(context);
    String mediaUrl = "";
    if (widget.event.coverimage == "") {
      mediaUrl = "https://i.ibb.co/qmJq2kQ/fotografu-wrhh-CD6jpj8-unsplash.jpg";
    } else {
      mediaUrl = widget.event.coverimage;
    }
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
            const SizedBox(height: 16),
            buttons(widget.event),
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
            const SizedBox(height: 30),
            (isgoing)
                ? TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: "Review",
                      hintText: "Write a review",
                      suffixIcon: IconButton(
                        splashRadius: Utilities.padding,
                        onPressed: addreview,
                        icon: const Icon(Icons.arrow_forward_ios, size: 18),
                      ),
                      focusColor: Theme.of(context).primaryColor,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius:
                            BorderRadius.circular(Utilities.borderRadius),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                        borderRadius:
                            BorderRadius.circular(Utilities.borderRadius),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget buttons(Event event) {
    if (isgoing == true) {
      return CustomTextButton(
          text: 'Going'.toUpperCase(),
          onTap: () => notgoing(event),
          hollowButton: false);
    } else if (isintres) {
      return CustomTextButton(
          text: 'Intrested'.toUpperCase(),
          onTap: () => notinter(event),
          hollowButton: false);
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CustomTextButton(
            text: 'Going'.toUpperCase(),
            onTap: () => going(event),
          ),
          CustomTextButton(
              text: 'Interested'.toUpperCase(), onTap: () => intrested(event)),
        ],
      );
    }
  }

  void going(Event event) async {
    bool t = await EventAPI().addgoing(event: event, uid: UserLocalData.getUID);
    if (t) {
      if (isgoing) {
        setState(() {
          isgoing = false;
        });
      } else {
        setState(() {
          isgoing = true;
        });
      }
    }
  }

  void notgoing(Event event) async {
    bool t = await EventAPI().addgoing(event: event, uid: UserLocalData.getUID);
    if (t) {
      if (isgoing) {
        setState(() {
          isgoing = false;
        });
      } else {
        setState(() {
          isgoing = true;
        });
      }
    }
  }

  void notinter(Event event) async {
    bool t =
        await EventAPI().addintrested(event: event, uid: UserLocalData.getUID);
    if (t) {
      if (isintres) {
        setState(() {
          isintres = false;
        });
      } else {
        setState(() {
          isintres = true;
        });
      }
    }
  }

  void intrested(Event event) async {
    bool t =
        await EventAPI().addintrested(event: event, uid: UserLocalData.getUID);
    if (t) {
      if (isintres) {
        setState(() {
          isintres = false;
        });
      } else {
        setState(() {
          isintres = true;
        });
      }
    }
  }

  void setstatus() {
    String s =
        EventAPI().getstatus(event: widget.event, uid: UserLocalData.getUID);
    if (s == "i") {
      setState(() {
        isintres = true;
        isgoing = false;
      });
    } else if (s == "g") {
      setState(() {
        isintres = false;
        isgoing = true;
      });
    } else if (s == "n") {
      setState(() {
        isintres = false;
        isgoing = false;
      });
    }
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

  void addreview() {
    Comments comment = Comments(
        likes: <String>[],
        message: _controller.text.trim(),
        uid: UserLocalData.getUID);
    widget.event.reviews.add(comment);

    setState(() {});
  }
}
