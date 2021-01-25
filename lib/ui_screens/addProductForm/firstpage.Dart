import 'package:flutter/material.dart';
import 'package:sec2hand/ui_screens/addProductForm/secondpagemobile.dart';
import 'package:sec2hand/ui_screens/addProductForm/secondpagemotercycle.dart';

class CategoryPageAdd extends StatefulWidget {
  @override
  _CategoryPageAddState createState() => _CategoryPageAddState();
}

class _CategoryPageAddState extends State<CategoryPageAdd> {
  var selectedColor = Colors.blue;
  var normalColor = Colors.transparent;
  var selectedTextColor = Colors.white;
  var normalTextColor = Colors.black;
  var selectedItem = "bike";
  var selectedSub = "motorcycle";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Product",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(
              height: 20,
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
                      color:
                          selectedItem == "bike" ? selectedColor : normalColor,
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
                      color:
                          selectedItem == "car" ? selectedColor : normalColor,
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
                      color: selectedItem == "mobile"
                          ? selectedColor
                          : normalColor,
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
            SizedBox(
              height: 30,
            ),
            RaisedButton(
                color: Colors.blue,
                child: Text("Next"),
                onPressed: () {
                  if (selectedItem == "mobile") {
                    Navigator.pushNamed(
                      context,
                      "AddProductMobile",
                    );
                    print(selectedItem);
                    print(selectedSub);
                  } else if (selectedItem == "car") {
                    Navigator.pushNamed(context, "AddProductCarSecond");
                    print(selectedItem);
                    print(selectedSub);
                  } else if (selectedItem == 'bike' &&
                      selectedSub == 'motercycle') {
                    Navigator.pushNamed(context, "AddProductMoterCycleSecond");

                    print(selectedItem);
                    print(selectedSub);
                  } else if (selectedItem == "bike" &&
                      selectedSub == 'scooter') {
                    Navigator.pushNamed(context, "AddProductScooterSecond");
                    print(selectedItem);
                    print(selectedSub);
                  }
                })
          ],
        ));
  }
}
