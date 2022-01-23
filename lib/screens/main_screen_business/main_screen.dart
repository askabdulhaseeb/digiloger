import 'package:digiloger/screens/main_screen_business/pages/add_event.dart';
import 'package:digiloger/screens/main_screen_business/pages/businessProfile.dart';
import 'package:digiloger/screens/main_screen_business/pages/bussinesshome.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../providers/main_bottom_nav_bar_provider.dart';
import 'main_bottom_navigation_bar.dart';

class MainScreenBusiness extends StatelessWidget {
  const MainScreenBusiness({Key? key}) : super(key: key);
  static const String routeName = '/MainScreenBusiness';
  static final List<Widget> _pages = <Widget>[
    BusinessHome(),
    const AddEvent(),
    const BusinessProfile(),
  ];
  @override
  Widget build(BuildContext context) {
    int _currentIndex =
        Provider.of<MainBottomNavBarProvider>(context).currentTap;
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: const MainBottomNavigationBarBusiness(),
    );
  }
}
