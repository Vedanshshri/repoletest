import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import '../../state-city-data.dart';
import '../../staticdata.dart';
import '../menu.dart';

class CategoryPageAddSecondCar extends StatefulWidget {
  @override
  _CategoryPageAddSecondCarState createState() =>
      _CategoryPageAddSecondCarState();
}

class _CategoryPageAddSecondCarState extends State<CategoryPageAddSecondCar> {
  String brand;

  Dio dio = new Dio();
  var picker = ImagePicker();
  String dop;

  String state = "RJ";
  var no_of_owners = 1;
  var hypothecation = "No";
  var insurance = "No";
  var registration_Transfer = "No";
  var service_history = 1;
  int interior = 0;
  int engine = 0;
  int exterior = 0;
  String transmission = "Mannual";
  var offered_price;
  var km;
  var slug;
  bool _isCreatingLink;
  var _linkMessage;

  var _url;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String postStatus = "Add Product";
  String _fuelType = "Petrol";
  String vehicleType;
  List<Asset> imagesList = List<Asset>();
  List<Asset> imagesListbill = List<Asset>();
  int k = 1;

  String model;
  ScrollController c;
  DateTime selectedDateofpurchage = DateTime.now();
  DateTime selectedDateofvalidinsurence = DateTime.now();
  @override
  void initState() {
    super.initState();
    c = new PageController();
  }

