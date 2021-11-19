import 'package:flutter/material.dart';

class BusinessRegisterationScreen extends StatefulWidget {
  const BusinessRegisterationScreen({Key? key}) : super(key: key);
  static const String routeName = '/BusinessRegisterationScreen';
  @override
  _BusinessRegisterationScreenState createState() =>
      _BusinessRegisterationScreenState();
}

class _BusinessRegisterationScreenState
    extends State<BusinessRegisterationScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Business Registeration Screen'),
      ),
    );
  }
}
