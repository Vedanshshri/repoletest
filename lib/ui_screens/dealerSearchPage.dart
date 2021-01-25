import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sec2hand/apiCalls.dart';

import '../staticdata.dart';
import '../theme.dart';
import 'productListPage.dart';

class DealerSearch extends StatefulWidget {
  get categoryProduct => null;

  @override
  State<StatefulWidget> createState() {
    return _DealerSearch();
  }
}

class _DealerSearch extends State<DealerSearch> {
  var selectedColor = Colors.blue;
  var normalColor = Colors.transparent;
  var selectedTextColor = Colors.white;
  var normalTextColor = Colors.black;
  var selectedItem = "bike";
  var selectedSub = "motorcycle";

  List _cityOption = [];
  String _city;

  @override
  void initState() {
    super.initState();
    _cityOption = getCityList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              color: Colors.black,
              onPressed: () {
                Navigator.pushNamed(context, "addFirstPAge");
              })
        ],
        backgroundColor: Colors.white,
        title: Text(
          "Sec2Hand",
          style: ThemeApp().appBarTheme(),
        ),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedItem = "bike";
                      });
                    },
                    child: Image.asset(
                      "assets/bike.png",
                      width: 70,
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        selectedItem = "bike";
                      });
                    },
                    color: selectedItem == "bike" ? selectedColor : normalColor,
                    child: Text(
                      "Bike",
                      style: TextStyle(
                          fontFamily: 'raleway',
                          color: selectedItem == "bike"
                              ? selectedTextColor
                              : normalTextColor),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedItem = "car";
                      });
                    },
                    child: Image.asset(
                      "assets/car.png",
                      width: 70,
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        selectedItem = "car";
                      });
                    },
                    color: selectedItem == "car" ? selectedColor : normalColor,
                    child: Text(
                      "Car",
                      style: TextStyle(
                          fontFamily: 'raleway',
                          color: selectedItem == "car"
                              ? selectedTextColor
                              : normalTextColor),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedItem = "mobile";
                      });
                    },
                    child: Image.asset(
                      "assets/smartphone.png",
                      width: 70,
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        selectedItem = "mobile";
                      });
                    },
                    color:
                        selectedItem == "mobile" ? selectedColor : normalColor,
                    child: Text(
                      "Mobile",
                      style: TextStyle(
                          fontFamily: 'raleway',
                          color: selectedItem == "mobile"
                              ? selectedTextColor
                              : normalTextColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Visibility(
              visible: selectedItem == "bike" ? true : false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedSub = "motorcycle";
                          });
                        },
                        child: Image.asset(
                          "assets/bycicle.png",
                          width: 70,
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            selectedSub = "motorcycle";
                          });
                        },
                        color: selectedSub == "motorcycle"
                            ? selectedColor
                            : normalColor,
                        child: Text(
                          "MotorCycle",
                          style: TextStyle(
                              fontFamily: 'raleway',
                              color: selectedSub == "motorcycle"
                                  ? selectedTextColor
                                  : normalTextColor),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedSub = "scooter";
                          });
                        },
                        child: Image.asset(
                          "assets/scooter.png",
                          width: 70,
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            selectedSub = "scooter";
                          });
                        },
                        color: selectedSub == "scooter"
                            ? selectedColor
                            : normalColor,
                        child: Text(
                          "Scooter",
                          style: TextStyle(
                              fontFamily: 'raleway',
                              color: selectedSub == "scooter"
                                  ? selectedTextColor
                                  : normalTextColor),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
          Visibility(
              visible: selectedItem == "bike" ? true : false,
              child: SizedBox(
                height: 30,
              )),
          // Divider(
          //   height: 2,
          // ),
          // ListTile(
          //   title: TextFormField(
          //     validator: (value) {
          //       if (value.isEmpty) {
          //         return 'Required';
          //       }
          //       return null;
          //     },
          //     controller: _area,
          //     decoration: InputDecoration(
          //         border: OutlineInputBorder(borderSide: BorderSide.none),
          //         focusedBorder:
          //         OutlineInputBorder(borderSide: BorderSide.none),
          //         labelText: "Area"),
          //   ),
          //   trailing: Icon(
          //     Icons.my_location,
          //     color: Colors.grey,
          //   ),
          // ),
          Divider(
            height: 2,
          ),
          ListTile(
            title: FormField(
              builder: (FormFieldState state) {
                return InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Choose any City',
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  isEmpty: _city == "",
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _city,
                      isDense: true,
                      onChanged: (String newValue) {
                        setState(() {
                          _city = newValue;
                          state.didChange(newValue);
                        });
                      },
                      items: _cityOption.map((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: ThemeApp().textSemiBoldTheme(),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(
            height: 2,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
            child: RaisedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProductListPage(
                        selectedItem == "bike" ? selectedSub : selectedItem,
                        _city)));
              },
              color: Color(0xff005ad2),
              child: Text(
                "Search",
                style: ThemeApp().buttonTextTheme(),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
