import 'package:digiloger/database/user_api.dart';
import 'package:digiloger/models/app_user.dart';
import 'package:digiloger/services/user_local_data.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../providers/main_bottom_nav_bar_provider.dart';
import 'pages/add_digilog_page.dart';
import 'pages/calendar_page.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart';
import 'pages/search_page.dart';
import 'main_bottom_navigation_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const String routeName = '/MainScreen';
  static const List<Widget> _pages = <Widget>[
    HomePage(),
    SearchPage(),
    AddDigilogPage(),
    CalendarPage(),
    ProfilePage(),
  ];

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  _init() async {
    final AppUser appUser = await UserAPI().getInfo(uid: UserLocalData.getUID);
    UserLocalData().storeAppUserData(appUser: appUser);
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int _currentIndex =
        Provider.of<MainBottomNavBarProvider>(context).currentTap;
    return Scaffold(
      body: MainScreen._pages[_currentIndex],
      bottomNavigationBar: const MainBottomNavigationBar(),
    );
  }
}
