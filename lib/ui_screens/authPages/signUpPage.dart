import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sec2hand/state-city-data.dart';
import 'package:sec2hand/staticdata.dart';
import '../../theme.dart';
import '../menu.dart';
import '../splash_screen.dart';
import 'verifyCustomerOtp.dart';


class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUp();
  }
}

class _SignUp extends State<SignUp> {

  var _categoryOption = ["car", "mobile", "bike"];
  var _formKey = GlobalKey<FormState>();
  TextEditingController _username = TextEditingController();
  TextEditingController _code = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _area = TextEditingController();
  String _city;
  TextEditingController _shopName = TextEditingController();
  String _category = "car";
  String _state = statesData[0];
  TextEditingController _mobile = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _cPassword = TextEditingController();
  var _usertype;
  bool customerVal = true;
  bool dealerVal = false;
  String signUpStatus = "SIGN UP";
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  Dio dio = new Dio(); // with default Options
  @override
  void initState() {
    // TODO: implement initState
    _category = "car";
    _city = cityData[_state][0];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.fromLTRB(
                30, MediaQuery.of(context).size.height * 0.05, 30, 10),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/logo.png',
                    width: MediaQuery.of(context).size.width * 0.25,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Enter details and create account",
                    style: ThemeApp().textTheme(),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Card(
                    elevation: 10,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                            controller: _username,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                labelText: "Username"),
                          ),
                          trailing: Icon(
                            Icons.person,
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
                            controller: _mobile,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                labelText: "Mobile Number"),
                            keyboardType: TextInputType.phone,
                          ),
                          trailing: Icon(
                            Icons.phone,
                            color: Colors.grey,
                          ),
                        ),
                        Divider(
                          height: 2,
                        ),
                        Visibility(
                          visible: dealerVal,
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Required';
                                    }
                                    return null;
                                  },
                                  controller: _code,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      labelText: "S2H Code"),
                                ),
                                trailing: Icon(
                                  Icons.code,
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
                                  controller: _shopName,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      labelText: "Shop Name"),
                                ),
                                trailing: Icon(
                                  Icons.shop,
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
                                          items: _categoryOption
                                              .map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: ThemeApp()
                                                    .textSemiBoldTheme(),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
//                                TextFormField(
//                                  validator: (value) {
//                                    if (value.isEmpty) {
//                                      return 'Required';
//                                    }
//                                    return null;
//                                  },
//                                  controller: _category,
//                                  decoration: InputDecoration(
//                                      border: OutlineInputBorder(
//                                          borderSide: BorderSide.none),
//                                      focusedBorder: OutlineInputBorder(
//                                          borderSide: BorderSide.none),
//                                      labelText: "Category"),
//                                ),
//                                trailing: Icon(
//                                  Icons.category,
//                                  color: Colors.grey,
//                                ),
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
                                  controller: _address,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      labelText: "Address"),
                                ),
                                trailing: Icon(
                                  Icons.location_on,
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
                                  controller: _area,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none),
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
                                        labelText: 'State',
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                      ),
                                      isEmpty: _state == "",
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: _state,
                                          isDense: true,
                                          onChanged: (String newValue) {
                                            setState(() {
                                              _state = newValue;
                                              state.didChange(newValue);
                                              _city = cityData[_state][0];
                                            });
                                          },
                                          items: statesData
                                              .map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: ThemeApp()
                                                    .textSemiBoldThemeSmall(),
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
                              ),
                              ListTile(
                                title: FormField(
                                  builder: (FormFieldState state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                        labelText: 'City',
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                      ),
                                      isEmpty: _city == "",
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: _city,
                                          isDense: true,
                                          onChanged: (String newValue) {
                                            setState(() {
                                              _city = newValue;
                                              state.didChange(newValue);
                                            });
                                          },
                                          items:cityData[_state]
                                              .map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: ThemeApp()
                                                    .textSemiBoldTheme(),
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
                        ),
                        ListTile(
                          title: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                            controller: _password,
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
                            controller: _cPassword,
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
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 30, 0),
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
                    child: RaisedButton(
                      onPressed: () {

                        if (!_formKey.currentState.validate()) {
                          return;
                        }
                        if(_city==null){
                          final snackBar = SnackBar(
                            content: Text('Enter City Name !!'),
                          );
                          scaffoldKey.currentState.showSnackBar(snackBar);
                        }
                        else {
                          if (signUpStatus == "SIGN UP") {
                            setState(() {
                              signUpStatus = "Signing up..";
                            });


                            if (_password.text != _cPassword.text) {
                              final snackBar = SnackBar(
                                content: Text('Passwords not matching !!'),
                              );
                              scaffoldKey.currentState.showSnackBar(snackBar);
                              setState(() {
                                signUpStatus = "SIGN UP";
                              });
                              return;
                            }
                            if (customerVal) {
                              _usertype = "customer";
                            } else {
                              _usertype = "dealer";
                            }

                            registerUser();
                          }
                        }
                      },
                      color: Color(0xff005ad2),
                      child: Text(
                        signUpStatus,
                        style: ThemeApp().buttonTextTheme(),
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => Menu(2)));
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an Account?  ',
                          style: ThemeApp().textTheme(),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Login',
                                style: ThemeApp().textBoldLinkTheme()),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            )),
      ),
    );
  }

  void registerUser() async {
    Response response;

    try {
      if (_usertype == "dealer") {
        FormData formData = FormData.fromMap({
          "username": _username.text,
          "code": _code.text,
          "shop_name": _shopName.text,
          "address": _address.text,
          "phone": _mobile.text,
          "city": _city,
          "area": _area.text,
          "category": _category,
          "password1": _password.text,
          "password2": _cPassword.text,
        });
        response = await dio.post(dealerRegisterApi, data: formData);

        if (response.statusCode == 200 || response.statusCode == 201) {
          storage.write(key: "token", value: response.data['token']);
          storage.write(key: "type", value: "dealer");

          final snackBar = SnackBar(
            content: Text('User Registered Successfully'),
          );
          scaffoldKey.currentState.showSnackBar(snackBar);
          token = response.data['token'];
          print(token);
          var profileResponse = await dio.get(profileApi,
              options: Options(
                contentType: 'application/json',
                headers: {HttpHeaders.authorizationHeader: "Token " + token},
              ));
          profileData = profileResponse.data;
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Menu(2)));
        } else {
          setState(() {
            signUpStatus = "SIGN UP";
          });
          final snackBar = SnackBar(
            content: Text('Something went wrong...'),
          );
          scaffoldKey.currentState.showSnackBar(snackBar);
        }
      } else {
        FormData formData = FormData.fromMap({
          "username": _username.text,
          "phone": _mobile.text,
        });
        response = await dio.post(customerRegisterApi, data: formData);

        if (response.statusCode == 200 || response.statusCode == 201) {
          var sessionId = response.data["session_id"];
          print(response.data);
          print(response.data["session_id"]);
          if(response.data["status"]==true) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) =>
                    VerifyRegisterOtp(sessionId, _mobile.text)));
          }
          else {
            setState(() {
              signUpStatus = "SIGN UP";
            });
            final snackBar = SnackBar(
              content: Text('Something went wrong...'),
            );
            scaffoldKey.currentState.showSnackBar(snackBar);
          }
        } else {
          setState(() {
            signUpStatus = "SIGN UP";
          });
          final snackBar = SnackBar(
            content: Text('Something went wrong...'),
          );
          scaffoldKey.currentState.showSnackBar(snackBar);
        }
      }
    } catch (e) {
      setState(() {
        signUpStatus = "SIGN UP";
      });
      final snackBar = SnackBar(
        content: Text("Something went wrong..."),
      );
      scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }
}
