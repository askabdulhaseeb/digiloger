import 'package:digiloger/providers/main_bottom_nav_bar_provider.dart';
import 'package:digiloger/screens/main_screen/pages/add_digilog_page.dart';
import 'package:digiloger/screens/main_screen/pages/calendar_page.dart';
import 'package:digiloger/screens/main_screen/pages/home_page.dart';
import 'package:digiloger/screens/main_screen/pages/notification_page.dart';
import 'package:digiloger/screens/main_screen/pages/profile_page.dart';
import 'package:digiloger/screens/main_screen/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_bottom_navigation_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const String routeName = '/MainScreen';
  static const List<Widget> _pages = <Widget>[
    HomePage(),
    SearchPage(),
    AddDigilogPage(),
    CalendarPage(),
    NotificationPage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    int _currentIndex =
        Provider.of<MainBottomNavBarProvider>(context).currentTap;
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: const MainBottomNavigationBar(),
    );
  }
}
