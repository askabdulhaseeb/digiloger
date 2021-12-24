import 'package:digiloger/database/event_api.dart';
import 'package:digiloger/models/event_model.dart';
import 'package:digiloger/services/user_local_data.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class EventCard extends StatefulWidget {
  const EventCard({Key? key}) : super(key: key);
  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String mediaUrl = "";
    return FutureBuilder<List<Event>>(
        future: getevents(),
        builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
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
                  if (snapshot.data!.isNotEmpty) {
                    return Column(children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (snapshot.data![index].coverimage == "") {
                                mediaUrl =
                                    "https://i.ibb.co/qmJq2kQ/fotografu-wrhh-CD6jpj8-unsplash.jpg";
                              } else {
                                mediaUrl = snapshot.data![index].coverimage;
                              }
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () => {},
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 150,
                                        width: 250,
                                        child: Card(
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          elevation: 5,
                                          margin: const EdgeInsets.all(5),
                                          child: ExtendedImage.network(
                                            mediaUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        snapshot.data![index].name,
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ]);
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "No Events hosted yet",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                              fontSize: 14),
                        ),
                      ],
                    );
                  }
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "No Events hosted yet",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                            fontSize: 14),
                      ),
                    ],
                  );
                }
              }
          }
        });
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

  Future<List<Event>> getevents() async {
    return await EventAPI().geteventsbyuserid(userid: UserLocalData.getUID);
  }
}
