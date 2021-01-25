
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sec2hand/ui_screens/authPages/verifyCustomerOtp.dart';
import '../../theme.dart';
import '../menu.dart';
import '../splash_screen.dart';
import 'forgetPasswordPage.dart';
import 'signUpPage.dart';
import '../../staticdata.dart';




class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _Login();
  }

}


class _Login extends State<Login>{

   Dio dio = new Dio();

  var _formKey = GlobalKey<FormState>();
  TextEditingController _username  = TextEditingController();
  TextEditingController _password  = TextEditingController();
   TextEditingController _phone  = TextEditingController();
  GlobalKey <ScaffoldState> scaffoldKey = GlobalKey();
  var _usertype;
  bool customerVal = true;
  bool dealerVal = false;
  String loginStatus = "LOGIN";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.fromLTRB(30, MediaQuery.of(context).size.height*0.05, 30, 10),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  Image.asset(
                    'assets/logo.png',
                    width: MediaQuery.of(context).size.width *0.30,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 20,),
                  Text("Login here to continue", style: ThemeApp().textTheme(),),
                  SizedBox(height: 40,),
                  Card(
                    elevation: 10   ,
                    child: Column(
                      children: <Widget>[
                      Visibility(
                          visible: dealerVal,
                          child:  ListTile(
                          title: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                            controller: _username,
                            decoration: InputDecoration(
                                border:  OutlineInputBorder(
                                    borderSide: BorderSide.none
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none
                                ),
                                labelText: "Username"
                            ),

                          ),
                          trailing: Icon(Icons.person, color: Colors.grey,),
                        )),
                        Visibility(
                            visible: dealerVal,
                            child:Divider(height: 2,)),
                       Visibility(
                         visible: dealerVal,
                         child: ListTile(
                          title: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                            controller: _password,
                            decoration: InputDecoration(
                                border:  OutlineInputBorder(
                                    borderSide: BorderSide.none
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none
                                ),
                                labelText: "Password"
                            ),
                            obscureText: true,
                          ),
                          trailing: Icon(Icons.lock, color: Colors.grey,),

                        ),),
                        Visibility(
                          visible: customerVal,
                          child: ListTile(
                            title: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                              controller: _phone,
                              decoration: InputDecoration(
                                  border:  OutlineInputBorder(
                                      borderSide: BorderSide.none
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none
                                  ),
                                  labelText: "Mobile"
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                            trailing: Icon(Icons.phone, color: Colors.grey,),
                          ),)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Checkbox(
                        value: customerVal,
                        onChanged: (bool value) {
                          setState(() {
                            customerVal = value;
                            dealerVal = !value;
                          });
                        },
                      ),
                      Text(" I am a Customer")
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Checkbox(
                        value: dealerVal,
                        onChanged: (bool value) {
                          setState(() {
                            customerVal = !value;
                            dealerVal = value;
                          });
                        },
                      ),
                      Text(" I am a Dealer")
                    ],
                  ),
                  SizedBox(height: 10,),
               Visibility(
                   visible: dealerVal,
                   child:   Row(mainAxisAlignment: MainAxisAlignment.end,
                   children: <Widget>[
                     InkWell(
                       onTap: ()=>Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context)=>ForgotPassword())),
                       child: Text("Forgot Password ?", style: ThemeApp().textBoldLinkTheme(),),
                     )
                   ],
                 )),
                  Container(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(0, 30,0, 30),
                    child: RaisedButton(
                      onPressed: (){
                        if(loginStatus=="LOGIN") {
                          if (!_formKey.currentState.validate()) {
                            return;
                          }
                          if (customerVal) {
                            _usertype = "customer";
                          } else {
                            _usertype = "dealer";
                          }

                          setState(() {
                            loginStatus = "Logging in...";
                          });

                          loginUser();
                        }
                      },
                      color: Color(0xff005ad2),
                      child: Text(loginStatus, style: ThemeApp().buttonTextTheme(),),
                    ),
                  ),
                  InkWell(
                      onTap:() {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>SignUp()));
                      },
                      child:
                      RichText(
                        text: TextSpan(
                          text: 'Didn\'t have any Account?  ',
                          style: ThemeApp().textTheme(),
                          children: <TextSpan>[
                            TextSpan(text: 'Sign Up', style: ThemeApp().textBoldLinkTheme()),
                          ],
                        ),
                      )
                  )
                ],
              ),
            )
        ),
      ),
    );
  }

  void loginUser() async{
    FormData formData;
    if (_usertype == "customer") {
      formData = FormData.fromMap({
        "phone": _phone.text,
      });
    }
    else {
      formData = FormData.fromMap({
        "username": _username.text,
        "password": _password.text,
      });
    }
    Response response;
    try {
      if (_usertype == "customer") {
        response = await dio.post(customerLoginApi, data: formData);
        if(response.statusCode == 200) {
          print(response.data);
          if (response.data.containsKey("error")) {
            setState(() {
              loginStatus = "LOGIN";
            });
            final snackBar = SnackBar(
              content: Text(response.data["error"]),
            );
            scaffoldKey.currentState.showSnackBar(snackBar);
          }
          else {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) =>
                    VerifyRegisterOtp(
                        response.data["session_id"], _phone.text)));
        }
        }
        else{
          setState(() {
            loginStatus = "LOGIN";
          });
          final snackBar = SnackBar(
            content: Text("Something went wrong..."),
          );
          scaffoldKey.currentState.showSnackBar(snackBar);
        }
      }
      else {
        response = await dio.post(dealerLoginApi, data: formData);

        print(response.statusCode);
        if (response.statusCode == 200) {
          storage.write(key: "token", value: token = response.data['token']);
          usernameData = _username.text;
          if (_usertype == "dealer") {
            storage.write(key: "type", value: "dealer");
          }
          else {
            storage.write(key: "type", value: "customer");
          }
          token = response.data['token'];
          print(token);
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
            loginStatus = "LOGIN";
          });
          final snackBar = SnackBar(
            content: Text("Wrong Username or Password"),
          );
          scaffoldKey.currentState.showSnackBar(snackBar);
        }
      }
    }
    catch(err)
     {
       setState(() {
         loginStatus = "LOGIN";
       });
      final snackBar = SnackBar(
        content: Text("Wrong Username or Password"),
      );
      scaffoldKey.currentState.showSnackBar(snackBar);
    }

  }

}