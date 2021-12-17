import 'package:digiloger/models/digilog.dart';
import 'package:flutter/material.dart';
import 'digilog_cards.dart';

class Unposteddigilogs extends StatefulWidget {
  const Unposteddigilogs({Key? key}) : super(key: key);
  @override
  _UnposteddigilogsState createState() => _UnposteddigilogsState();
}

class _UnposteddigilogsState extends State<Unposteddigilogs> {
  late bool loading;
  late List<Digilog> digilogs = <Digilog>[];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (digilogs.isEmpty) {
      return Text(
        "No Unposted Digilogs",
        style: TextStyle(
            color: Theme.of(context).colorScheme.primary, fontSize: 22),
      );
    } else {
      return DigiLogCard(
        digilogs: digilogs,
      );
    }
  }
}
