import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sec2hand/state-city-data.dart';
import 'package:sec2hand/staticdata.dart';
import 'package:sec2hand/theme.dart';
import 'package:sec2hand/ui_screens/productDetailsPage.dart';

import 'package:sec2hand/ui_screens/shared/loading.dart';

class ProductListPage extends StatefulWidget {
  final categoryProduct;
  final cityProduct;

  ProductListPage(this.categoryProduct, this.cityProduct);
  @override
  State<StatefulWidget> createState() {
    return _ProductListPage();
  }
}

class _ProductListPage extends State<ProductListPage> {
  Dio dio = new Dio();
  var categoryProduct;
  var cityProduct;
  //int _car = 0;
  //int _motercycle = 1;
  String _mobile = 'mobile';
  String _caR = 'car';
  String _motercycle = "motorcycle";
  String _scooter = 'scooter';

  ScrollController _scrollController = new ScrollController();

  bool isLoading = false;
  int offset = 0;
  List productList = new List();
  List<String> brandList = new List();
  var hasMore = true;

  var sortvar;
  @override
  void initState() {
    categoryProduct = widget.categoryProduct;
    cityProduct = widget.cityProduct;
    this.fetchProduct();
    create_brand_List();

    super.initState();
    _scrollController.addListener(() {
      if ((_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) &&
          hasMore) {
        fetchProduct();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          RaisedButton(
            onPressed: () {
              offset = 0;

              sortvar = null;
              productList.removeWhere((val) => true);
              fetchProduct();
            },
            child: Text("Clear Filter"),
          ),
        ],
        title: Text(
          "Sec2Hand",
          style: ThemeApp().appBarTheme(),
        ),
        bottom: sortList(),
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: getList(),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new Loading(),
        ),
      ),
    );
  }

  // ignore: missing_return
  Widget sortList() {
    if (categoryProduct == "motorcycle") {
      return PreferredSize(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: sortvar,
              //icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.black),
              underline: Container(
                width: MediaQuery.of(context).size.width,
                height: 2,
                color: Colors.grey,
              ),
              onChanged: (String newValue) {
                sortvar = newValue;
                offset = 0;
                productList.removeWhere((val) => true);
                fetchProduct();
              },
              items: brandList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
        preferredSize: Size.fromHeight(40.0),
      );
    } else if (categoryProduct == "car") {
      return PreferredSize(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: sortvar,
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.black),
              underline: Container(
                width: MediaQuery.of(context).size.width,
                height: 2,
                color: Colors.grey,
              ),
              onChanged: (String newValue) {
                sortvar = newValue;
                offset = 0;
                productList.removeWhere((val) => true);
                fetchProduct();
              },
              items: brandList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
        preferredSize: Size.fromHeight(40.0),
      );
    } else if (categoryProduct == "mobile") {
      return PreferredSize(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: sortvar,
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.black),
              underline: Container(
                width: MediaQuery.of(context).size.width,
                height: 2,
                color: Colors.grey,
              ),
              onChanged: (String newValue) {
                sortvar = newValue;
                offset = 0;
                productList.removeWhere((val) => true);
                fetchProduct();
              },
              items: brandList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
        preferredSize: Size.fromHeight(40.0),
      );
    } else if (categoryProduct == "scooter") {
      return PreferredSize(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: sortvar,
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.black),
              underline: Container(
                width: MediaQuery.of(context).size.width,
                height: 2,
                color: Colors.grey,
              ),
              onChanged: (String newValue) {
                sortvar = newValue;
                offset = 0;
                productList.removeWhere((val) => true);
                fetchProduct();
              },
              items: brandList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
        preferredSize: Size.fromHeight(40.0),
      );
    }
  }

  Widget getList() {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: ListView.builder(
        itemCount: productList.length + 1,
        itemBuilder: (buildContext, index) {
          if (index == productList.length) {
            return _buildProgressIndicator();
          } else {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ProductDetail(
                          productList[productList.length - index - 1]);
                    },
                  ),
                );
              },
              child: Material(
                  child: Card(
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.all(5),
                  height: MediaQuery.of(context).size.width * 0.36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    children: <Widget>[
                      new ClipRRect(
                          borderRadius: new BorderRadius.circular(10.0),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/loading.gif',
                            image: hostUrl +
                                productList[productList.length - index - 1]
                                    ['images'][0]['image'],
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 0.36,
                            height: MediaQuery.of(context).size.width * 0.36,
                          )),
                      Padding(
                        padding: EdgeInsets.all(4),
                      ),
                      Container(
                        child: Expanded(
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                      child: Text(
                                    "Model : " +
                                        productList[productList.length -
                                            index -
                                            1]['model'],
                                    style: ThemeApp().textBoldTheme(),
                                  )),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Price : " +
                                        productList[productList.length -
                                                index -
                                                1]['price']
                                            .toString() +
                                        " /-",
                                    style: ThemeApp().textTheme(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "Color : " +
                                        productList[productList.length -
                                            index -
                                            1]['color'],
                                    style: ThemeApp().textTheme(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  widget.categoryProduct != "mobile"
                                      ? (widget.categoryProduct == "car"
                                          ? Text(
                                              "Fuel : " +
                                                  productList[
                                                      productList.length -
                                                          index -
                                                          1]['fuel_type'],
                                              style: ThemeApp().textTheme(),
                                            )
                                          : Text(
                                              "Type : " +
                                                  productList[
                                                      productList.length -
                                                          index -
                                                          1]['type'],
                                              style: ThemeApp().textTheme(),
                                            ))
                                      : Container(),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )),
            );
          }
        },
        controller: _scrollController,
      ),
    );
  }