  int selected = 0;
  final controler = PageController(
    initialPage: 1,
  );
  Future<void> _selectDateofpurchage(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDateofpurchage,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDateofpurchage)
      setState(() {
        selectedDateofpurchage = picked;
      });
  }

  Future<void> _selectDatetillinsurence_valid(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDateofvalidinsurence,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDateofvalidinsurence)
      setState(() {
        selectedDateofvalidinsurence = picked;
      });
  }

  Widget buildGridView() {
    if (imagesList.length == 0) return Container();

    return Container(
        child: GridView.count(
      physics: ScrollPhysics(),
      // controller: ,
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
    });
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
                    child: Icon(Icons.add_a_photo),
                  ),
                ),
        ]));
  }

  Widget buildGridView1() {
    if (imagesListbill.length == 0) return Container();

    return Container(
        child: GridView.count(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      children: List.generate(imagesListbill.length, (index) {
        Asset asset = imagesListbill[index];
        return Card(
            child: AssetThumb(
          asset: asset,
          width: 100,
          height: 100,
        ));
      }),
    ));
  }

  Future<void> loadAssets1() async {
    List<Asset> resultList = List<Asset>();
    String error = '';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: imagesListbill,
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
      imagesListbill = resultList;
    });
  }

  _getImage1() {
    return Container(
        margin: EdgeInsets.all(12),
        child: Column(children: <Widget>[
          imagesListbill.length != 0
              ? InkWell(
                  onTap: loadAssets1,
                  child: buildGridView1(),
                )
              : InkWell(
                  onTap: loadAssets1,
                  child: Container(
                    width: 100.0,
                    height: 100.0,
                    child: Icon(Icons.add_a_photo),
                  ),
                ),
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

  Future<void> _createDynamicLink(bool short) async {
    setState(() {
      _isCreatingLink = true;
    });

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://app.sec2hand.com/',
      link: Uri.parse('https://www.sec2hand.com/$slug'),
      androidParameters: AndroidParameters(
        packageName: 'com.lohitbura.sec2hand',
        minimumVersion: 0,
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.google.FirebaseCppDynamicLinksTestApp.dev',
        minimumVersion: '0',
      ),
    );

    //Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      _url = shortLink.shortUrl;
    } else {
      _url = await parameters.buildUrl();
    }

    setState(() {
      _linkMessage = _url.toString();
      _isCreatingLink = false;
    });
    print(_linkMessage);
    print(_url);
  }

  void postPic() async {
    Response response1;
    List images = [];
    List image_Bill = [];
    var tmpDir = (await getTemporaryDirectory()).path;
    for (int i = 0; i < imagesList.length; i++) {
      var path =
          await FlutterAbsolutePath.getAbsolutePath(imagesList[i].identifier);
      var newPath = "$tmpDir/${DateTime.now().millisecondsSinceEpoch}.jpg";
      File imgCompress = await testCompressAndGetFile(File(path), newPath);
      var img = await MultipartFile.fromFile(newPath, filename: newPath);
      images.add(img);
    }
    for (int i = 0; i < imagesListbill.length; i++) {
      var path = await FlutterAbsolutePath.getAbsolutePath(
          imagesListbill[i].identifier);
      var newPath = "$tmpDir/${DateTime.now().millisecondsSinceEpoch}.jpg";
      File imgCompress = await testCompressAndGetFile(File(path), newPath);
      var img = await MultipartFile.fromFile(newPath, filename: newPath);
      image_Bill.add(img);
    }
    FormData formData1;

    try {
      if (true) {
        formData1 = FormData.fromMap({
          "model": model,
          "price": offered_price,
          //"date-of-purchage": selectedDateofpurchage,
          "brand": brand,
          "insurance": insurance,
          "insurance_date": selectedDateofvalidinsurence,

          "fuel-type": _fuelType,
          "transmission": transmission,
          "state": state,
          "km": km,
          "hypothetication": hypothecation,
          "registertion-transfer": registration_Transfer,
          "ownership_state": no_of_owners,
          "service-history": service_history,
          "exterior-rate": exterior,
          "interior-rate": interior,
          "engine-rate": engine
        });
      }
      for (int i = 0; i < images.length; i++) {
        formData1.files.addAll([MapEntry("images", images[i])]);
      }
      for (int i = 0; i < image_Bill.length; i++) {
        formData1.files.addAll([MapEntry("image_bill", image_Bill[i])]);
      }
      response1 = await dio.post(carAddApi,
          data: formData1,
          options: Options(
            contentType: 'application/json',
            headers: {HttpHeaders.authorizationHeader: "Token " + token},
          ));

      if (response1.statusCode == 200 || response1.statusCode == 201) {
        var profileResponse = await dio.get(profileApi,
            options: Options(
              contentType: 'application/json',
              headers: {HttpHeaders.authorizationHeader: "Token " + token},
            ));
        profileData = profileResponse.data;
        _createDynamicLink(false);

        FormData formData2;
        slug = response1.data["slug"];
        var category = response1.data["category"];
        // ignore: unused_local_variable
        Response response2;
        formData2 = FormData.fromMap({
          "dynamic_link": _url,
          "category": category,
          "slug": slug,
        });
        response2 = await dio.post(dynamicLink,
            data: formData2,
            options: Options(
              contentType: 'application/json',
              headers: {HttpHeaders.authorizationHeader: "Token " + token},
            ));

        /* final snackBar = SnackBar(
          content: Text('Product added Successfully'),
        );
        scaffoldKey.currentState.showSnackBar(snackBar);*/

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FloatingActionButton(
              heroTag: "btn-bacl",
              onPressed: () {
                c.jumpTo(0.0);
                k = 1;
              },
              child: Icon(Icons.keyboard_arrow_left_outlined),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
            ),
            FloatingActionButton(
              heroTag: "btn-for",
              onPressed: () {
                c.animateTo(MediaQuery.of(context).size.width * k,
                    duration: new Duration(milliseconds: 1),
                    curve: Curves.easeIn);
                k = k + 1;
              },
              child: Icon(
                Icons.keyboard_arrow_right_outlined,
              ),
            )
          ],
        ),
        appBar: AppBar(
          title: Text("Fill the Details"),
        ),
        //backgroundColor: Colors.lightBlue.shade500,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.swipe,
                size: 100,
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: PageView(controller: c, children: [
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          shadowColor: Colors.blue,
                          //color: Colors.lightBlue.shade200,
                          elevation: 10,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  child: Text(
                                    "Select the Brand",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: brand,
                                      iconEnabledColor: Colors.black,
                                      icon: Icon(Icons.arrow_downward),
                                      iconSize: 24,
                                      elevation: 10,
                                      style: TextStyle(color: Colors.black),
                                      underline: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 10,
                                        color: Colors.grey,
                                      ),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          brand = newValue;
                                        });
                                      },
                                      items: brandListAll['car']
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              child: Text(value)),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          shadowColor: Colors.blue,
                          //color: Colors.lightBlue.shade200,
                          elevation: 10,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: Text(
                                      "Select the Model",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: model,
                                    iconEnabledColor: Colors.black,
                                    icon: Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(color: Colors.black),
                                    underline: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 10,
                                      color: Colors.grey,
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        model = newValue;
                                      });
                                    },
                                    items: model_phones['Redmi']
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: Text(value)),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          shadowColor: Colors.blue,
                          //color: Colors.lightBlue.shade200,
                          elevation: 10,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  child: Text(
                                    "Fuel Type",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _fuelType,
                                      iconEnabledColor: Colors.black,
                                      icon: Icon(Icons.arrow_downward),
                                      iconSize: 24,
                                      elevation: 10,
                                      style: TextStyle(color: Colors.black),
                                      underline: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 10,
                                        color: Colors.grey,
                                      ),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          _fuelType = newValue;
                                        });
                                      },
                                      items: [
                                        "Electric",
                                        "Petrol",
                                        "Diesel",
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              child: Text(value)),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          shadowColor: Colors.blue,
                          //color: Colors.lightBlue.shade200,
                          elevation: 10,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  child: Text(
                                    "Transmission",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: transmission,
                                      iconEnabledColor: Colors.black,
                                      icon: Icon(Icons.arrow_downward),
                                      iconSize: 24,
                                      elevation: 10,
                                      style: TextStyle(color: Colors.black),
                                      underline: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 10,
                                        color: Colors.grey,
                                      ),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          transmission = newValue;
                                        });
                                      },
                                      items: [
                                        "Automatic",
                                        "Mannual",
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              child: Text(value)),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          shadowColor: Colors.blue,
                          //color: Colors.lightBlue.shade200,
                          elevation: 10,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: Text(
                                      "Select the State",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: state,
                                    iconEnabledColor: Colors.black,
                                    icon: Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(color: Colors.black),
                                    underline: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 10,
                                      color: Colors.grey,
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        state = newValue;
                                      });
                                    },
                                    items: ["RJ", "DJ", "UP"]
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: Text(value)),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                        ),
                        Card(
                          shadowColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 10,
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Text(
                                    "Total KM Car Has Run",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                              ),
                              TextField(
                                onChanged: (a) {
                                  km = a;
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "  Eg. 23456KM"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          shadowColor: Colors.blue,
                          //color: Colors.lightBlue.shade200,
                          elevation: 10,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: Text(
                                      "Insurance",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: insurance,
                                    iconEnabledColor: Colors.black,
                                    icon: Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(color: Colors.black),
                                    underline: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 10,
                                      color: Colors.grey,
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        insurance = newValue;
                                      });
                                    },
                                    items: [
                                      "Yes",
                                      "No",
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: Text(value)),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.004,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          shadowColor: Colors.blue,
                          //color: Colors.lightBlue.shade200,
                          elevation: 10,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: Text(
                                      "Hypothecation",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: hypothecation,
                                    iconEnabledColor: Colors.black,
                                    icon: Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(color: Colors.black),
                                    underline: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 10,
                                      color: Colors.grey,
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        hypothecation = newValue;
                                      });
                                    },
                                    items: [
                                      "Yes",
                                      "No",
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: Text(value)),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.004,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          shadowColor: Colors.blue,
                          //color: Colors.lightBlue.shade200,
                          elevation: 10,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: Text(
                                      "Registration Transfer",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 37,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: registration_Transfer,
                                    iconEnabledColor: Colors.black,
                                    icon: Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(color: Colors.black),
                                    underline: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 10,
                                      color: Colors.grey,
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        registration_Transfer = newValue;
                                      });
                                    },
                                    items: [
                                      "Yes",
                                      "No",
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: Text(value)),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.004,
                        ),
                        Card(
                          shadowColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 10,
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  "No. of Owners",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                              ),
                              TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: " No of Owners before Buyer"),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.004,
                        ),
                        Card(
                          shadowColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 10,
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  "Service History",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                              ),
                              TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: " How Many Services in a Year"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                          shadowColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 10,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Text(
                                    "Date of Purchage",
                                    style: TextStyle(
                                        fontSize: 40,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                              ),
                              Center(
                                child: Text(
                                  "${selectedDateofpurchage.toLocal()}"
                                      .split(' ')[0],
                                  style: TextStyle(fontSize: 30),
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              RaisedButton(
                                color: Colors.blue,
                                onPressed: () => _selectDateofpurchage(context),
                                child: Text('Select Different date'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Visibility(
                          visible: insurance == 'Yes' ? true : false,
                          child: Card(
                            shadowColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 10,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: Text(
                                      "Date Till Which Insurence is Valid",
                                      style: TextStyle(
                                          fontSize: 35,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                ),
                                Center(
                                  child: Text(
                                    "${selectedDateofvalidinsurence.toLocal()}"
                                        .split(' ')[0],
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                RaisedButton(
                                  color: Colors.blue,
                                  onPressed: () =>
                                      _selectDatetillinsurence_valid(context),
                                  child: Text('Select Different date'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          shadowColor: Colors.blue,
                          elevation: 5,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text(
                                "Mobile Condition",
                                style: TextStyle(
                                    fontSize: 45, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          shadowColor: Colors.blue,
                          elevation: 10,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  child: Text(
                                    "Exterior",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(5, (index) {
                                    return IconButton(
                                      color: Colors.amber,
                                      onPressed: () {
                                        setState(() {
                                          exterior = index + 1;
                                        });
                                      },
                                      icon: Icon(
                                        index < exterior
                                            ? Icons.star
                                            : Icons.star_border,
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          shadowColor: Colors.blue,
                          elevation: 10,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  child: Text(
                                    "Interior",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(5, (index) {
                                    return IconButton(
                                      color: Colors.amber,
                                      onPressed: () {
                                        setState(() {
                                          interior = index + 1;
                                        });
                                      },
                                      icon: Icon(
                                        index < interior
                                            ? Icons.star
                                            : Icons.star_border,
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          shadowColor: Colors.blue,
                          elevation: 10,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  child: Text(
                                    "Engine",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(5, (index) {
                                    return IconButton(
                                      color: Colors.amber,
                                      onPressed: () {
                                        setState(() {
                                          engine = index + 1;
                                        });
                                      },
                                      icon: Icon(
                                        index < engine
                                            ? Icons.star
                                            : Icons.star_border,
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Upload Photos of Car                                     ",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            _getImage()
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Text(
                          "Upload Photo of Bill                                     ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        _getImage1(),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          shadowColor: Colors.blue,
                          elevation: 10,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  child: Text(
                                    " Offered Price ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      suffixIcon: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text("INR"),
                                            Icon(
                                              Icons.money,
                                              color: Colors.black,
                                            ),
                                          ],
                                        ),
                                      ),
                                      border: InputBorder.none),
                                  onChanged: (a) {
                                    offered_price = a;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        RaisedButton(
                          color: Colors.blue,
                          onPressed: () {
                            postPic();
                          },
                          child: Text("Done"),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.23,
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ));
  }
}
