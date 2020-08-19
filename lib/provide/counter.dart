import 'package:flutter/material.dart';

class Counter with ChangeNotifier {
  int value = 99;
  String name = '小明';
  increment() {
    value++;
    notifyListeners();
  }
}
