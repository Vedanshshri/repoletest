import 'dart:io';
//import 'material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import '../ui_screens/shared/loading.dart';
import '../staticdata.dart';
import '../theme.dart';

import 'menu.dart';
import 'dart:async';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class AddProductPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddProductPage();
  }
}

class _AddProductPage extends State<AddProductPage> {
  var _typeOption = ["motorcycle", "scooter", 'car', 'mobile'];
  var _fuelTypeOption = ["petrol", "diesel"];
  var _formKey = GlobalKey<FormState>();
  TextEditingController _km = TextEditingController();
  TextEditingController _color = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _year = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String postStatus = "Add Product";
  String _type = "motorcycle";
  String _fuelType = "petrol";
  String _brandName = "Brand";
  String _modelName = "Model";
  String vehicleType;
  List<Asset> imagesList = List<Asset>();
  String _error = 'No Error Detected';

  @override
  void initState() {
    super.initState();
    if (profileData["category"] == "mobile") {
      vehicleType = "Mobile";
    } else if (profileData["category"] == "car") {
      vehicleType = "Car";
    } else {
      if (_type == "motorcycle") {
        vehicleType = "Bikes";
      } else {
        vehicleType = "Scooters";
      }
    }
  }

  Widget buildGridView() {
    if (imagesList.length == 0) return Container();

    return Container(
        child: GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      children: List.generate(imagesList.length, (index) {
        Asset asset = imagesList[index];
        return Card(
            child: AssetThumb(
          asset: asset,
          width: 100,
          height: 100,
        ));
      }),
    ));
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = '';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: imagesList,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Sec2Hand",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      imagesList = resultList;

