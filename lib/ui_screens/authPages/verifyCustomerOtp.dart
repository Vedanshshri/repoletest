import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sec2hand/staticdata.dart';
import 'package:sec2hand/ui_screens/menu.dart';

import '../../theme.dart';
import '../splash_screen.dart';
import 'loginPage.dart';

class VerifyRegisterOtp extends StatefulWidget {
  final sessionId;
  final phone;
  VerifyRegisterOtp(this.sessionId,this.phone);
  @override
  State<StatefulWidget> createState() {
    return _VerifyRegisterOtp();
  }
}

class _VerifyRegisterOtp extends State<VerifyRegisterOtp> {
  Dio dio = new Dio();
  TextEditingController otp = TextEditingController();
  GlobalKey <ScaffoldState> scaffoldKey = GlobalKey();
  var _formKey = GlobalKey<FormState>();
  var changeStatus = "VERIFY";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.fromLTRB(
                30, MediaQuery.of(context).size.height * 0.10, 30, 10),
            child: Form(
              key : _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  Image.asset(
                    'assets/logo.png',
                    width: MediaQuery.of(context).size.width * 0.30,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Enter the otp ",
                    style: ThemeApp().textTheme(),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Card(
                    elevation: 10,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: TextFormField(
                            controller: otp,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                labelText: "OTP"),
                            keyboardType: TextInputType.phone,
                          ),
                          trailing: Icon(
                            Icons.code,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
                    child: RaisedButton(
                      onPressed: () {
                        if(changeStatus=="VERIFY") {
                          if (!_formKey.currentState.validate()) {
                            return;
                          }

                          setState(() {
                            changeStatus = "Verifying...";
                          });
                          verifyOtp();
                        }

                      },
                      color: Color(0xff005ad2),
                      child: Text(
                        changeStatus,
                        style: ThemeApp().buttonTextTheme(),
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => Menu(2)));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.arrow_back_ios),
                          Text("Back to Login"),
                        ],
                      ))
                ],
              ),
            )),
      ),
    );
  }

  void verifyOtp() async{

    FormData formData = FormData.fromMap({
      "session_id":widget.sessionId,
      "otp" : otp.text,
      "phone": widget.phone
    });
    Response response;
    try {

      response = await dio.post(verifyCustomerOtpApi, data: formData);

      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.data);
        token = response.data["token"];
        storage.write(key: "token", value: token = response.data['token']);
        storage.write(key: "type", value: "customer");
        var profileResponse = await dio.get(profileApi, options: Options(
          contentType: 'application/json',
          headers: {HttpHeaders.authorizationHeader: "Token " + token},
        ));
        profileData = profileResponse.data;
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Menu(2)));
      }
      else{
        setState(() {
          changeStatus = "Send";
        });
        final snackBar = SnackBar(
          content: Text("Wrong OTP Try Again"),
        );
        scaffoldKey.currentState.showSnackBar(snackBar);
      }
    }
    catch(err)
    {
      setState(() {
        changeStatus = "Send";
      });
      final snackBar = SnackBar(
        content: Text("Something went wrong ..."),
      );
      scaffoldKey.currentState.showSnackBar(snackBar);
    }

  }
}
