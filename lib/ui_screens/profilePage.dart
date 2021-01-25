import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sec2hand/ui_screens/profileEditPage.dart';

import 'package:sec2hand/ui_screens/splash_screen.dart';
import '../staticdata.dart';
import '../theme.dart';
import 'addPostPage.dart';
import 'addProductPage.dart';
import 'menu.dart';
import 'productDetailsPage.dart';
import 'reviewPage.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfilePage();
  }
}

class _ProfilePage extends State<ProfilePage> {
  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    print(profileData);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Sec2Hand",
                style: ThemeApp().appBarTheme(),
              ),
              InkWell(
                  onTap: () async {
                    await storage.delete(key: "token");
                    token = "";
                    profileData = {};
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Menu(2)));
                  },
                  child: Icon(
                    Icons.power_settings_new,
                    color: Colors.blue,
                  ))
            ],
          )),
      body: Container(
          child: SingleChildScrollView(
              child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.99,
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                      width: 100.0,
                      height: 100.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: profileData['image'] == null
                                  ? AssetImage('assets/user.png')
                                  : new NetworkImage(profileData['image'])))),
                  SizedBox(
                    width: 30,
                  ),
                  Container(
                    child: Text(
                      profileData['is_dealer']
                          ? profileData['shop_name']
                          : profileData['user'],
                      style: ThemeApp().heading6Theme(),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            child: Column(
              children: <Widget>[
                Visibility(
                    visible: profileData['is_dealer'],
                    child: ExpansionTile(
                      leading: Icon(Icons.home),
                      title: Text(
                        "Address",
                        style: ThemeApp().textBoldTheme(),
                      ),
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            profileData['address'] ?? "",
                            style: ThemeApp().textBoldTheme(),
                          ),
                        ),
                        ListTile(
                          title: Text(
                              "City : " + profileData['city'].toString() ?? "",
                              style: ThemeApp().textBoldTheme()),
//                              trailing: InkWell(
//                                onTap: () {
////                                    _updateSearch(context, "pinCode",
////                                        snapshot.data['pinCode']);
//                                },
//                                child: Icon(
//                                  Icons.edit,
//                                  size: 20,
//                                  color: Colors.blue,
//                                ),
//                              ),
                        ),
                        ListTile(
                          title: Text(
                            profileData['is_dealer']
                                ? "Area : " + profileData['area']
                                : "",
                            style: ThemeApp().textBoldTheme(),
                          ),
                        ),
                      ],
                    )),
                ExpansionTile(
                  leading: Icon(Icons.call),
                  title: Text(
                    "Contact",
                    style: ThemeApp().textBoldTheme(),
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        profileData['phone'],
                        style: ThemeApp().textBoldTheme(),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Visibility(
              visible: profileData['is_dealer'],
              child: Container(
                padding: EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      child: Text(
                        'EDIT',
                        style: ThemeApp().textBoldLinkTheme(),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileEdit()));
                      },
                    )
                  ],
                ),
              )),
          SizedBox(
            height: 10,
          ),
          Visibility(
              visible: profileData['is_dealer'],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  InkWell(
                      onTap: () {
                        if (_selectedPage != 0) {
                          setState(() {
                            _selectedPage = 0;
                          });
                        }
                      },
                      child: Card(
                        elevation: _selectedPage == 0 ? 0 : 2,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Text("Products",
                              textAlign: TextAlign.center,
                              style: ThemeApp().textBoldTheme()),
                        ),
                      )),
                  InkWell(
                      onTap: () {
                        if (_selectedPage != 1) {
                          setState(() {
                            _selectedPage = 1;
                          });
                        }
                      },
                      child: Card(
                        elevation: _selectedPage == 0 ? 2 : 0,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Text(
                            "Posts",
                            textAlign: TextAlign.center,
                            style: ThemeApp().textBoldTheme(),
                          ),
                        ),
                      ))
                ],
              )),
          SizedBox(
            height: 10,
          ),
          Visibility(
              visible: profileData['is_dealer'],
              child: _selectedPage == 0
                  ? InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddProductPage()));
                      },
                      child: Text(
                        "Add new Product",
                        style: ThemeApp().textBoldLinkTheme(),
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddPostPage()));
                      },
                      child: Text(
                        "Add new Post",
                        style: ThemeApp().textBoldLinkTheme(),
                      ),
                    )),
          SizedBox(
            height: 10,
          ),
          Visibility(
            visible: profileData['is_dealer'],
            child: _selectedPage == 0
                ? ProfileProductView(profileData['products'])
                : ProfilePostView(profileData['posts']),
          )
        ],
      ))),
    );
  }
}