      _error = error;
    });
  }

  Dio dio = new Dio();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Sec2Hand",
          style: ThemeApp().appBarTheme(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _getImage(),
            Text("Add Images"),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Visibility(
                      visible: profileData['category'] == "bike" ||
                              profileData['category'] == "Bike"
                          ? true
                          : false,
                      child: Divider(
                        height: 2,
                      )),
                  Visibility(
                    visible: profileData['category'] == "bike" ||
                            profileData['category'] == "Bike"
                        ? true
                        : false,
                    child: ListTile(
                      title: FormField(
                        builder: (FormFieldState state) {
                          return InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Type',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                            isEmpty: _type == "",
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _type,
                                isDense: true,
                                onChanged: (String newValue) {
                                  setState(() {
                                    _type = newValue;
                                    if (_type == "motorcycle") {
                                      vehicleType = "Bikes";
                                    } else {
                                      vehicleType = "Scooters";
                                    }
                                    state.didChange(newValue);
                                  });
                                },
                                items: _typeOption.map((String value) {
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
                  ),
                  Divider(
                    height: 2,
                  ),
                  ListTile(
                    onTap: () {
                      brandFetch();
                    },
                    title: Column(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width * 0.73,
                            child: Text(
                              "\n" + _brandName,
                              style: ThemeApp().textThemeGrey(),
                              overflow: TextOverflow.ellipsis,
                            )),
                        SizedBox(
                          height: 14,
                        )
                      ],
                    ),
                    trailing: Icon(
                      Icons.branding_watermark,
                      color: Colors.grey,
                    ),
                  ),
                  Divider(
                    height: 2,
                  ),
                  ListTile(
                    onTap: () {
                      modelFetch();
                    },
                    title: Column(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width * 0.73,
                            child: Text(
                              "\n" + _modelName,
                              style: ThemeApp().textThemeGrey(),
                              overflow: TextOverflow.ellipsis,
                            )),
                        SizedBox(
                          height: 14,
                        )
                      ],
                    ),
                    trailing: Icon(
                      Icons.book,
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
                      controller: _price,
                      decoration: InputDecoration(
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          labelText: "Price"),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: false),
                    ),
                    trailing: Icon(
                      Icons.monetization_on,
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
                      controller: _year,
                      decoration: InputDecoration(
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          labelText: "Year"),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: false),
                    ),
                    trailing: Icon(
                      Icons.date_range,
                      color: Colors.grey,
                    ),
                  ),
                  Visibility(
                      visible: profileData['category'] == "mobile" ||
                              profileData['category'] == "Mobile"
                          ? false
                          : true,
                      child: Divider(
                        height: 2,
                      )),
                  Visibility(
                      visible: profileData['category'] == "mobile" ||
                              profileData['category'] == "Mobile"
                          ? false
                          : true,
                      child: ListTile(
                        title: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                          controller: _km,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              labelText: "Km"),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: false),
                        ),
                        trailing: Icon(
                          Icons.airplanemode_active,
                          color: Colors.grey,
                        ),
                      )),
                  Visibility(
                      visible: profileData['category'] == "car" ||
                              profileData['category'] == "Car"
                          ? true
                          : false,
                      child: Divider(
                        height: 2,
                      )),
                  Visibility(
                      visible: profileData['category'] == "car" ||
                              profileData['category'] == "Car"
                          ? true
                          : false,
                      child: ListTile(
                        title: FormField(
                          builder: (FormFieldState state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Fuel Type',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                              ),
                              isEmpty: _fuelType == "",
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _fuelType,
                                  isDense: true,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      _fuelType = newValue;
                                      state.didChange(newValue);
                                    });
                                  },
                                  items: _fuelTypeOption.map((String value) {
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
                      )),
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
                      controller: _color,
                      decoration: InputDecoration(
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          labelText: "Color"),
                    ),
                    trailing: Icon(
                      Icons.color_lens,
                      color: Colors.grey,
                    ),
                  ),
                  Divider(
                    height: 2,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 30, 0),
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
              child: RaisedButton(
                onPressed: () {
                  if (postStatus == "Add Product") {
                    if (!_formKey.currentState.validate()) {
                      return;
                    }

                    if (imagesList.length == 0) {
                      final snackBar = SnackBar(
                        content: Text('Please Add a Picture'),
                      );
                      scaffoldKey.currentState.showSnackBar(snackBar);
                      return;
                    }
                    if (_brandName == "Brand" || _modelName == "Model") {
                      final snackBar = SnackBar(
                        content: Text('Please Brand and Model'),
                      );
                      scaffoldKey.currentState.showSnackBar(snackBar);
                      return;
                    }
                    setState(() {
                      postStatus = "Uploading...";
                    });
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
          imagesList.length != 0
              ? InkWell(
                  onTap: loadAssets,
                  child: buildGridView(),
                )
              : InkWell(
                  onTap: loadAssets,
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

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 50,
    );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }

  Future<Directory> getTemporaryDirectory() async {
    return Directory.systemTemp;
  }

  void postPic() async {
    Response response;
    List images = [];
    var tmpDir = (await getTemporaryDirectory()).path;
    for (int i = 0; i < imagesList.length; i++) {
      var path =
          await FlutterAbsolutePath.getAbsolutePath(imagesList[i].identifier);
      var newPath = "$tmpDir/${DateTime.now().millisecondsSinceEpoch}.jpg";
      File imgCompress = await testCompressAndGetFile(File(path), newPath);
      var img = await MultipartFile.fromFile(newPath, filename: newPath);
      images.add(img);
    }
    FormData formData;
    String url;
    try {
      if (profileData['category'] == "car" ||
          profileData['category'] == "Car") {
        formData = FormData.fromMap({
          "model": _modelName,
          "km": _km.text,
          "price": _price.text,
          "year": _year.text,
          "color": _color.text,
          "fuel_type": _fuelType,
          "brand": _brandName
        });
        url = carAddApi;
      }
      if (profileData['category'] == "bike" ||
          profileData['category'] == "Bike") {
        formData = FormData.fromMap({
          "model": _modelName,
          "km": _km.text,
          "price": _price.text,
          "year": _year.text,
          "color": _color.text,
          "type": _type,
          "brand": _brandName
        });
        url = bikeAddApi;
      }
      if (profileData['category'] == "mobile" ||
          profileData['category'] == "Mobile") {
        formData = FormData.fromMap({
          "model": _modelName,
          "price": _price.text,
          "year": _year.text,
          "color": _color.text,
          "brand": _brandName
        });
        url = mobileAddApi;
      }
      for (int i = 0; i < images.length; i++) {
        formData.files.addAll([MapEntry("images", images[i])]);
      }
      response = await dio.post(url,
          data: formData,
          options: Options(
            contentType: 'application/json',
            headers: {HttpHeaders.authorizationHeader: "Token " + token},
          ));

      if (response.statusCode == 200 || response.statusCode == 201) {
        var profileResponse = await dio.get(profileApi,
            options: Options(
              contentType: 'application/json',
              headers: {HttpHeaders.authorizationHeader: "Token " + token},
            ));
        profileData = profileResponse.data;

        final snackBar = SnackBar(
          content: Text('Product added Successfully'),
        );
        scaffoldKey.currentState.showSnackBar(snackBar);

        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Menu(1)));
      } else {
        setState(() {
          postStatus = "Add Product";
        });

        final snackBar = SnackBar(
          content: Text('Something went wrong...'),
        );
        scaffoldKey.currentState.showSnackBar(snackBar);
      }
    } catch (e) {
      setState(() {
        postStatus = "Add Product";
      });

      final snackBar = SnackBar(
        content: Text(e.toString()),
      );
      scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  brandFetch() {
    TextEditingController _brand = TextEditingController();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Column(
          children: [
            ListTile(
                title: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                  controller: _brand,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder:
                          OutlineInputBorder(borderSide: BorderSide.none),
                      labelText: "Add New Brand"),
                ),
                trailing: InkWell(
                  onTap: () {
                    setState(() {
                      _brandName = _brand.text;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                  ),
                )),
            Divider(
              height: 2,
            ),
            FutureBuilder(
                future: fetchBrandDetails(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Text('No Connectivity');
                    case ConnectionState.waiting:
                      return Loading();
                    default:
                      if (snapshot.hasError) {
                        // if error then this message is shown
                        return Center(
                            child: Text(
                          "Something Went Wrong .",
                          style: TextStyle(color: Colors.red),
                        ));
                      } else if (snapshot.data != null) {
                        return Container(
                            height: MediaQuery.of(context).size.height * 0.7,
                            padding: EdgeInsets.fromLTRB(17, 0, 17, 25),
                            child: getList(snapshot.data));
                      } else
                        return Center(
                            child: Text(
                          "No Data Found for Brands",
                          style: TextStyle(color: Colors.white),
                        ));
                  }
                })
          ],
        ));
      },
    );
  }

  getList(data) {
    if (data.length == 0) {
      return Container();
    }
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, index) {
          return ListTile(
            onTap: () {
              setState(() {
                _brandName = data[index]["Brand"];
              });
              Navigator.of(context).pop();
            },
            title: Text(data[index]["Brand"]),
          );
        });
  }

  fetchBrandDetails() async {
    Dio dio = Dio();
    FormData formData = FormData.fromMap({
      "type": vehicleType,
    });
    Response response = await dio.post(brandListApi, data: formData);
    print(response.data);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      return [];
    }
  }

  modelFetch() {
    TextEditingController _model = TextEditingController();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Column(children: [
          ListTile(
              title: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
                controller: _model,
                decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    labelText: "Add New Model"),
              ),
              trailing: InkWell(
                onTap: () {
                  setState(() {
                    _modelName = _model.text;
                  });
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                ),
              )),
          Divider(
            height: 2,
          ),
          FutureBuilder(
              future: fetchModelDetails(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('No Connectivity');
                  case ConnectionState.waiting:
                    return Loading();
                  default:
                    if (snapshot.hasError) {
                      // if error then this message is shown
                      return Center(
                          child: Text(
                        "Something Went Wrong .",
                        style: TextStyle(color: Colors.red),
                      ));
                    } else if (snapshot.data != null) {
                      return Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          padding: EdgeInsets.fromLTRB(17, 0, 17, 25),
                          child: getModelList(snapshot.data));
                    } else
                      return Center(
                          child: Text(
                        "No Data Found for Models",
                        style: TextStyle(color: Colors.white),
                      ));
                }
              })
        ]));
      },
    );
  }

  getModelList(data) {
    if (data.length == 0) {
      return Container();
    }
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, index) {
          return ListTile(
            onTap: () {
              setState(() {
                _modelName = data[index]["Model"];
              });
              Navigator.of(context).pop();
            },
            title: Text(data[index]["Model"]),
          );
        });
  }

  fetchModelDetails() async {
    Dio dio = Dio();
    FormData formData =
        FormData.fromMap({"type": vehicleType, "brand_name": _brandName});
    Response response = await dio.post(brandListApi, data: formData);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      return [];
    }
  }
}
