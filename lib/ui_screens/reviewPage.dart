import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sec2hand/staticdata.dart';
import 'package:sec2hand/ui_screens/commentPage.dart';
import 'package:sec2hand/ui_screens/menu.dart';
import 'package:sec2hand/ui_screens/shared/loading.dart';
import '../theme.dart';




class ReviewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ReviewPage();
  }
}

class _ReviewPage extends State<ReviewPage> {
  Dio dio = Dio();
  ScrollController _scrollController = new ScrollController();

  bool isLoading = false;
   int offset = 0;
  List postList = new List();
  var hasMore = true;
  @override
  void initState() {

      this.fetchPosts();

    super.initState();
    _scrollController.addListener(() {
      if ((_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) && hasMore) {
        fetchPosts();
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
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[ Text(
            "Sec2Hand",
            style: ThemeApp().appBarTheme(),
          ),
          InkWell(
            onTap: (){

                postList = [];
                offset = 1;
                hasMore=true;
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Menu(1)));
            },
            child: Icon(Icons.refresh, color: Colors.blue,size: 30,),
          )
          ])
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

  Widget getList() {
    return  ListView.builder(
          itemCount: postList.length+1,
          itemBuilder: (buildContext, index) {
            if(index==postList.length){
           return _buildProgressIndicator();
            }
            else{
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
                                image: postList[index]['userprofile']['image']==null
                                    ? new AssetImage(
                                        "assets/user.png",
                                      )
                                    : new NetworkImage(
                                 baseUrl+ postList[index]['userprofile']['image'],
                                      )))),
                    title: Text(
                      postList[index]['user'],
                      style: ThemeApp().textSemiBoldTheme(),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                        minHeight: 150,),
                    child:
                    FadeInImage.assetNetwork(
                      placeholder: 'assets/loading.gif',
                      image: postList[index]['image'],
                    )
                    // CachedNetworkImage(s
                    //   imageUrl: postList[index]['image'],
                    //   progressIndicatorBuilder: (context, url, downloadProgress) =>
                    //       Loading(),
                    //   errorWidget: (context, url, error) => Icon(Icons.error),
                    // ),
                  //Image.network(postList[index]['image']),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  LikeData(postList[index])
                ],
              ),
            );}
          },
        controller: _scrollController,
          );


  }

  fetchPosts() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var response;
      if (token == "") {
        response =
        await dio.get(postListApi, queryParameters: {"limit": 10, "offset": offset});
      }
      else {
        response = await dio.get(
            postListApi, queryParameters: {"limit": 10, "offset": offset},
            options: Options(
              contentType: 'application/json',
              headers: {HttpHeaders.authorizationHeader: "Token " + token},
            ));
      }
      if (response.statusCode == 200) {
        print("ghhjjj");
        print(response.data);
        List tempList = new List();
        for (int i = 0; i < response.data['posts'].length; i++) {
          tempList.add(response.data['posts'][i]);
        }
        setState(() {
          hasMore = response.data['has_more'];
          isLoading = false;
          offset= offset+10;
          postList.addAll(tempList);
          print(postList);
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


class LikeData extends StatefulWidget{
  final data;
  LikeData(this.data);
  @override
  State<StatefulWidget> createState() {
    return _LikeData();
  }

}


class _LikeData extends State<LikeData>{
  var likeCount;
  var likeStatus;
  var maxLinesCount =2;
  Dio dio = Dio();
  @override
  void initState() {
    likeCount = widget.data['likes_count'];
    likeStatus = widget.data['is_like'];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            InkWell(
                onTap: ()async{
                  if(token==""){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Menu(2)));
                  }
                  else {
                    if (likeStatus == false) {
                      setState(() {
                        likeCount += 1;
                        likeStatus = true;
                      });
                       var response= await dio.post(likeApi, data: {
                          "action": "like",
                          "post_id": widget.data['id']
                        }, options: Options(
                          contentType: 'application/json',
                          headers: {HttpHeaders.authorizationHeader: "Token " +
                              token},
                        ));
                        print(response.statusCode);
                      }
                      else {
                      setState(() {
                        likeCount -= 1;
                        likeStatus = false;
                      });

                       await dio.post(likeApi, data: {
                          "action": "unlike",
                          "post_id": widget.data['id']
                        }, options: Options(
                          contentType: 'application/json',
                          headers: {HttpHeaders.authorizationHeader: "Token " +
                              token},
                        ));
                      }

                    if(widget.data['user']==profileData['user']){
                      var profileResponse = await dio.get(profileApi, options: Options(
                        contentType: 'application/json',
                        headers: {HttpHeaders.authorizationHeader: "Token " + token},
                      ));
                      profileData = profileResponse.data;
                    }
                  }
                },
                child:
            likeStatus==false
                ?  Image.asset(
              "assets/heart.png",
              height: 30,
            )
                : Image.asset(
              "assets/heartFill.png",
              height: 30,
            )
            ),
            SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CommentPage( widget.data['id'])));},
              child:
            Image.asset("assets/review.png", height: 30),)
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Text(
              likeCount.toString() +
                  (likeCount < 2
                      ? " like"
                      : " likes")+" , "+ widget.data['comments_counts'].toString()+(widget.data['comments_counts'] < 2
                  ? " comment"
                  : " comments"),
              style: TextStyle(fontWeight: FontWeight.w600),
            )),
        SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: (){
            setState(() {
              if(maxLinesCount==2){
                maxLinesCount=1000;
              }
              else{
                maxLinesCount=2;
              }
            });
          },
            child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: maxLinesCount,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: widget.data['user'] + "  ",
                          style: ThemeApp().textSemiBoldTheme()),
                      TextSpan(
                          text: widget.data['description'],
                          style: ThemeApp().textTheme()),
                    ],
                  ),
                )))
      ],
    );
  }



}

