import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provide/provide.dart';
import '../../provide/cart.dart';
import './cart_count.dart';

class CartItem extends StatelessWidget {
  final item;
  CartItem(this.item);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 2, 5, 2),
      padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      child: Row(
        children: [
          _cartCheckBt(context, item),
          _cartImage(context, item),
          _cartGoodsName(context, item),
          _cartPrice(context, item)
        ],
      ),
    );
  }

  //选按钮
  Widget _cartCheckBt(context, item) {
    return Container(
      child: Checkbox(
        value: item['isCheck'],
        activeColor: Colors.pink,
        onChanged: (bool val) {
          item['isCheck'] = val;
          Provide.value<CartProvide>(context).changeCheckState(item);
        },
      ),
    );
  }

  //商品图片
  Widget _cartImage(context, item) {
    return Container(
      width: ScreenUtil().setWidth(150),
      padding: EdgeInsets.all(5),
      decoration:
          BoxDecoration(border: Border.all(width: 1, color: Colors.black12)),
      child: Image.network(item['goods_img']),
    );
  }

  //商品名称
  Widget _cartGoodsName(context, item) {
    return Container(
      width: ScreenUtil().setWidth(300),
      padding: EdgeInsets.all(10),
      alignment: Alignment.topLeft,
      child: Column(
        children: [Text(item['goods_name']), CartCount(item)],
      ),
    );
  }

  //商品价格
  Widget _cartPrice(context, item) {
    return Container(
      width: ScreenUtil().setWidth(150),
      alignment: Alignment.centerRight,
      child: Column(
        children: <Widget>[
          Text('￥${item["goods_price"]}'),
          Container(
            child: InkWell(
              onTap: () {
                Provide.value<CartProvide>(context).deleteOneGoods(item['id']);
              },
              child: Icon(
                Icons.delete_forever,
                color: Colors.black26,
                size: 30,
              ),
            ),
          )
        ],
      ),
    );
  }
}
