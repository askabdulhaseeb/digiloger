import 'package:digiloger/database/event_api.dart';
import 'package:digiloger/models/event_model.dart';
import 'package:digiloger/providers/main_bottom_nav_bar_provider.dart';
import 'package:digiloger/services/user_local_data.dart';
import 'package:digiloger/widgets/custom_text_button.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main_screen.dart';

class EventDetailPage extends StatefulWidget {
  const EventDetailPage({Key? key, required this.event}) : super(key: key);
  final Event event;

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  bool isgoing = false;
  bool isintres = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    ),
                    color: Colors.white,
                    onPressed: () {
                      _navBar.onTabTapped(3);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        MainScreen.routeName,
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
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
                )
              ],
            ),
            const SizedBox(height: 60),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 250,
                  width: 350,
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
                      )),
                ),
                const SizedBox(height: 35),
                buttons(widget.event),
                const SizedBox(height: 35),
                Text(
                  widget.event.description,
                  style: const TextStyle(
                    fontSize: 17,
                  ),
                ),
                ListView.separated(
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (BuildContext context, int index) {
                    return Container();
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
                  },
                  itemCount: widget.event.reviews.length,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                ),
              ],
            ),
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
}