class ProfileProductView extends StatefulWidget {
  final dealerData;
  ProfileProductView(this.dealerData);
  @override
  State<StatefulWidget> createState() {
    return _ProfileProductView();
  }
}

class _ProfileProductView extends State<ProfileProductView> {
  @override
  Widget build(BuildContext context) {
    return widget.dealerData.length != 0
        ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.dealerData.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ProductDetail(widget
                            .dealerData[widget.dealerData.length - index - 1]);
                      },
                    ),
                  );
                },
                child: Material(

                    // borderRadius: BorderRadius.circular(2),
                    child: Card(
                  elevation: 0,
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
                                  widget.dealerData[widget.dealerData.length -
                                      index -
                                      1]['images'][0]['image'],
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width * 0.36,
                              height: MediaQuery.of(context).size.width * 0.36,
                            )
                            // CachedNetworkImage(
                            //   imageUrl: baseUrl
                            //       + widget.dealerData[widget.dealerData.length -
                            //           index -
                            //           1]['images'][0]['image']
                            //   , fit: BoxFit.cover,
                            //   width: MediaQuery.of(context).size.width * 0.36,
                            //   height: MediaQuery.of(context).size.width * 0.36,
                            //   progressIndicatorBuilder: (context, url, downloadProgress) =>
                            //       Loading(),
                            //   errorWidget: (context, url, error) => Icon(Icons.error),
                            // ),

                            ),
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
                                          widget.dealerData[
                                              widget.dealerData.length -
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
                                          widget.dealerData[
                                                  widget.dealerData.length -
                                                      index -
                                                      1]['price']
                                              .toString() +
                                          " /-",
                                      style: ThemeApp().textTheme(),
                                    ),
                                  ],
                                ),
                                Visibility(
                                    visible: profileData['category'] == "mobile"
                                        ? false
                                        : true,
                                    child: SizedBox(
                                      height: 5,
                                    )),
                                Visibility(
                                    visible: profileData['category'] == "mobile"
                                        ? false
                                        : true,
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                            "Km : " +
                                                widget.dealerData[widget
                                                            .dealerData.length -
                                                        index -
                                                        1]['km']
                                                    .toString(),
                                            style: ThemeApp().textTheme()),
                                      ],
                                    )),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Color : " +
                                          widget.dealerData[
                                              widget.dealerData.length -
                                                  index -
                                                  1]['color'],
                                      style: ThemeApp().textTheme(),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    profileData['category'] != "mobile"
                                        ? (profileData['category'] == "car"
                                            ? Text(
                                                "Fuel Type : " +
                                                    widget.dealerData[widget
                                                            .dealerData.length -
                                                        index -
                                                        1]['fuel_type'],
                                                style: ThemeApp().textTheme(),
                                              )
                                            : Text(
                                                "Type : " +
                                                    widget.dealerData[widget
                                                            .dealerData.length -
                                                        index -
                                                        1]['type'],
                                                style: ThemeApp().textTheme(),
                                              ))
                                        : Container(),
                                    InkWell(
                                      onTap: () {
                                        popUpConfirm(widget.dealerData[
                                                widget.dealerData.length -
                                                    index -
                                                    1]['slug']
                                            .toString());
                                      },
                                      child: Icon(
                                        Icons.more_vert,
                                        color: Colors.grey,
                                      ),
                                    ),
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
            })
        : Container();
  }

  popUpConfirm(slug) {
    return showDialog(
        context: context,
        child: AlertDialog(
          content: InkWell(
            onTap: () async {
              Dio dio = Dio();
              var response = await dio.delete(productDetailApi + slug,
                  options: Options(
                    contentType: 'application/json',
                    headers: {
                      HttpHeaders.authorizationHeader: "Token " + token
                    },
                  ));

              var profileResponse = await dio.get(profileApi,
                  options: Options(
                    contentType: 'application/json',
                    headers: {
                      HttpHeaders.authorizationHeader: "Token " + token
                    },
                  ));
              profileData = profileResponse.data;
              Navigator.of(context, rootNavigator: true).pop(
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Menu(2))));
            },
            child: Text(
              "Delete",
              style: ThemeApp().textTheme(),
              textAlign: TextAlign.center,
            ),
          ),
        ));
  }
}

