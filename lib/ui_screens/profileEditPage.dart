import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../staticdata.dart';
import '../theme.dart';
import 'menu.dart';


class ProfileEdit extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ProfileEdit();
  }

}

class _ProfileEdit extends State<ProfileEdit>{
  File _image;
  var _categoryOption = ["car", "mobile", "bike"];
  var _formKey = GlobalKey<FormState>();
  String editStatus = "Edit";
  TextEditingController _address =
  TextEditingController(text: profileData['address']);
  TextEditingController _area =
  TextEditingController(text: profileData['area']);
  TextEditingController _city =
  TextEditingController(text: profileData['city']);
  String _category = profileData['category'];
  TextEditingController _mobile =
  TextEditingController(text: profileData['phone']);
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final picker = ImagePicker();
  var image;
  _pickImageFromGallery() async {
    image =
    await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image.path);
    });
  }
  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(child: Form(
          key: _formKey,
          child:Column(
        children: [
          SizedBox(
            height: 10,
          ),
          _getImage(),
          Text("Add Image"),
          SizedBox(
            height: 10,
          ),
          Visibility(
            visible: profileData['is_dealer'],
            child:
          Divider(
            height: 2,
          )),
          Visibility(
            visible: profileData['is_dealer'],
            child:
          ListTile(
            title: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              controller: _address,
              decoration: InputDecoration(
                  border:
                  OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                  OutlineInputBorder(borderSide: BorderSide.none),
                  labelText: "Address"),
            ),
            trailing: Icon(
              Icons.location_on,
              color: Colors.grey,
            ),
          ),),
          Divider(
            height: 2,
          ),
          ListTile(
            title: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              controller: _mobile,
              decoration: InputDecoration(
                  border:
                  OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                  OutlineInputBorder(borderSide: BorderSide.none),
                  labelText: "Mobile"),
            ),
            trailing: Icon(
              Icons.phone,
              color: Colors.grey,
            ),
          ),
          Divider(
            height: 2,
          ),
          ListTile(
            title: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              controller: _city,
              decoration: InputDecoration(
                  border:
                  OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                  OutlineInputBorder(borderSide: BorderSide.none),
                  labelText: "City"),
            ),
            trailing: Icon(
              Icons.location_city,
              color: Colors.grey,
            ),
          ),
          Divider(
            height: 2,
          ),
          Visibility(
              visible: profileData['is_dealer'],
              child: Column(children: <Widget>[

          ListTile(
            title: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              controller: _area,
              decoration: InputDecoration(
                  border:
                  OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                  OutlineInputBorder(borderSide: BorderSide.none),
                  labelText: "Area"),
            ),
            trailing: Icon(
              Icons.my_location,
              color: Colors.grey,
            ),
          ),
          Divider(
            height: 2,
          ),
          ListTile(
            title: FormField(
              builder: (FormFieldState state) {
                return InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none),
                  ),
                  isEmpty: _category == "",
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _category,
                      isDense: true,
                      onChanged: (String newValue) {
                        setState(() {
                          _category = newValue;
                          state.didChange(newValue);
                        });
                      },
                      items: _categoryOption.map((String value) {
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
          )],)),
          Container(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(0, 30,0, 30),
            child: RaisedButton(
              onPressed: (){
                if(editStatus=="Edit") {
                  setState(() {
                    editStatus="Editing...";
                  });
                  if (!_formKey.currentState.validate()) {
                    return;
                  }
                  editData();
                }
              },
              color: Color(0xff005ad2),
              child: Text(editStatus, style: ThemeApp().buttonTextTheme(),),
            ),
          ),
        ],
      )))
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
                  width: 100.0,
                  height: 100.0,
                  child: new Image.file(
                    _image,
                    width: 100,
                    height: 100,
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
                          image: new AssetImage("assets/user.png"))))),
        ]));
  }

  void editData() async{
    Response response;
    Dio dio = Dio();
    try {
      if(image!=null){
      if (profileData['is_dealer']) {
        FormData formData = FormData.fromMap({
          "address": _address.text,
          "phone": _mobile.text,
          "city": _city.text,
          "area": _area.text,
          "category": _category,
          "image": await MultipartFile.fromFile(
              image.path, filename: image.path)
        });
        response =
        await dio.post(profileEditApi, data: formData, options: Options(
          contentType: 'application/json',
          headers: {HttpHeaders.authorizationHeader: "Token " + token},
        ));
      }
      else {
        FormData formData = FormData.fromMap({
          "phone": _mobile.text,
          "city": _city.text,
          "image": await MultipartFile.fromFile(
              image.path, filename: image.path)
        });
        response =
        await dio.post(profileCustomerEditApi, data: formData, options: Options(
          contentType: 'application/json',
          headers: {HttpHeaders.authorizationHeader: "Token " + token},
        ));
      }}
      else{
        if (profileData['is_dealer']) {
          FormData formData = FormData.fromMap({
            "address": _address.text,
            "phone": _mobile.text,
            "city": _city.text,
            "area": _area.text,
            "category": _category,
          });
          response =
          await dio.post(profileEditApi, data: formData, options: Options(
            contentType: 'application/json',
            headers: {HttpHeaders.authorizationHeader: "Token " + token},
          ));
        }
        else {
          FormData formData = FormData.fromMap({
            "phone": _mobile.text,
            "city": _city.text,
          });
          response =
          await dio.post(profileCustomerEditApi, data: formData, options: Options(
            contentType: 'application/json',
            headers: {HttpHeaders.authorizationHeader: "Token " + token},
          ));
        }
      }


      if (response.statusCode == 200 || response.statusCode == 201) {
        final snackBar = SnackBar(
          content: Text('Profile Edited Successfully !!'),
        );
        scaffoldKey.currentState.showSnackBar(snackBar);

        var profileResponse = await dio.get(profileApi, options: Options(
          contentType: 'application/json',
          headers: {HttpHeaders.authorizationHeader: "Token " + token},
        ));
        profileData = profileResponse.data;
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Menu(2)));
      }
      else {
        final snackBar = SnackBar(
          content: Text('Something went wrong...'),
        );
        scaffoldKey.currentState.showSnackBar(snackBar);
      }
    }catch(e){
      setState(() {
        editStatus = "Edit";
      });

      final snackBar = SnackBar(
        content: Text('Something went wrong...'),
      );
      scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }
}