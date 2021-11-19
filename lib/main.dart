import 'package:digiloger/screens/auth/business_registeration_screen.dart';
import 'package:digiloger/screens/auth/login_screen.dart';
import 'package:digiloger/screens/auth/personal_registeration_screen.dart';
import 'package:digiloger/screens/auth/registeration_type_screen.dart';
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
        colorScheme: const ColorScheme(
          primary: _primary,
          primaryVariant: _primary,
          secondary: _primary,
          secondaryVariant: Colors.white,
          surface: Colors.white,
          background: Colors.white,
          error: Colors.red,
          onPrimary: _primary,
          onSecondary: _primary,
          onSurface: Colors.white,
          onBackground: Colors.white,
          onError: Colors.redAccent,
          brightness: Brightness.light,
        ),
        primaryColor: _primary,
        iconTheme: const IconThemeData(color: _primary),
        splashColor: Colors.blue[300],
      ),
      home: const LoginScreen(),
      routes: <String, WidgetBuilder>{
        LoginScreen.routeName: (_) => const LoginScreen(),
        RegisterationTypeScreen.routeName: (_) =>
            const RegisterationTypeScreen(),
        PersonalRegisterationScreen.routeName: (_) =>
            const PersonalRegisterationScreen(),
        BusinessRegisterationScreen.routeName: (_) =>
            const BusinessRegisterationScreen(),
      },
    );
  }
}
