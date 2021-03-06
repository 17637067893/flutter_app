import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';
import '../../provide/cart.dart';
import '../../provide/details_info.dart';
import '../../provide/currentIndex.dart';

class DetailsBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var goodsInfo = Provide.value<DetailsInfoProvide>(context).goodsInfo;
    var id = goodsInfo['id'];
    var count = 1;
    var price = goodsInfo['goods_price'];
    var name = goodsInfo['goods_name'];
    var img = goodsInfo['goods_img'];
    return Container(
      width: ScreenUtil().setWidth(750),
      color: Colors.white,
      height: ScreenUtil().setHeight(80),
      child: Row(
        children: <Widget>[
          Stack(
            children: [
              InkWell(
                onTap: () {
                  Provide.value<CurrentIndexProvide>(context).changeIndex(2);
                  Navigator.pop(context);
                },
                child: Container(
                  width: ScreenUtil().setWidth(110),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.shopping_cart,
                    size: 35,
                    color: Colors.red,
                  ),
                ),
              ),
              Provide<CartProvide>(
                builder: (context, child, value) {
                  int goodsCount =
                      Provide.value<CartProvide>(context).allGoodsCount;
                  return Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                        decoration: BoxDecoration(
                            color: Colors.pink,
                            border: Border.all(width: 2, color: Colors.white),
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          "${goodsCount}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(22)),
                        ),
                      ));
                },
              ),
            ],
          ),
          InkWell(
            onTap: () async {
              await Provide.value<CartProvide>(context)
                  .save(id, name, count, price, img);
            },
            child: Container(
              alignment: Alignment.center,
              width: ScreenUtil().setWidth(320),
              height: ScreenUtil().setHeight(80),
              color: Colors.green,
              child: Text(
                '加入购物车',
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(28)),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Provide.value<CartProvide>(context).remove();
              // Fluttertoast.showToast(
              //     msg: "暂无此功能",
              //     toastLength: Toast.LENGTH_SHORT,
              //     gravity: ToastGravity.CENTER,
              //     timeInSecForIosWeb: 1,
              //     backgroundColor: Colors.pink,
              //     textColor: Colors.white,
              //     fontSize: 16.0);
            },
            child: Container(
              alignment: Alignment.center,
              width: ScreenUtil().setWidth(320),
              height: ScreenUtil().setHeight(80),
              color: Colors.red,
              child: Text(
                '清空购物车',
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(28)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
