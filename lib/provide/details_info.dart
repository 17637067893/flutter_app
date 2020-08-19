import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';

class DetailsInfoProvide with ChangeNotifier {
  Map goodsInfo = null;
  bool isLeft = true;
  bool isRight = false;

  getGoodsInfo(info) {
    goodsInfo = info;
    print('商品$goodsInfo');
    // request('goodsInfo', {'id': id}).then((val) {
    //   goodsInfo = val['goodsInfo'];
    //   print("getGoodsInfo>>>>>>>>>>>>>${goodsInfo}");
    //   notifyListeners();
    // });
  }

  //改变tabBar的状态
  changeLeftAndRight(String changeState) {
    if (changeState == 'left') {
      isLeft = true;
      isRight = false;
    } else {
      isLeft = false;
      isRight = true;
    }
    notifyListeners();
  }
}
