import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rigify/app/favorites_page/favorites_page.dart';
import 'package:rigify/app/home_page/home_page.dart';
import 'package:rigify/app/news_page/news_page.dart';

class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  int _selectedIndex = 1;

  static const List<Widget> _widgetOptions = [
    FavoritePage(),
    HomePage(),
    NewsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: NavigationBar(
        height: 66,
        destinations: const [
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.heart),
            label: '',
          ),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.house),
            label: '',
          ),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.newspaper),
            label: '',
          ),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
      ),
    );
  }
}
