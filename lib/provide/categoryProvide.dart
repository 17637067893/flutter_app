import 'dart:convert';

import 'package:flutter/material.dart';

class CategoryProvide with ChangeNotifier {
  List childList = [];
  List goodsList = [];
  int childIndex = 0;
  getChildTabs(list) {
    childList = list;
    notifyListeners();
  }

  getGoodsList(param) {
    goodsList = param;
    notifyListeners();
  }

  //改变子类索引
  changeChildIndex(int index) {
    childIndex = index;
    notifyListeners();
  }
}
