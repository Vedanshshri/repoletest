import 'package:flutter/material.dart';
import 'package:sec2hand/theme.dart';
import 'package:sec2hand/ui_screens/profilePage.dart';
import 'package:sec2hand/ui_screens/reviewPage.dart';

import '../staticdata.dart';
import 'authPages/loginPage.dart';
import 'dealerSearchPage.dart';

class Menu extends StatefulWidget {
  final indexStatus;
  Menu(this.indexStatus);
  @override
  State<StatefulWidget> createState() {
    return _Menu();
  }
}

class _Menu extends State<Menu> {
  int _selectedPage;
  @override
  void initState() {
    _selectedPage = widget.indexStatus;
    super.initState();
  }

  final _pageOption = [
    DealerSearch(),
    ReviewPage(),
    token == "" ? Login() : ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pageOption[_selectedPage], //_selected page Started with Zero
        bottomNavigationBar: new Theme(
          data: Theme.of(context).copyWith(
              primaryColor: Colors.black,
              canvasColor: Colors.white,
              textTheme: Theme.of(context).textTheme.copyWith(
                  caption: new TextStyle(
                      color: Color.fromRGBO(100, 110, 120, 1.0)))),
          child: BottomNavigationBar(
            currentIndex:
                _selectedPage, // Current Index of the page open right now
            onTap: (int index) {
              setState(() {
                _selectedPage = index; // setting value for _selectedPage
              });
            }, // new

            // this will be set when a new tab is tapped
            items: [
              BottomNavigationBarItem(
                icon: new Icon(Icons.search),
                title: new Text(
                  'PRODUCTS',
                  style: ThemeApp().textBoldTheme(),
                ),
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.star),
                title: new Text('REVIEWS', style: ThemeApp().textBoldTheme()),
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.perm_identity),
                title: new Text('PROFILE', style: ThemeApp().textBoldTheme()),
              ),
            ],
          ),
        ));
  }
}
