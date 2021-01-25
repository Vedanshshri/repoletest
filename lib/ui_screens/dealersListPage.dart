import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sec2hand/staticdata.dart';
import 'package:sec2hand/theme.dart';
import 'package:sec2hand/ui_screens/shared/loading.dart';

import 'dealerProfilePage.dart';

class DealersListPage extends StatefulWidget {
  final categoryDealer;
  final cityDealer;
  final areaDealer;
  DealersListPage(this.categoryDealer, this.cityDealer, this.areaDealer);
  @override
  State<StatefulWidget> createState() {
    return _DealersListPage();
  }
}

class _DealersListPage extends State<DealersListPage> {
  Dio dio = new Dio();
  var categoryDealer;
  var cityDealer;
  var areaDealer;
  ScrollController _scrollController = new ScrollController();

  bool isLoading = false;
  int offset = 0;
  List dealerList = new List();
  var hasMore = true;
  @override
  void initState() {
    categoryDealer = widget.categoryDealer;
    cityDealer = widget.cityDealer;
    areaDealer = widget.areaDealer;
    this.fetchDealer();

    super.initState();
    _scrollController.addListener(() {
      if ((_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) &&
          hasMore) {
        fetchDealer();
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
        title: Text(
          "Sec2Hand",
          style: ThemeApp().appBarTheme(),
        ),
      ),
      body: getList(),
      resizeToAvoidBottomPadding: false,

//        FutureBuilder(
//            future: fetchDealer(),
//            builder: (BuildContext context, AsyncSnapshot snapshot) {
//              switch (snapshot.connectionState) {
//                case ConnectionState.none:
//                  return Text('No Connectivity');
//                case ConnectionState.waiting:
//                  return Loading();
//                default:
//                  if (snapshot.hasError) {
//                    // if error then this message is shown
//                    return Center(
//                        child: Text(
//                      "Something Went Wrong .",
//                      style: TextStyle(color: Colors.red),
//                    ));
//                  } else if (snapshot.data.length != 0) {
//                    var dealerList = snapshot.data;
//                    return getList(dealerList);
//                  } else
//                    return Center(
//                        child: Text(
//                      "No Dealer Found",
//                      style: ThemeApp().textSemiBoldTheme(),
//                    ));
//              }
//            })
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

  Widget getList() {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: ListView.builder(
        itemCount: dealerList.length + 1,
        itemBuilder: (buildContext, index) {
          if (index == dealerList.length) {
            return _buildProgressIndicator();
          } else {
            return Card(
              child: ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          DealerProfilePage(dealerList[index])));
                },
                contentPadding: EdgeInsets.all(10),
                leading: new Container(
                    width: 60,
                    height: 60,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: dealerList[index]['image'] == null
                                ? new AssetImage(
                                    "assets/user.png",
                                  )
                                : new NetworkImage(
                                    baseUrl + dealerList[index]['image'],
                                  )))),
                title: Text(
                  dealerList[index]['shop_name'],
                  style: ThemeApp().textSemiBoldTheme(),
                ),
                subtitle: Text(
                  dealerList[index]['city'],
                  style: ThemeApp().textTheme(),
                ),
              ),
            );
          }
        },
        controller: _scrollController,
      ),
    );
  }

  fetchDealer() async {
    print(dealerListApi);
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var response;
      FormData formData = FormData.fromMap({
        "category": categoryDealer,
        "city": cityDealer,
        "area": areaDealer,
        "limit": 10,
        "offset": offset
      });
      if (token == "") {
        response = await dio.post(dealerListApi, data: formData);
      } else {
        response = await dio.post(dealerListApi,
            data: formData,
            options: Options(
              contentType: 'application/json',
              headers: {HttpHeaders.authorizationHeader: "Token " + token},
            ));
      }
      print("here");
      if (response.statusCode == 200) {
        print("ghhjjj");
        print(response.data);
        List tempList = new List();
        for (int i = 0; i < response.data['dealers'].length; i++) {
          tempList.add(response.data['dealers'][i]);
        }
        setState(() {
          hasMore = response.data['has_more'];
          isLoading = false;
          offset = offset + 10;
          dealerList.addAll(tempList);
          print(dealerList);
        });
      } else {
        print(response.statusCode);
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
