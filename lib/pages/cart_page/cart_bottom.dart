import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../provide/cart.dart';

class CartBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<CartProvide>(
      builder: (context, child, value) {
        return Container(
          margin: EdgeInsets.all(5.0),
          color: Colors.white,
          width: ScreenUtil().setWidth(750),
          child: Row(
            children: <Widget>[
              selectAllBtn(context, value.isAllCheck),
              allPriceArea(context, value.allPrice),
              goButton(context, value.allGoodsCount)
            ],
          ),
        );
      },
    );
  }

  //全选
  Widget selectAllBtn(context, value) {
    return Container(
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: (bool val) {
              Provide.value<CartProvide>(context).changeAllCheckBtnState(val);
            },
            activeColor: Colors.pink,
          )
        ],
      ),
    );
  }

  //合计区域
  Widget allPriceArea(context, val) {
    return Container(
      width: ScreenUtil().setWidth(430),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.centerRight,
                width: ScreenUtil().setWidth(280),
                child: Text(
                  '合计',
                  style: TextStyle(fontSize: ScreenUtil().setSp(36)),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                width: ScreenUtil().setWidth(150),
                child: Text(
                  "￥${val}",
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(36), color: Colors.red),
                ),
              )
            ],
          ),
          Container(
            width: ScreenUtil().setWidth(430),
            alignment: Alignment.centerRight,
            child: Text(
              '满10元免配送费，预购免配送费',
              style: TextStyle(
                  color: Colors.black38, fontSize: ScreenUtil().setSp(22)),
            ),
          )
        ],
      ),
    );
  }

  //结算按钮
  Widget goButton(context, val) {
    // int allGoodsCount = Provide.value<CartProvide>(context).allGoodsCount;
    return Container(
      width: ScreenUtil().setWidth(220),
      padding: EdgeInsets.only(left: 10),
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(10.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(3.0)),
          child: Text(
            "结算(${val})",
            style: TextStyle(
                color: Colors.white, fontSize: ScreenUtil().setSp(40)),
          ),
        ),
      ),
    );
  }
}
