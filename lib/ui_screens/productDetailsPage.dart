import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sec2hand/staticdata.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sec2hand/ui_screens/dealerProfilePage.dart';
import 'package:sec2hand/ui_screens/shared/loading.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';

class ProductDetail extends StatefulWidget {
  final details;
  ProductDetail(this.details);
  @override
  State<StatefulWidget> createState() {
    return _ProductDetail();
  }
}

class _ProductDetail extends State<ProductDetail> {
  var _details;
  String text = 'https://medium.com/@suryadevsingh24032000';
  String subject = 'follow me';

  final List<String> imgList = [];
  Future<void> _launched;
  @override
  void initState() {
    super.initState();
    _details = widget.details;

    for (int i = 0; i < _details['images'].length; i++) {
      print(_details['images'][i]['image']);
      imgList.add(_details['images'][i]['image'].toString());
    }
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final RenderBox box = context.findRenderObject();
          await Share.share(text,
              subject: subject,
              sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
        },
        child: Icon(Icons.share_outlined),
      ),
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              constraints: BoxConstraints(
                minHeight: 150,
              ),
              child: Container(
                  child: CarouselSlider.builder(
                itemCount: imgList.length,
                options: CarouselOptions(
                  aspectRatio: 1.1,
                  enlargeCenterPage: true,
                  autoPlay: true,
                ),
                itemBuilder: (ctx, index) {
                  return _getCarousel(index);
                },
              )),
            ),
            SizedBox(
              height: 5,
            ),
            ListTile(
              title: Text(
                _details['model'],
                style: ThemeApp().textSemiBoldTheme(),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(17, 5, 10, 5),
              width: double.infinity,
              child: Text(
                "Brand : " + _details['brand'].toString(),
                style: ThemeApp().textSemiBoldTheme(),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(17, 5, 10, 5),
              width: double.infinity,
              child: Text(
                _details['price'].toString() + " INR",
                style: ThemeApp().textSemiBoldTheme(),
                textAlign: TextAlign.left,
              ),
            ),
            _details.containsKey("km")
                ? Container(
                    padding: EdgeInsets.fromLTRB(17, 5, 10, 5),
                    width: double.infinity,
                    child: Text(
                        "Kilometers : " + _details['km'].toString() + " km",
                        style: ThemeApp().textSemiBoldTheme(),
                        textAlign: TextAlign.left),
                  )
                : Container(),
            Container(
              padding: EdgeInsets.fromLTRB(17, 5, 10, 5),
              width: double.infinity,
              child: Text("Color : " + _details['color'],
                  style: ThemeApp().textSemiBoldTheme(),
                  textAlign: TextAlign.left),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(17, 5, 10, 5),
              width: double.infinity,
              child: Text("Year : " + _details['year'],
                  style: ThemeApp().textSemiBoldTheme(),
                  textAlign: TextAlign.left),
            ),
            _details.containsKey("fuel_type")
                ? Container(
                    padding: EdgeInsets.fromLTRB(17, 5, 10, 5),
                    width: double.infinity,
                    child: Text("Fuel : " + _details['fuel_type'],
                        style: ThemeApp().textSemiBoldTheme(),
                        textAlign: TextAlign.left),
                  )
                : Container(),
            _details.containsKey("type")
                ? Container(
                    padding: EdgeInsets.fromLTRB(17, 5, 10, 5),
                    width: double.infinity,
                    child: Text("Type : " + _details['type'],
                        style: ThemeApp().textSemiBoldTheme(),
                        textAlign: TextAlign.left),
                  )
                : Container(),
            Divider(
              height: 10,
            ),
            ListTile(
              title: Text(
                "Dealer Info",
                style: ThemeApp().textSemiBoldTheme(),
              ),
            ),
            FutureBuilder(
                future: fetchDealerDetail(_details["user"]),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Text('No Connectivity');
                    case ConnectionState.waiting:
                      return Loading();
                    default:
                      if (snapshot.hasError) {
                        // if error then this message is shown
                        return Center(
                            child: Text(
                          "Something Went Wrong .",
                          style: TextStyle(color: Colors.red),
                        ));
                      } else if (snapshot.data != null) {
                        return Container(
                            padding: EdgeInsets.fromLTRB(17, 0, 17, 25),
                            child: getDealerInfo(snapshot.data));
                      } else
                        return Center(
                            child: Text(
                          "No Data Found for Dealer",
                          style: TextStyle(color: Colors.white),
                        ));
                  }
                }),
            RaisedButton(
              onPressed: () async {
                var geo = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high);
                print(geo);

                var mp;
                var X = geo.latitude;
                var Y = geo.longitude;
                mp = 'http://maps.google.com?q=$X,$Y';

                if (!await canLaunch(mp)) {
                  throw 'Could not launch $mp';
                } else {
                  await launch(mp);
                }
              },
              child: Text("Visit From Map"),
            )
          ],
        ),
      ),
    );
  }

  Widget _getCarousel(index) {
    return Container(
        child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: NetworkImage(hostUrl + imgList[index]))),
      ),
    ));
  }

  Widget getDealerInfo(dealerData) {
    print(dealerData);
    return Container(
      child: Column(
        children: [
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
                              image: dealerData['image'] == null
                                  ? AssetImage('assets/user.png')
                                  : new NetworkImage(dealerData['image'])))),
                  SizedBox(
                    width: 30,
                  ),
                  Container(
                      child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DealerProfilePage(dealerData)));
                    },
                    child: Text(
                      dealerData['shop_name'],
                      style: ThemeApp().heading6Theme(),
                      overflow: TextOverflow.clip,
                    ),
                  )),
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
                ExpansionTile(
                  leading: Icon(Icons.home),
                  title: Text(
                    "Address",
                    style: ThemeApp().textBoldTheme(),
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        dealerData['address'],
                        style: ThemeApp().textBoldTheme(),
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  leading: Icon(Icons.call),
                  title: Text(
                    "Contact",
                    style: ThemeApp().textBoldTheme(),
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        dealerData['phone'],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                  onTap: () {
                    setState(() {
                      _launched = _makePhoneCall('tel:${dealerData['phone']}');
                    });
                  },
                  child: Card(
                    elevation: 2,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: Text("Call",
                          textAlign: TextAlign.center,
                          style: ThemeApp().textBoldTheme()),
                    ),
                  )),
              InkWell(
                  onTap: () {
                    setState(() {
                      _launched = _makePhoneCall('sms:${dealerData['phone']}');
                    });
                  },
                  child: Card(
                    elevation: 2,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: Text(
                        "SMS",
                        textAlign: TextAlign.center,
                        style: ThemeApp().textBoldTheme(),
                      ),
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }

  fetchDealerDetail(username) async {
    Dio dio = Dio();
    var response = await dio.get(profileApi,
        queryParameters: {"username": username},
        options: Options(
          contentType: 'application/json',
        ));
    var dealerData = response.data;
    return dealerData;
  }
}
