import 'package:sec2hand/staticdata.dart';

import 'staticdata.dart';

getCityList() {
  var list = [];
  for (var i = 0; i < cityListData.length; i++) {
    list.add(cityListData[i]["name"]);
  }
  return list;
}
