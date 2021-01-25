
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sec2hand/ui_screens/reviewPage.dart';
import '../staticdata.dart';
import '../theme.dart';
import 'productDetailsPage.dart';
import 'shared/loading.dart';




class DealerProfilePage extends StatefulWidget {
  final dealerData;
  DealerProfilePage(this.dealerData);
  @override
  State<StatefulWidget> createState() {
    return _DealerProfilePage();
  }
}

class _DealerProfilePage extends State<DealerProfilePage> {
  int _selectedPage = 0;
  var dealerData;
  @override
  void initState() {
    dealerData = widget.dealerData;
    fetchDealerDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: InkWell(
              onTap: (){Navigator.of(context).pop();},
              child:Icon(Icons.arrow_back_ios, color: Colors.black,)),
          title:  Text(
            "Sec2Hand",
            style: ThemeApp().appBarTheme(),
          ),),
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
                                      image: dealerData['image']==null ?AssetImage('assets/user.png'): new NetworkImage(dealerData['image'])))),

                         SizedBox(width: 30,),
                          Container(
                            child:
                                Text(dealerData['shop_name'], style: ThemeApp().heading6Theme(), overflow: TextOverflow.clip,),

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
                  ),
                  FutureBuilder(
                      future: fetchDealerDetail(),
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

                              var dealerDetails = snapshot.data;
                              print(dealerDetails['posts']);
                              return

                                  _selectedPage==0?DealerProfileProductView(dealerDetails['products'],dealerData['category']):DealerProfilePostView(dealerDetails['posts'], dealerData['image']);

                            } else
                              return Center(
                                  child: Text(
                                    "No Data Found",
                                    style: TextStyle(color: Colors.white),
                                  ));
                        }
                      })

                ],
              ))),
    );
  }

   fetchDealerDetail() async{
    Dio dio  = Dio();
    var response = await dio.get(profileApi, queryParameters: {"username": dealerData['user']});
   // var response = await dio.get(dealerDetailApi+widget.dealerData['id'].toString());
    print(response.statusCode);
    print("hss");
    if(response.statusCode==200||response.statusCode==201){
      return response.data;
    }
    else return null;
  }
}

class DealerProfileProductView extends StatefulWidget{
  final dealerData;
  final category;
  DealerProfileProductView(this.dealerData, this.category);
  @override
  State<StatefulWidget> createState() {
    return _DealerProfileProductView();
  }

}


class _DealerProfileProductView extends State<DealerProfileProductView>{
  @override
  Widget build(BuildContext context) {

    return widget.dealerData.length!=0? ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.dealerData.length,
        itemBuilder: (BuildContext context, int index){
          print(widget.dealerData[widget.dealerData.length - index - 1]);
          return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ProductDetail(widget.dealerData[widget.dealerData.length - index - 1]);
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
                    child:
                    Row(
                      children: <Widget>[
                        new ClipRRect(
                          borderRadius: new BorderRadius.circular(10.0),
                          child:
                          FadeInImage.assetNetwork(
                            placeholder: 'assets/loading.gif',
                            image: baseUrl
                                + widget.dealerData[widget.dealerData.length -
                                    index -
                                    1]['images'][0]['image']
                            , fit: BoxFit.cover,
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

                          child:  Expanded(
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 5,),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(child:
                                    Text(
                                      "Model : "+widget.dealerData[widget.dealerData.length-index-1]['model'],
                                      style: ThemeApp().textBoldTheme(),
                                    )
                                    )
                                    ,
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Price : "+widget.dealerData[widget.dealerData.length-index-1]['price'].toString()+" /-",
                                      style: ThemeApp().textTheme(),
                                    ),

                                  ],
                                ),
                            Visibility(
                              visible: widget.category=="mobile" ? false : true,
                              child:
                                SizedBox(height: 5,)),
                            Visibility(
                              visible: widget.category=="mobile" ? false : true,
                              child:
                                Row(
                                  children: <Widget>[
                                    Text(
                                        "Km : "+widget.dealerData[widget.dealerData.length-index-1]['km'].toString(),
                                        style: ThemeApp().textTheme()
                                    ),
                                  ],
                                )),
                                SizedBox(height: 5,),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Color : "+widget.dealerData[widget.dealerData.length-index-1]['color'],
                                      style: ThemeApp().textTheme(),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Row(
                                  children: [
                                    widget.dealerData[widget.dealerData.length-index-1]['category']!="mobile"?(widget.dealerData[widget.dealerData.length-index-1]['category']!="car"?Text(
                                      "Fuel Type : " +
                                          widget.dealerData[
                                          widget.dealerData.length -
                                              index -
                                              1]['fuel_type'],
                                      style: ThemeApp().textTheme(),
                                    ):Text(
                                      "Type : " +
                                          widget.dealerData[
                                          widget.dealerData.length -
                                              index -
                                              1]['type'],
                                      style: ThemeApp().textTheme(),
                                    )):Container(),
                                ],)
                              ],
                            ),
                          ),)

                      ],
                    ),
                  ),
                )),);
        }):Container();
  }


}

class DealerProfilePostView extends StatefulWidget {
  final dealerData;
  final dealerImage;
  DealerProfilePostView(this.dealerData, this.dealerImage);
  @override
  State<StatefulWidget> createState() {
    return _DealerProfilePostView();
  }
}

class _DealerProfilePostView extends State<DealerProfilePostView> {
  @override
  Widget build(BuildContext context) {
    return widget.dealerData.length!=0? ListView.builder(
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
                              image: widget.dealerImage==null
                                  ? new AssetImage(
                                "assets/user.png",
                              )
                                  : new NetworkImage(
                                baseUrl+widget.dealerImage,
                              )))),
                  title: Text(
                    widget.dealerData[widget.dealerData.length-index-1]['user'],
                    style: ThemeApp().textSemiBoldTheme(),
                  ),
                ),
          Container(
          constraints: BoxConstraints(
          minHeight: 150,),
          child:
          FadeInImage.assetNetwork(
          placeholder: 'assets/loading.gif',
          image: hostUrl+widget.dealerData[
         widget.dealerData.length - index - 1]['image'],
          ),
          // CachedNetworkImage(
          //   imageUrl: widget.dealerData[
          //   widget.dealerData.length - index - 1]['image'],
          //   progressIndicatorBuilder: (context, url, downloadProgress) =>
          //       Loading(),
          //   errorWidget: (context, url, error) => Icon(Icons.error),
          // ),

              // Image.network(widget.dealerData[widget.dealerData.length-index-1]['image']),
          ),
          SizedBox(
                  height: 15,
                ),
               LikeData(widget.dealerData[widget.dealerData.length-index-1]),
                SizedBox(height: 10,)
              ],
            ),
          );
        }):Container();
  }
}
