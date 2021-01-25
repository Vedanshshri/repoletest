import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sec2hand/staticdata.dart';
import 'package:sec2hand/ui_screens/authPages/signUpPage.dart';
import 'package:sec2hand/ui_screens/authPages/verifyOtpPage.dart';
import 'package:sec2hand/ui_screens/menu.dart';

import '../../theme.dart';
import 'loginPage.dart';

class ForgotPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ForgotPassword();
  }
}

class _ForgotPassword extends State<ForgotPassword> {
  var changeStatus = "Send";
  Dio dio = new Dio();
  TextEditingController phone = TextEditingController();
  GlobalKey <ScaffoldState> scaffoldKey = GlobalKey();
  var _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:scaffoldKey,
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
                    "Enter Mobile no. to get a Code",
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
                            controller: phone,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                labelText: "Mobile"),
                            keyboardType: TextInputType.phone,
                          ),
                          trailing: Icon(
                            Icons.phone,
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
                        if(changeStatus=="Send") {
                          if (!_formKey.currentState.validate()) {
                            return;
                          }

                          setState(() {
                            changeStatus = "Sending...";
                          });
                          sendOtp();
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

  void sendOtp() async{

    FormData formData = FormData.fromMap({
      "phone" : phone.text,
    });
    Response response;
    try {

        response = await dio.post(sendOtpApi, data: formData);

      print(response.statusCode);
      if (response.statusCode == 200) {
        var sessionId = response.data["session_id"];
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => VerifyOtp(sessionId)));
      }
      else{
        setState(() {
          changeStatus = "Send";
        });
        final snackBar = SnackBar(
          content: Text("Something went wrong ..."),
        );
        scaffoldKey.currentState.showSnackBar(snackBar);
      }
    }
    catch(err)
    {

      print(err.toString());
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
