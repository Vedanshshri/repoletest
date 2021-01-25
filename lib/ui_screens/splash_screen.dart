import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sec2hand/theme.dart';
import '../staticdata.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as secStore;
import 'menu.dart';




final storage = new secStore.FlutterSecureStorage();

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SlashScreen();
  }
}

// splash screen appears for 2 seconds when app loads

class _SlashScreen extends State<SplashScreen> {
  String type;
  Dio dio = new Dio();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          key: scaffoldKey,
          body: Center(
            child:
            Image.asset(
              'assets/logo.png',
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.40,
              fit: BoxFit.contain,
            ),
          ),
          bottomSheet: Container(
            width: double.infinity,
              padding: EdgeInsets.all(20),
              child:Text("Made In India",textAlign: TextAlign.center,style: ThemeApp().textSemiBoldTheme(),)),
        ),
    );
  }

  @override
  void initState() {
    // load required data when it loaded
    super.initState();
    loadData();
  }

  Future<Timer> loadData() async {
    // if (await Permission.storage
    //     .request()
    //     .isGranted) {
      token = await storage.read(key: "token")??"";
      type = await storage.read(
          key: "type"); // getting user token from shared preferences
      return new Timer(Duration(seconds: 0),
          onDoneLoading); // timer set to 2 second after that onDoneLoading is called
    // }
    // else if (await Permission.storage.isPermanentlyDenied) {
    //   final snackBar = SnackBar(
    //     content: Text("Please Add Storage Permission From Settings"),
    //   );
    //
    //   scaffoldKey.currentState.showSnackBar(snackBar);
    //
    // }
    // else{
    //   final snackBar = SnackBar(
    //     content: Text("Permission is Required"),
    //   );
    //   scaffoldKey.currentState.showSnackBar(snackBar);
    //  return Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>SplashScreen()));
    // }

  }

  onDoneLoading() async {

    final cityResponse = await dio.get(cityListApi, options: Options(
      contentType: 'application/json',
    ));
    cityListData = await cityResponse.data;
    print(cityListData);
    if (token != null && type != null) {
      try {
          var profileResponse = await dio.get(profileApi, options: Options(
            contentType: 'application/json',
            headers: {HttpHeaders.authorizationHeader: "Token " + token},
          ));
          profileData = profileResponse.data;
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Menu(0)));

      } catch (e) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Menu(0)));
      }
    }
    else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Menu(0))); // if no token found login first
    }
  }


}