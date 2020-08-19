import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartProvide with ChangeNotifier {
  String cartString = '[]';
  List cartList = [];

  double allPrice = 0.0; //总价格
  int allGoodsCount = 0;
  bool isAllCheck = true; //是否全选
  save(goodsId, goodsName, count, price, images) async {
    print('加入购物车');
    //初始化
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    var temp = cartString == null ? [] : json.decode(cartString);
    List<Map> tempList = (temp as List).cast();
    // cartList = tempList;
    bool isHave = false;
    int ival = 0;
    tempList.forEach((element) {
      if (element['id'] == goodsId) {
        print(goodsId);
        tempList[ival]['count'] = element['count'] + 1;
        // print('数量${cartList[ival]['count']}');
        cartList[ival]['count']++;
        isHave = true;
      }
      ival++;
    });
    if (!isHave) {
      Map newGoods = {
        'id': goodsId,
        'goods_name': goodsName,
        'count': count,
        'isCheck': true,
        'goods_price': price,
        'goods_img': images
      };
      tempList.add(newGoods);
      cartList.add(newGoods);
      print("cartList>>>>>>>>>>${cartList}");
    }
    cartString = json.encode(tempList).toString();
    // print('cartString${cartString}');
    // print("cartList${cartList}");
    prefs.setString('cartInfo', cartString);
    getCartInfo();
  }

  //清空购物测
  remove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('cartInfo');
    cartList = [];
    allPrice = 0;
    print('清空完成${cartList}');
    print("》》》》》》》》${prefs.getStringList('cartInfo')}");
    await getCartInfo();
  }

  //获取数据
  getCartInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');

    cartList = [];
    if (cartString == null) {
      allPrice = 0;
      allGoodsCount = 0;
    } else {
      allPrice = 0;
      allGoodsCount = 0;
      isAllCheck = true;
      List tempList = (json.decode(cartString.toString()) as List).cast();
      // List tempList = json.decode(cartString);
      print('cartInfo>>>>>>>>>>>>>${tempList}');
      // cartList = tempList;
      tempList.forEach((element) {
        if (element['isCheck']) {
          // print(element['count']);
          int val1 = element['count'];

          double val2 = double.parse(element['goods_price']);
          print(val1 * val2);
          allPrice += val1 * val2;
          allGoodsCount += element['count'];
        } else {
          isAllCheck = false;
        }
        cartList.add(element);
      });
    }
    print('总价$allPrice');
    print('总量$allGoodsCount');
    notifyListeners();
  }

  //删除单个购物车商品
  deleteOneGoods(int goodsId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List tempList = (json.decode(cartString.toString()) as List).cast();
    // List<Map> tempList = (json.decode(cartString.toString()) as List).cast();

    int tempIndex = 0;
    int delIndex = 0;
    tempList.forEach((item) {
      if (item['goodsId'] == goodsId) {
        delIndex = tempIndex;
      }
      tempIndex++;
    });
    tempList.removeAt(delIndex);
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString); //
    await getCartInfo();
  }

  //按钮单选效果
  changeCheckState(cartItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo'); //得到持久化的字符串
    List tempList = (json.decode(cartString.toString()) as List)
        .cast(); //声明临时List，用于循环，找到修改项的索引
    int tempIndex = 0; //循环使用索引
    int changeIndex = 0; //需要修改的索引
    tempList.forEach((item) {
      if (item['id'] == cartItem['id']) {
        //找到索引进行复制
        changeIndex = tempIndex;
      }
      tempIndex++;
    });
    tempList[changeIndex] = cartItem; //把对象变成Map值
    cartString = json.encode(tempList).toString(); //变成字符串
    prefs.setString('cartInfo', cartString); //进行持久化
    await getCartInfo(); //重新读取列表
  }

  //点击全选按钮操作
  changeAllCheckBtnState(bool isCheck) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List tempList = (json.decode(cartString.toString()) as List).cast();
    List newList = []; //新建一个List，用于组成新的持久化数据。
    for (var item in tempList) {
      var newItem = item; //复制新的变量，因为Dart不让循环时修改原值
      newItem['isCheck'] = isCheck; //改变选中状态
      newList.add(newItem);
    }

    cartString = json.encode(newList).toString(); //形成字符串
    prefs.setString('cartInfo', cartString); //进行持久化
    await getCartInfo();
  }

  // 增减商品数量
  addOrReduceAction(cartItem, String todo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List tempList = (json.decode(cartString.toString()) as List).cast();
    int tempIndex = 0;
    int changeIndex = 0;
    tempList.forEach((item) {
      if (item['id'] == cartItem['id']) {
        changeIndex = tempIndex;
      }
      tempIndex++;
    });
    if (todo == 'add') {
      cartItem['count']++;
    } else if (cartItem['count'] > 1) {
      cartItem['count']--;
    }
    tempList[changeIndex] = cartItem;
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString); //
    await getCartInfo();
  }
}