class ProfilePostView extends StatefulWidget {
  final dealerData;
  ProfilePostView(this.dealerData);
  @override
  State<StatefulWidget> createState() {
    return _ProfilePostView();
  }
}

class _ProfilePostView extends State<ProfilePostView> {
  @override
  Widget build(BuildContext context) {
    return widget.dealerData.length != 0
        ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.dealerData.length,
            itemBuilder: (buildContext, index) {
              return Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      leading: new Container(
                          width: 40,
                          height: 40,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: profileData['image'] == null
                                      ? new AssetImage(
                                          "assets/user.png",
                                        )
                                      : new NetworkImage(
                                          profileData['image'],
                                        )))),
                      title: Text(
                        widget.dealerData[widget.dealerData.length - index - 1]
                            ['user'],
                        style: ThemeApp().textSemiBoldTheme(),
                      ),
                      trailing: InkWell(
                        onTap: () async {
                          popUpConfirm(widget
                              .dealerData[widget.dealerData.length - index - 1]
                                  ['id']
                              .toString());
                        },
                        child: Icon(Icons.more_vert),
                      ),
                    ),
                    Container(
                        constraints: BoxConstraints(
                          minHeight: 150,
                        ),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/loading.gif',
                          image: widget.dealerData[
                              widget.dealerData.length - index - 1]['image'],
                        )
                        // CachedNetworkImage(
                        //   imageUrl: widget.dealerData[
                        //   widget.dealerData.length - index - 1]['image'],
                        //   progressIndicatorBuilder: (context, url, downloadProgress) =>
                        //       Loading(),
                        //   errorWidget: (context, url, error) => Icon(Icons.error),
                        // ),
                        // Image.network(
                        //     widget.dealerData[
                        //         widget.dealerData.length - index - 1]['image']),
                        ),
                    SizedBox(
                      height: 15,
                    ),
                    LikeData(widget
                        .dealerData[widget.dealerData.length - index - 1]),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              );
            })
        : Container();
  }

  popUpConfirm(id) {
    return showDialog(
        context: context,
        child: AlertDialog(
          content: InkWell(
            onTap: () async {
              Dio dio = Dio();
              var response = await dio.delete(postDetailApi + id,
                  options: Options(
                    contentType: 'application/json',
                    headers: {
                      HttpHeaders.authorizationHeader: "Token " + token
                    },
                  ));

              var profileResponse = await dio.get(profileApi,
                  options: Options(
                    contentType: 'application/json',
                    headers: {
                      HttpHeaders.authorizationHeader: "Token " + token
                    },
                  ));
              profileData = profileResponse.data;

              Navigator.of(context, rootNavigator: true).pop(
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Menu(2))));
            },
            child: Text(
              "Delete",
              style: ThemeApp().textTheme(),
              textAlign: TextAlign.center,
            ),
          ),
        ));
  }
}
