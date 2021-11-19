import 'package:flutter/material.dart';

class PersonalRegisterationScreen extends StatefulWidget {
  const PersonalRegisterationScreen({Key? key}) : super(key: key);
  static const String routeName = '/PersonalRegisterationScreen';
  @override
  _PersonalRegisterationScreenState createState() =>
      _PersonalRegisterationScreenState();
}

class _PersonalRegisterationScreenState
    extends State<PersonalRegisterationScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Persoonal Registeration Type Screen'),
      ),
    );
  }
}
