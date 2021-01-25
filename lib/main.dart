import 'package:flutter/material.dart';

import 'package:sec2hand/ui_screens/addProductForm/secondpagecar.dart';
import 'package:sec2hand/ui_screens/addProductForm/secondpagemobile.dart';
import 'package:sec2hand/ui_screens/addProductForm/secondpagemotercycle.dart';
import 'package:sec2hand/ui_screens/addProductForm/secondpagescooter.dart';
import 'package:sec2hand/ui_screens/addProductPage.dart';

import 'package:sec2hand/ui_screens/search_page_default.dart';
import 'package:sec2hand/ui_screens/sortPage.dart';
import 'package:sec2hand/ui_screens/splash_screen.dart';
import 'package:sec2hand/ui_screens/addProductForm/firstpage.Dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "home",
      routes: {
        "home": (context) => SplashScreen(),
        "sortpage": (context) => SortPage(),
        "SearchPage": (context) => SearchList(),
        "addFirstPAge": (context) => CategoryPageAdd(),
        "AddProductMobile": (context) => CategoryPageAddSecond(" ", " "),
        "AddProductCarSecond": (context) => CategoryPageAddSecondCar(),
        "AddProductScooterSecond": (context) => CategoryPageAddSecondScooter(),
        "AddProductMoterCycleSecond": (context) =>
            CategoryPageAddSecondMoterCycle(),
        "add": (context) => AddProductPage()
      },
      title: 'Sec2Hand',
    );
  }
}
