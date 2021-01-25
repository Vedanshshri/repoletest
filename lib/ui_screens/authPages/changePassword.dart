import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sec2hand/staticdata.dart';
import 'package:sec2hand/ui_screens/authPages/signUpPage.dart';
import 'package:sec2hand/ui_screens/menu.dart';

import '../../theme.dart';
import 'loginPage.dart';

class ChangePassword extends StatefulWidget {
  final sessionId;
  ChangePassword(this.sessionId);
  @override
  State<StatefulWidget> createState() {
    return _ChangePassword();
  }
}

class _ChangePassword extends State<ChangePassword> {
  Dio dio = new Dio();
  GlobalKey <ScaffoldState> scaffoldKey = GlobalKey();
  var changeStatus = "CHANGE";
  var _formKey = GlobalKey<FormState>();
  TextEditingController password = TextEditingController();
  TextEditingController cPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.fromLTRB(
                30, MediaQuery.of(context).size.height * 0.10, 30, 10),
            child: Form(
              key:_formKey,
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
                    "Enter new password ",
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
                            controller: password,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                labelText: "Password"),
                          ),
                          trailing: Icon(
                            Icons.lock,
                            color: Colors.grey,
                          ),
                        ),
                        Divider(height: 2,),
                        ListTile(
                          title: TextFormField(
                            controller: cPassword,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                labelText: "Confirm Password"),
                          ),
                          trailing: Icon(
                            Icons.lock,
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
                        if(changeStatus=="CHANGE") {
                          if (!_formKey.currentState.validate()) {
                            return;
                          }
                          if (password.text == cPassword.text) {
                            setState(() {
                              changeStatus = "Changing...";
                            });
                       changePassword();
                          }
                          else{

                          }
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
  void changePassword() async{

    FormData formData = FormData.fromMap({
      "session_id":widget.sessionId,
      "password" : password.text,
      "confirm_password" : cPassword.text
    });
    Response response;
    try {

      response = await dio.post(changePasswordApi, data: formData);

      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.data);
        final snackBar = SnackBar(
          content: Text("Password Changed Successfully ..."),
        );
        scaffoldKey.currentState.showSnackBar(snackBar);
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
