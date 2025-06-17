import 'package:agro/pages/farmer_home.dart';
import 'package:agro/pages/government_schemes_screen.dart';
import 'package:agro/pages/job_search_screen.dart';
import 'package:agro/pages/marketplace_screen.dart';
import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  final List<Widget> _screens = [
    FarmerHome(),
    JobSearch(),
    GovernmentSchemes(),
    AgriculturalMarketPlace(),
  ];
  Widget get currentScreen => _screens[_selectedIndex];

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}