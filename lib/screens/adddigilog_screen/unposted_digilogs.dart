import 'package:digiloger/database/digilog_api.dart';
import 'package:digiloger/models/digilog.dart';
import 'package:flutter/material.dart';
import 'digilog_cards.dart';

class Unposteddigilogs extends StatefulWidget {
  const Unposteddigilogs({Key? key}) : super(key: key);
  @override
  _UnposteddigilogsState createState() => _UnposteddigilogsState();
}

class _UnposteddigilogsState extends State<Unposteddigilogs> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Digilog>>(
        future: getdigilogs(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Text(
                "No Unposted Digilogs",
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 22),
              );
            } else {
              return DigiLogCard(digilogs: snapshot.data!);
            }
          } else {
            return Text(
              "No Unposted Digilogs",
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 22),
            );
          }
        });
  }

  Future<List<Digilog>> getdigilogs() async {
    return await DigilogAPI().getalldigilog();
  }
}
