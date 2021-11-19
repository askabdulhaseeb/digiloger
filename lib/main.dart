import 'package:digiloger/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const Color _primary = Color(0xFF3A5899);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digiloger',
      theme: ThemeData(
        primaryColor: _primary,
      ),
      home: const LoginScreen(),
      routes: <String, WidgetBuilder>{
        LoginScreen.routeName: (_) => const LoginScreen(),
      },
    );
  }
}
