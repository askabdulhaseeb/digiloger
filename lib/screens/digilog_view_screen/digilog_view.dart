import 'package:digiloger/models/digilog.dart';
import 'package:digiloger/providers/digilog_provider.dart';
import 'package:digiloger/widgets/digilog_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DigilogView extends StatefulWidget {
  const DigilogView({Key? key}) : super(key: key);
  static const String routeName = '/Digilog_view';

  @override
  _DigilogViewState createState() => _DigilogViewState();
}

class _DigilogViewState extends State<DigilogView> {
  final PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    DigilogProvider _provider = Provider.of<DigilogProvider>(context);
    Digilog _digilog = _provider.currentdigilog;
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: PageView(
        scrollDirection: Axis.vertical,
        controller: _controller,
        children: getpages(_digilog),
      ),
    );
  }

  List<Widget> getpages(Digilog digilog) {
    List<Widget> pages = <Widget>[];
    for (int i = 0; i < digilog.experiences.length; i++) {
      pages.add(DigilogScreen(
        digilog: digilog,
        index: i,
      ));
    }
    return pages;
  }
}
