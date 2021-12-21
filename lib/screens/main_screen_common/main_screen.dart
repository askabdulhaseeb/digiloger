import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../providers/main_bottom_nav_bar_provider.dart';
import 'pages/add_digilog_page.dart';
import 'pages/calendar_page.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart';
import 'pages/search_page.dart';
import 'main_bottom_navigation_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const String routeName = '/MainScreen';
  static const List<Widget> _pages = <Widget>[
    HomePage(),
    SearchPage(),
    AddDigilogPage(),
    //TODO:Add Notifications Page if get time
    CalendarPage(),
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