//mymark to get the product deatails
  fetchProduct() async {
    // print(productListApi);
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var response;

      if (token == "") {
        response = await dio.get(productListApi, queryParameters: {
          "category": categoryProduct,
          "city": cityProduct,
          "limit": 10,
          "offset": offset
        });
      } else {
        response = await dio.get(productListApi,
            queryParameters: {
              "category": categoryProduct,
              "city": cityProduct,
              "limit": 10,
              "offset": offset
            },
            options: Options(
              contentType: 'application/json',
              headers: {HttpHeaders.authorizationHeader: "Token " + token},
            ));
      }

      if (response.statusCode == 200) {
        List tempList = new List();

        for (int i = 0; i < response.data['products'].length; i++) {
          if (sortvar == null) {
            tempList.add(response.data['products'][i]);
          } else if (response.data['products'][i]['brand'] == sortvar) {
            tempList.add(response.data['products'][i]);
            // print("Sorted " + response.data['products'][i]['model']);
          } else {
            // print("Its a failure");
          }
        }
        setState(() {
          hasMore = response.data['has_more'];
          isLoading = false;
          offset = offset + 10;
          productList.addAll(tempList);
        });
      } else {
        setState(() {
          isLoading = false;
        });
        // print(isLoading);
      }
    }
  }

  // ignore: non_constant_identifier_names
  create_brand_List() async {
    var response;
    List<String> tempList = new List();
    List<String> tempListB = new List();

    if (token == "") {
      response = await dio.get(productListApi, queryParameters: {
        "category": categoryProduct,
        "city": cityProduct,
        "limit": 10,
        "offset": offset
      });
    } else {
      response = await dio.get(productListApi, queryParameters: {
        "category": categoryProduct,
        "city": cityProduct,
        "limit": 10,
        "offset": offset
      });
    }

    for (int i = 0; i < response.data['products'].length; i++) {
      tempList.add(response.data['products'][i]['brand'].toString());
    }
    if (categoryProduct == "mobile") {
      for (int i = 0; i < brandListAll[_mobile].length; i++) {
        for (int j = 0; j < tempList.length; j++) {
          if (brandListAll[_mobile][i] == tempList[j]) {
            tempListB.add(brandListAll[_mobile][i]);
            break;
          } else {}
        }
      }
    } else if (categoryProduct == "car") {
      for (int i = 0; i < brandListAll[_caR].length; i++) {
        for (int j = 0; j < tempList.length; j++) {
          if (brandListAll[_caR][i] == tempList[j]) {
            tempListB.add(brandListAll[_caR][i]);
            break;
          } else {}
        }
      }
    } else if (categoryProduct == "motorcycle") {
      for (int i = 0; i < brandListAll[_motercycle].length; i++) {
        for (int j = 0; j < tempList.length; j++) {
          if (brandListAll[_motercycle][i] == tempList[j]) {
            tempListB.add(brandListAll[_motercycle][i]);
            break;
          } else {}
        }
      }
    } else if (categoryProduct == "scooter") {
      for (int i = 0; i < brandListAll[_scooter].length; i++) {
        for (int j = 0; j < tempList.length; j++) {
          if (brandListAll[_scooter][i] == tempList[j]) {
            tempListB.add(brandListAll[_scooter][i]);
            break;
          } else {}
        }
      }
    }
    setState(() {
      brandList.addAll(tempListB);
    });
  }
}
