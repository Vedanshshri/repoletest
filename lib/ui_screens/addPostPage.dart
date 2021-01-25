
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:image_picker/image_picker.dart';

import '../staticdata.dart';
import '../theme.dart';
import 'menu.dart';



class AddPostPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _AddPostPage();
  }

}


class _AddPostPage extends State<AddPostPage>{
  File _image;
  var _formKey = GlobalKey<FormState>();
  TextEditingController _desc = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final picker = ImagePicker();
  var image;
  String postStatus = "Post";
  _pickImageFromGallery() async {
    try {
      image = await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

      setState(() {
        _image = File(image.path);
      });
    }catch(e){
      print(e.toString());
    }
  }

  Dio dio = new Dio();
  @override
  Widget build(BuildContext context) {
    final maxLines = 5;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
            onTap: (){Navigator.of(context).pop();},
            child:Icon(Icons.arrow_back_ios, color: Colors.black,)),
        title:  Text(
          "Sec2Hand",
          style: ThemeApp().appBarTheme(),
        ),),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _getImage(),
            Text("Add Image", style: ThemeApp().textTheme(),),
          Form(
              key: _formKey,
              child:  Container(
                margin: EdgeInsets.all(12),
                height: maxLines * 30.0,
//            color: Colors.white30,
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                  maxLength: 139,
                  maxLines: maxLines,
                  controller: _desc,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: "Write Something About it...",
                    fillColor: Colors.grey[300],
                    filled: true,
                  ),
                ))),
            Container(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
              child: RaisedButton(
                onPressed: () {
                  if(postStatus=="Post") {

                    setState(() {
                      postStatus = "Uploading...";
                    });

                    if (!_formKey.currentState.validate()) {
                      return;
                    }
                    if (_image == null) {
                      final snackBar = SnackBar(
                        content: Text('Please Add a Picture'),
                      );
                      scaffoldKey.currentState.showSnackBar(snackBar);
                      return;
                    }
                    postPic();
                  }
                },
                color: Color(0xff005ad2),
                child: Text(
                  postStatus,
                  style: ThemeApp().buttonTextTheme(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getImage() {
    return Container(
        margin: EdgeInsets.all(12),
        child: Column(children: <Widget>[
          _image != null
              ? InkWell(
              onTap: () {
                _pickImageFromGallery();
              },
              child: Container(
                  width: 200.0,
                  height: 200.0,
                  child: new Image.file(
                    _image,
                    width: 200,
                    height: 200,
                  )))
              : InkWell(
              onTap: () {
                _pickImageFromGallery();
              },
              child: Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new AssetImage("assets/logo.png"))))),
        ]));
  }

  void postPic() async {
    Response response;
    try {
      FormData formData = FormData.fromMap({
        "description": _desc.text,
        "image": await MultipartFile.fromFile(image.path, filename: image.path)
      });
      response = await dio.post(postAddApi, data: formData, options: Options(
        contentType: 'application/json',
        headers: {HttpHeaders.authorizationHeader: "Token " + token},
      ));

      if (response.statusCode == 200 || response.statusCode == 201) {

        var profileResponse = await dio.get(profileApi, options: Options(
          contentType: 'application/json',
          headers: {HttpHeaders.authorizationHeader: "Token " + token},
        ));
        profileData = profileResponse.data;

        final snackBar = SnackBar(
          content: Text('Post Uploaded Successfully'),
        );
        scaffoldKey.currentState.showSnackBar(snackBar);


        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Menu(1)));
      }
      else {
        final snackBar = SnackBar(
          content: Text('Something went wrong...'),
        );
        scaffoldKey.currentState.showSnackBar(snackBar);
      }
    } catch(e){
      setState(() {
        postStatus = "Post";
      });

      final snackBar = SnackBar(
        content: Text('Something went wrong...'),
      );
      scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

}