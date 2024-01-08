import 'package:flutter/material.dart';

ShapeBorder customShapeBorder = const RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    bottomLeft: Radius.circular(25.0),
    bottomRight: Radius.circular(25.0),
  ),
);

final ThemeData lightTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: const Color(0xfff0eaea),
  bottomAppBarTheme: BottomAppBarTheme(color: Colors.white.withOpacity(0.8)),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: Color(0xff313638),
    unselectedItemColor: Colors.grey,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Color(0xff313638),
  ),
  tabBarTheme: TabBarTheme(
    indicator: ShapeDecoration(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      color: const Color.fromARGB(255, 223, 224, 226),
      shadows: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.05),
          spreadRadius: 1,
          blurRadius: 7,
          offset: const Offset(0, 0), // changes position of shadow
        ),
      ],
    ),
    labelColor: const Color(0xff313638),
    indicatorSize: TabBarIndicatorSize.tab,
    unselectedLabelColor: Colors.grey,
  ),
  cardColor: const Color.fromARGB(255, 245, 246, 250),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xff313638),
    ),
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: Colors.grey.shade300,
  ),
  appBarTheme: const AppBarTheme(
    color: Color.fromARGB(255, 240, 234, 234),
    iconTheme: IconThemeData(color: Color(0xff313638)),
    titleTextStyle: TextStyle(
        color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
  ),
);

final ThemeData darkTheme = ThemeData.dark().copyWith(
  bottomAppBarTheme: const BottomAppBarTheme(color: Color(0xff414141)),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.grey[900],
    selectedItemColor: const Color.fromARGB(255, 240, 234, 234),
    unselectedItemColor: Colors.grey,
  ),
  scaffoldBackgroundColor: const Color(0xff312f31),
  appBarTheme: const AppBarTheme(
      color: Color(0xff312f31),
      iconTheme: IconThemeData(color: Color.fromARGB(255, 240, 234, 234)),
      titleTextStyle: TextStyle(
          color: Color.fromARGB(255, 240, 234, 234),
          fontSize: 18,
          fontWeight: FontWeight.w600)),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Color.fromARGB(255, 221, 211, 211),
  ),
  tabBarTheme: TabBarTheme(
    indicator: ShapeDecoration(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      color: const Color.fromARGB(255, 38, 38, 39),
      shadows: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.05),
          spreadRadius: 1,
          blurRadius: 7,
          offset: const Offset(0, 0),
        ),
      ],
    ),
    indicatorSize: TabBarIndicatorSize.tab,
    labelColor: const Color.fromARGB(255, 240, 234, 234),
    unselectedLabelColor: Colors.grey,
  ),
  // cardTheme: const CardTheme(color: Color.fromARGB(255, 60, 59, 59)),
  cardTheme: CardTheme(color: Colors.grey[900]),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color.fromARGB(255, 240, 234, 234),
    ),
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: Colors.grey.shade900,
  ),
);
