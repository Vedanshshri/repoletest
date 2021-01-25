import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import '../../state-city-data.dart';
import '../../staticdata.dart';
import '../menu.dart';

class CategoryPageAddSecond extends StatefulWidget {
  final selectedItem;
  final selectedSub;
  CategoryPageAddSecond(this.selectedItem, this.selectedSub);
  @override
  _CategoryPageAddSecondState createState() => _CategoryPageAddSecondState();
}

class _CategoryPageAddSecondState extends State<CategoryPageAddSecond> {
  String brand;
  String ram = '1 GB';
  String rom = '1 GB';
  String os = 'Android';
  var battery_capacity;
  String charger = "No";
  var camera = 0;
  var body = 0;
  var display = 0;
  var battery = 0;
  String insurence = "No";
  var offered_price;

  Dio dio = new Dio();
  var picker = ImagePicker();
  String dop;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String postStatus = "Add Product";
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
  Future<void> _selectDate(BuildContext context) async {
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

  Future<void> _selectDateofInsurance(BuildContext context) async {
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

  void postPic() async {
    Response response;
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
    FormData formData;
    String url;
    try {
      if (true) {
        formData = FormData.fromMap({
          "model": model,
          "price": offered_price,
          "date-of-purchage": selectedDateofpurchage,
          "brand": brand,
          "ram": ram,
          "rom": rom,
          "battery_capacity": battery_capacity,
          "insurence": insurence,
          "operating_system": os,
          "camera_rating": camera,
          "battery_rating": battery,
          "display_rating": display,
          "body_rating": body,
          "charger_included": charger,
          "insurence-valid-till": selectedDateofvalidinsurence,
          "offered-price": offered_price
        });
        url = mobileAddApi;
      }
      for (int i = 0; i < images.length; i++) {
        formData.files.addAll([MapEntry("images", images[i])]);
      }
      for (int i = 0; i < image_Bill.length; i++) {
        formData.files.addAll([MapEntry("image_bill", image_Bill[i])]);
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
                child: PageView(
                  controller: c,
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    child: Text(
                                      "Select the Brand",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: brand,
                                      iconEnabledColor: Colors.black,
                                      icon: Icon(Icons.arrow_downward),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: TextStyle(color: Colors.black),
                                      underline: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 30,
                                        color: Colors.grey,
                                      ),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          brand = newValue;
                                        });
                                      },
                                      items: brandListAll['mobile']
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
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
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
                                        width:
                                            MediaQuery.of(context).size.width,
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
                            elevation: 10,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    child: Text(
                                      "RAM",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: ram,
                                      iconEnabledColor: Colors.black,
                                      icon: Icon(Icons.arrow_downward),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: TextStyle(color: Colors.black),
                                      underline: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 30,
                                        color: Colors.grey,
                                      ),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          ram = newValue;
                                        });
                                      },
                                      items: [
                                        "1 GB",
                                        "2 GB",
                                        '3 GB',
                                        '4 GB',
                                        '5 GB',
                                        '6 GB',
                                        '7 GB',
                                        '8 GB'
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
                            height: 50,
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
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    child: Text(
                                      "ROM",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: rom,
                                      iconEnabledColor: Colors.black,
                                      icon: Icon(Icons.arrow_downward),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: TextStyle(color: Colors.black),
                                      underline: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 30,
                                        color: Colors.grey,
                                      ),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          rom = newValue;
                                        });
                                      },
                                      items: [
                                        "1 GB",
                                        "2 GB",
                                        '3 GB',
                                        '4 GB',
                                        '5 GB',
                                        '6 GB',
                                        '7 GB',
                                        '8 GB'
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
                            elevation: 10,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    child: Text(
                                      "Operating System",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: os,
                                      iconEnabledColor: Colors.black,
                                      icon: Icon(Icons.arrow_downward),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: TextStyle(color: Colors.black),
                                      underline: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 30,
                                        color: Colors.grey,
                                      ),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          os = newValue;
                                        });
                                      },
                                      items: [
                                        "Android",
                                        "Ios",
                                        "Colors OS",
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
                            height: MediaQuery.of(context).size.height * 0.1,
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
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    child: Text(
                                      "Battery Capacity",
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text("mAH"),
                                              Icon(
                                                Icons.battery_std,
                                                color: Colors.black,
                                              ),
                                            ],
                                          ),
                                        ),
                                        border: InputBorder.none),
                                    onChanged: (a) {
                                      battery_capacity = a;
                                    },
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
                                      fontSize: 45,
                                      fontWeight: FontWeight.bold),
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
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    child: Text(
                                      "Camera",
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
                                            camera = index + 1;
                                          });
                                        },
                                        icon: Icon(
                                          index < camera
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
                            height: MediaQuery.of(context).size.height * 0.005,
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
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    child: Text(
                                      "Battery",
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
                                            battery = index + 1;
                                          });
                                        },
                                        icon: Icon(
                                          index < battery
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
                            height: MediaQuery.of(context).size.height * 0.005,
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
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    child: Text(
                                      "Display",
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
                                            display = index + 1;
                                          });
                                        },
                                        icon: Icon(
                                          index < display
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
                            height: MediaQuery.of(context).size.height * 0.005,
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
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    child: Text(
                                      "Body",
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
                                            body = index + 1;
                                          });
                                        },
                                        icon: Icon(
                                          index < body
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
                                  onPressed: () => _selectDate(context),
                                  child: Text('Select Different date'),
                                ),
                              ],
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
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    child: Text(
                                      "Charger Included ?",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: charger,
                                      iconEnabledColor: Colors.black,
                                      icon: Icon(Icons.arrow_downward),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: TextStyle(color: Colors.black),
                                      underline: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 30,
                                        color: Colors.grey,
                                      ),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          charger = newValue;
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
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    child: Text(
                                      "Insurance Available?",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 39,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: insurence,
                                      iconEnabledColor: Colors.black,
                                      icon: Icon(Icons.arrow_downward),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: TextStyle(color: Colors.black),
                                      underline: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 30,
                                        color: Colors.grey,
                                      ),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          insurence = newValue;
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
                          Visibility(
                            visible: insurence == 'Yes' ? true : false,
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
                                    height: MediaQuery.of(context).size.height *
                                        0.04,
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
                                        _selectDateofInsurance(context),
                                    child: Text('Select Different date'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  " Upload Photos of Mobile                                     ",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                _getImage(),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.005,
                                ),
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
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              shadowColor: Colors.blue,
                              elevation: 10,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
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
                              height: MediaQuery.of(context).size.height * 0.3,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
