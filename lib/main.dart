import 'package:digiloger/screens/digilog_view_screen/digilog_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/digilog.dart';
import 'providers/digilog_provider.dart';
import 'providers/main_bottom_nav_bar_provider.dart';
import 'services/user_local_data.dart';
import 'screens/main_screen/main_screen.dart';
import 'screens/adddigilog_screen/add_details.dart';
import 'screens/adddigilog_screen/camerapage.dart';
import 'screens/adddigilog_screen/cameraview.dart';
import 'screens/adddigilog_screen/digilog_experiences.dart';
import 'screens/auth/business_registeration_screen.dart';
import 'screens/auth/forget_password_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/personal_registeration_screen.dart';
import 'screens/auth/registeration_type_screen.dart';
import 'screens/chat_dashboard_screen/chat_dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await UserLocalData.init();
  Hive.registerAdapter(LocationAdapter());
  Hive.registerAdapter(CommentsAdapter());
  Hive.registerAdapter(ExperiencesAdapter());
  Hive.registerAdapter(DigilogAdapter());
  await Hive.openBox<Digilog>("digilog");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const Color _primary = Color(0xFF3A5899);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // ignore: always_specify_types
      providers: [
        ChangeNotifierProvider<MainBottomNavBarProvider>(
          create: (BuildContext context) => MainBottomNavBarProvider(),
        ),
        ChangeNotifierProvider<DigilogProvider>(
          create: (BuildContext context) => DigilogProvider(),
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
          ChatDashboardScreen.routeName: (_) => const ChatDashboardScreen(),
          AddDetails.routeName: (_) => const AddDetails(),
          CameraScreen.routeName: (_) => const CameraScreen(),
          CameraViewPage.routeName: (_) => const CameraViewPage(),
          DigilogExperiences.routeName: (_) => const DigilogExperiences(),
          DigilogView.routeName: (_) => const DigilogView(),
        },
      ),
    );
  }
}

// Certificate fingerprints:
//  SHA1: F6:3C:6E:07:37:98:D1:37:8D:8D:AD:2B:80:BE:5E:2C:50:EF:71:F9
//  SHA256: B8:1F:B2:FF:CB:2E:A2:45:12:1B:22:43:35:C5:B6:CC:A5:3B:CE:D4:6B:97:93:EF:76:D9:81:0F:F9:16:4C:6E
