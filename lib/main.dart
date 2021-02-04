import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

import 'package:sec2hand/ui_screens/addProductForm/secondpagecar.dart';
import 'package:sec2hand/ui_screens/addProductForm/secondpagemobile.dart';
import 'package:sec2hand/ui_screens/addProductForm/secondpagemotercycle.dart';
import 'package:sec2hand/ui_screens/addProductForm/secondpagescooter.dart';
import 'package:sec2hand/ui_screens/addProductPage.dart';
import 'package:sec2hand/ui_screens/productDetailsPage2.dart';

import 'package:sec2hand/ui_screens/search_page_default.dart';
import 'package:sec2hand/ui_screens/sortPage.dart';
import 'package:sec2hand/ui_screens/splash_screen.dart';
import 'package:sec2hand/ui_screens/addProductForm/firstpage.Dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var slug;
  void initState() {
    super.initState();
    initDynamicLinks();
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        Navigator.pushNamed(context, "prodct-detail-page2");
        slug = deepLink.path;
      } else {
        print("Something is Wrong");
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      Navigator.pushNamed(context, "prodct-detail-page2");
    }
  }

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
        "add": (context) => AddProductPage(),
        "prodct-detail-page2": (context) => ProductDetail2(slug),
      },
      title: 'Sec2Hand',
    );
  }
}
