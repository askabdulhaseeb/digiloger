import 'package:digiloger/models/digilog.dart';
import 'package:digiloger/utilities/custom_image.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class DigiLogCard extends StatefulWidget {
  const DigiLogCard({Key? key, required this.digilogs}) : super(key: key);

  final List<Digilog> digilogs;

  @override
  _DigiLogCardState createState() => _DigiLogCardState();
}

class _DigiLogCardState extends State<DigiLogCard> {
  String mediaUrl = "";
  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 430,
            width: 200.0,
            child: ListView(
              children:
                  List<Widget>.generate(widget.digilogs.length, (int index) {
                if (widget.digilogs[index].experiences.isEmpty) {
                  setState(() {
                    mediaUrl =
                        "https://i.ibb.co/qmJq2kQ/fotografu-wrhh-CD6jpj8-unsplash.jpg";
                  });
                } else {
                  setState(() {
                    mediaUrl = widget.digilogs[index].experiences[0].mediaUrl;
                  });
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
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                            margin: const EdgeInsets.all(5),
                            child: ExtendedImage.network(
                              CustomImages.domeURL,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.digilogs[index].title.toUpperCase(),
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        )
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
