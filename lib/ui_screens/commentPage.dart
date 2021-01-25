import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sec2hand/staticdata.dart';

import '../theme.dart';
import 'shared/loading.dart';

class CommentPage extends StatefulWidget {
  final postId;
  CommentPage(this.postId);
  @override
  State<StatefulWidget> createState() {
    return _CommentPage();
  }
}

class _CommentPage extends State<CommentPage> {

  var _formKey = GlobalKey<FormState>();
  TextEditingController _comment = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  bool isLoading = false;
  int offset = 0;
  List commentList = new List();
  var hasMore = true;
  @override
  void initState() {
    this.fetchComments();
    super.initState();
  }

  Dio dio = new Dio();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          title: Text(
            "Comments",
            style: ThemeApp().appBarTheme(),
          ),
        ),
        body:
              ListView(

                  children: <Widget>[

          Container(
              height: MediaQuery.of(context).size.height*0.75,
              child:
                  SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child:
       _commentList()

                  )),

                  Visibility(
                      visible: hasMore,
                      child: InkWell(
                        onTap: (){
                          fetchComments();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text("Load more", style: ThemeApp().textBoldLinkTheme(),)
                          ],
                        ),
                      )),
                    Container (
                        child: Card(
                        elevation: 10,
                        child:Form(
                            key: _formKey,
                            child: ListTile(
                          title: TextFormField(
                            controller: _comment,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(borderSide: BorderSide.none),
                                focusedBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                                hintText: "comment..."),

                          ),
                          trailing: InkWell(
                              onTap: ()async{
                                var commentData = _comment.text;
                               if(_comment.text!="") {
                                 setState(() {
                                   _comment.text = "";
                                 });
                              var response =  await dio.post(commentApi, data: {
                                   "comment":commentData,
                                   "post":widget.postId
                                 },
                                 options: Options(
                                   contentType: 'application/json',
                                   headers: {HttpHeaders.authorizationHeader: "Token " + token},
                                 ));
                              if(response.statusCode==200 || response.statusCode==201){
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context) =>CommentPage(widget.postId)));
                              }
                               }
                              },
                              child:Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                          )),
                        )),
                      )),

          ]
        )
    );
  }

  fetchComments() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var response;
      if (token == "") {
        response =
        await dio.post(commentListApi, data: {"post_id":widget.postId,"limit": 16, "offset": offset});
      }
      else {
        response = await dio.post(
            commentListApi, data : {"post_id":widget.postId,"limit": 16, "offset": offset},
            options: Options(
              contentType: 'application/json',
              headers: {HttpHeaders.authorizationHeader: "Token " + token},
            ));
      }
      if (response.statusCode == 200) {
        print("ghhjjj");
        print(response.data);
        List tempList = new List();
        for (int i = 0; i < response.data['comments'].length; i++) {
          tempList.add(response.data['comments'][i]);
        }
        setState(() {
          hasMore = response.data['has_more'];
          isLoading = false;
          offset= offset+16;
          commentList.addAll(tempList);
          print(commentList);
        });
      } else {
        print(response.statusCode);
        setState(() {
          isLoading = false;
        });
      }


    }
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

  _commentList() {
    return
      ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: commentList.length+1,
        itemBuilder: (BuildContext context, index) {

          if(index==commentList.length){
            return _buildProgressIndicator();
          }
          else{
          return
            Container(

              child:Column(
                children: <Widget>[
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: commentList[index]['user'] + "  ",
                                style: ThemeApp().textSemiBoldTheme()),
                            TextSpan(
                                text: commentList[index]['comment'],
                                style: ThemeApp().textTheme()),
                          ],
                        ),
                      )),
                  Divider(
                    height: 2,
                  )
                ],
              ));}
        });
  }
}
