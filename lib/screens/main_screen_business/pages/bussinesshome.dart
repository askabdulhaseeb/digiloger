import 'package:digiloger/utilities/custom_image.dart';
import 'package:digiloger/widgets/eventcardshosted.dart';
import 'package:flutter/material.dart';

class BusinessHome extends StatefulWidget {
  BusinessHome({Key? key}) : super(key: key);

  @override
  _BusinessHomeState createState() => _BusinessHomeState();
}

class _BusinessHomeState extends State<BusinessHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: SizedBox(
          height: 46,
          child: Image.asset(CustomImages.logo),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 15, 8, 8),
        child: Column(
          children: <Widget>[
            Center(
              child: Text(
                "Hosted Events".toUpperCase(),
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 10),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Expanded(
              child: EventCardHosted(),
            ),
          ],
        ),
      ),
    );
  }
}
