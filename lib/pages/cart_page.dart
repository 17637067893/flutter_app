import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provide/provide.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provide/cart.dart';
import './cart_page/cart_bottom.dart';
import './cart_page/cart_item.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('购物车'),
        centerTitle: true,
      ),
      body: Provide<CartProvide>(
        builder: (context, child, value) {
          return Stack(
            children: [
              value.cartList.length > 0
                  ? ListView.builder(
                      itemBuilder: (context, index) {
                        return CartItem(value.cartList[index]);
                      },
                      itemCount: value.cartList.length)
                  : Center(
                      child: Text(
                        '空空如也',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(100),
                            color: Colors.black26),
                      ),
                    ),
              Positioned(
                bottom: 0,
                left: 0,
                child: CartBottom(),
              )
            ],
          );
        },
      ),
    );
  }
}
