import 'package:digiloger/providers/main_bottom_nav_bar_provider.dart';
import 'package:digiloger/screens/main_screen/main_screen.dart';
import 'package:digiloger/services/user_local_data.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'screens/auth/business_registeration_screen.dart';
import 'screens/auth/forget_password_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/personal_registeration_screen.dart';
import 'screens/auth/registeration_type_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserLocalData.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const Color _primary = Color(0xFF3A5899);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MainBottomNavBarProvider>(
          create: (BuildContext context) => MainBottomNavBarProvider(),
        ),
      ],
      child: MaterialApp(
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
        home: (UserLocalData.getUID.isEmpty)
            ? const LoginScreen()
            : const MainScreen(),
        routes: <String, WidgetBuilder>{
          LoginScreen.routeName: (_) => const LoginScreen(),
          ForgetPasswordScreen.routeName: (_) => ForgetPasswordScreen(),
          RegisterationTypeScreen.routeName: (_) =>
              const RegisterationTypeScreen(),
          PersonalRegisterationScreen.routeName: (_) =>
              const PersonalRegisterationScreen(),
          BusinessRegisterationScreen.routeName: (_) =>
              const BusinessRegisterationScreen(),
          MainScreen.routeName: (_) => const MainScreen(),
        },
      ),
    );
  }
}

// Certificate fingerprints:
//  SHA1: F6:3C:6E:07:37:98:D1:37:8D:8D:AD:2B:80:BE:5E:2C:50:EF:71:F9
//  SHA256: B8:1F:B2:FF:CB:2E:A2:45:12:1B:22:43:35:C5:B6:CC:A5:3B:CE:D4:6B:97:93:EF:76:D9:81:0F:F9:16:4C:6E
