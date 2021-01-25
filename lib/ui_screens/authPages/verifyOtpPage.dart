import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sec2hand/staticdata.dart';
import 'package:sec2hand/ui_screens/authPages/changePassword.dart';
import 'package:sec2hand/ui_screens/authPages/signUpPage.dart';
import 'package:sec2hand/ui_screens/menu.dart';

import '../../theme.dart';
import 'loginPage.dart';

class VerifyOtp extends StatefulWidget {
  final sessionId;
  VerifyOtp(this.sessionId);
  @override
  State<StatefulWidget> createState() {
    return _VerifyOtp();
  }
}

class _VerifyOtp extends State<VerifyOtp> {
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
    });
    Response response;
    try {
      response = await dio.post(verifyOtpApi, data: formData);
      print(response.data);
      if (response.statusCode == 200) {
        if(response.data["status"]) {
          var sessionId = response.data["session_id"];

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => ChangePassword(sessionId)));
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
