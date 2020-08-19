import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:shopApp/pages/home_page.dart';
import '../service/service_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../Provide/child_category.dart';
import '../provide/categoryProvide.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../routers/application.dart';
import '../provide/details_info.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);
  //左侧选中按钮

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List tabList = [];
  int listIndex = 0;
  @override
  void initState() {
    super.initState();
    _getTabs();
    var obj = {'id': 1};
    _childTabs(obj);
    _getGoodsList(1, '');
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商品分类'),
        centerTitle: true,
      ),
      body: Container(
        child: Row(
          children: [
            Container(
              width: ScreenUtil().setWidth(180),
              decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(width: 1, color: Colors.black12))),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return _leftInkWell(tabList[index], index);
                },
                itemCount: tabList.length,
              ),
            ),
            Column(
              children: [
                RightCategoryNav(),
                Expanded(child: CategoryGoodsList())
              ],
            )
          ],
        ),
      ),
    );
  }

  // 左侧tabs
  _getTabs() {
    request('homePageContext').then((val) {
      print(val['tabs']);
      setState(() {
        tabList.addAll(val['tabs']);
      });
    });
  }

  // 右侧tabs
  _childTabs(item) {
    request('childTabs', {'id': item['id']}).then((val) {
      List list = [
        {'title': '全部', 'parentId': item['id']}
      ];

      list.addAll(val['child_tab']);
      Provide.value<CategoryProvide>(context).getChildTabs(list);
    });
  }

  // 商品列表goodsList
  _getGoodsList(parentId, id) {
    request('goodsList', {'parentId': parentId, 'id': id}).then((val) {
      Provide.value<CategoryProvide>(context).getGoodsList(val);
    });
  }

  Widget _leftInkWell(item, int index) {
    bool isClick = false;
    isClick = (index == listIndex) ? true : false;
    return InkWell(
      onTap: () {
        _childTabs(item);
        _getGoodsList(item['id'], '');
        Provide.value<CategoryProvide>(context).changeChildIndex(0);
        setState(() {
          listIndex = index;
        });
        print(isClick);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: isClick ? Colors.pink : Colors.white,
            // borderRadius: BorderRadius.circular(1),
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: Text(
          item['title'],
          style: TextStyle(fontSize: ScreenUtil().setSp(40)),
        ),
      ),
    );
  }
}

//右侧
class RightCategoryNav extends StatefulWidget {
  RightCategoryNav({Key key}) : super(key: key);

  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(80),
      width: ScreenUtil().setWidth(570),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      child: Provide<CategoryProvide>(
        builder: (context, child, val) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return _rightInkWell(val.childList[index], index);
            },
            itemCount: val.childList.length,
          );
        },
      ),
    );
  }

  // 商品列表goodsList
  _getGoodsList(parentId, id) {
    request('goodsList', {'parentId': parentId, 'id': id}).then((val) {
      Provide.value<CategoryProvide>(context).getGoodsList(val);
    });
  }

  Widget _rightInkWell(item, index) {
    bool isCheck = false;
    isCheck = (index == Provide.value<CategoryProvide>(context).childIndex)
        ? true
        : false;
    return InkWell(
      onTap: () {
        print(item['parentId']);
        print(item['id']);
        _getGoodsList(item['parentId'], item['id']);
        Provide.value<CategoryProvide>(context).changeChildIndex(index);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: BoxDecoration(
            color: isCheck ? Colors.pink : Colors.white,
            border: Border(right: BorderSide(width: 1, color: Colors.black12))),
        child: Text(
          "${item['title']}",
          style: TextStyle(fontSize: ScreenUtil().setSp(30)),
        ),
      ),
    );
  }
}
//商品列表

class CategoryGoodsList extends StatefulWidget {
  CategoryGoodsList({Key key}) : super(key: key);

  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {
  @override
  Widget build(BuildContext context) {
    return Provide<CategoryProvide>(builder: (context, child, val) {
      if (val.goodsList.length > 0) {
        return Container(
          width: ScreenUtil().setWidth(570),
          height: ScreenUtil().setHeight(1000),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return _ListWidget(val.goodsList[index]);
            },
            itemCount: val.goodsList.length,
          ),
        );
      } else {
        return Center(
          child: Text('暂时没有数据'),
        );
      }
    });
  }

  //商品图片
  Widget _goodsImage(item) {
    return Container(
      width: ScreenUtil().setWidth(200),
      // child: ImageWidget(url: item['goods_img'], w: 100, h: 100));
      child: Image.network(item['goods_img']),
      height: ScreenUtil().setHeight(150),
    );
  }

  //商品名字
  Widget _goodsName(item) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      width: ScreenUtil().setWidth(370),
      child: Text(
        "${item['goods_name']}",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }

  //商品价格
  Widget _goodsPrice(item) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.only(left: 10),
      width: ScreenUtil().setWidth(370),
      child: Row(
        children: [
          Text(
            "价格:￥${item['goods_price']}",
            style:
                TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(30)),
          ),
          Text(
            "￥${item['goods_price']}",
            style: TextStyle(
                color: Colors.black26, decoration: TextDecoration.lineThrough),
          ),
        ],
      ),
    );
  }

  Widget _ListWidget(item) {
    return InkWell(
      onTap: () async {
        Provide.value<DetailsInfoProvide>(context).getGoodsInfo(item);
        await Application.router
            .navigateTo(context, "/detail?id=${item['id']}");
        // Provide.value<DetailsInfoProvide>(context).getGoodsInfo(item['id']);
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
        padding: EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: Row(
          children: [
            _goodsImage(item),
            Column(
              children: [
                _goodsName(item),
                _goodsPrice(item),
              ],
            )
          ],
        ),
      ),
    );
  }
}
