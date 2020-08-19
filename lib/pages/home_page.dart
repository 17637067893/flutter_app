import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provide/provide.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import '../provide/details_info.dart';
import '../routers/application.dart';
import '../provide/currentIndex.dart';

int currentpage = 1;
List hotGoodsList = [];

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('小商城'),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: request('homePageContext'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // var data = json.decode(snapshot.data.toString());
              //轮播图
              List swiperDataList = snapshot.data['swiper'];
              //tab导航
              List navigatorList = snapshot.data['tabs'];
              //推荐商品
              List recommendList = snapshot.data['recommendList'];
              return EasyRefresh(
                footer: MaterialFooter(),
                child: ListView(
                  children: <Widget>[
                    SwiperDiy(swiperDataList: swiperDataList), //页面顶部轮播组件
                    TopNavigator(navigatorList: navigatorList), //tab导航
                    AdBanner(
                      picture:
                          'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1597732618895&di=ba3b48bb54d976fc212bd5c10b66c2c3&imgtype=0&src=http%3A%2F%2Fwww.drug-impurity.com%2FPublic%2FHome%2FImages%2Fneibanner.jpg',
                    ),
                    LeaderPhoone(
                        leaderImage:
                            'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1597732912274&di=4121db6b3f363a8b94f7c1d2fbf883c4&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201707%2F05%2F20170705095126_B85vd.jpeg',
                        leaderPhone: '17637067893'),
                    //推荐商品
                    Recommend(recommendList: recommendList),
                    //楼层商品
                    FloorContent(floorGoodsList: recommendList),
                    //火爆商品
                    HotGoods()
                  ],
                ),
                onLoad: () async {
                  print('开始加载更多');
                  await request('homePageBelowConten', {'page': currentpage})
                      .then((val) {
                    setState(() {
                      currentpage += 1;
                      hotGoodsList.addAll(val['hotGoods']['data']);
                      print(hotGoodsList.length);
                    });
                  });
                },
              );
            } else {
              return Center(
                child: Text(
                  '加载中...',
                  style: TextStyle(fontSize: 30, color: Colors.black38),
                ),
              );
            }
          },
        ));
  }
}

// 首页轮播组件编写
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;
  SwiperDiy({Key key, this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.network("${swiperDataList[index]['img']}",
              fit: BoxFit.fill);
        },
        itemCount: swiperDataList.length,
        pagination: new SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

//tab导航栏
class TopNavigator extends StatelessWidget {
  final List navigatorList;
  // TopNavigator(this.navigatorList);
  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItemUi(BuildContext context, item) {
    return InkWell(
      onTap: () {
        print('点击了导航');
      },
      child: Column(
        children: <Widget>[
          Image.network(
            item['img'],
            width: ScreenUtil().setWidth(100),
            height: ScreenUtil().setHeight(100),
          ),
          Text(item['title'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(420),
      padding: EdgeInsets.all(3),
      child: GridView.count(
        physics: new NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        padding: EdgeInsets.all(4),
        //  children 使用map循环 然后再用toList()转换
        children: navigatorList.map((item) {
          return _gridViewItemUi(context, item);
        }).toList(),
      ),
    );
  }
}

// 广告送达
class AdBanner extends StatelessWidget {
  final String picture;
  const AdBanner({Key key, this.picture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(100),
      width: ScreenUtil().setWidth(750),
      child: Image.network(
        picture,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}

//打电话
class LeaderPhoone extends StatelessWidget {
  final String leaderImage;
  final String leaderPhone;
  const LeaderPhoone({Key key, this.leaderImage, this.leaderPhone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 100, right: 100),
      height: ScreenUtil().setHeight(150),
      child: InkWell(
        child: Image.network(
          leaderImage,
          fit: BoxFit.fill,
        ),
        onTap: () {
          _makePhoneCall('tel:$leaderPhone');
        },
      ),
    );
  }

  //打电话
  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

//商品推荐
class Recommend extends StatelessWidget {
  final List recommendList;
  const Recommend({Key key, this.recommendList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(400),
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          _titleWidget(),
          _recommedList(),
        ],
      ),
    );
  }

  //商品推荐title
  Widget _titleWidget() {
    return Container(
      width: ScreenUtil().setWidth(750),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 0.5, color: Colors.black12))),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  // 商品推荐item
  Widget _item(item) {
    return InkWell(
        onTap: () {},
        child: Container(
          height: ScreenUtil().setHeight(330),
          width: ScreenUtil().setWidth(250),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(left: BorderSide(width: 1, color: Colors.black12))),
          child: Column(
            children: <Widget>[
              Image.network(
                item['goods_img'],
                fit: BoxFit.fill,
                height: 90,
              ),
              Text("￥${item['goods_price']}"),
              Text(
                "￥${item['goods_malprice']}",
                style: TextStyle(
                    decoration: TextDecoration.lineThrough, color: Colors.grey),
              )
            ],
          ),
        ));
  }

  //横向列表
  Widget _recommedList() {
    return Container(
      height: ScreenUtil().setHeight(330),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context, index) {
          return _item(recommendList[index]);
        },
      ),
    );
  }
}

// 楼层标题
class FloorTitle extends StatelessWidget {
  final String picture_address;
  const FloorTitle({Key key, this.picture_address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Image.network(picture_address),
    );
  }
}
//楼层商品列表

class FloorContent extends StatelessWidget {
  final List floorGoodsList;
  const FloorContent({Key key, this.floorGoodsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _firstRow(context, floorGoodsList),
          _otherGoods(context, floorGoodsList),
          _firstRow1(context, floorGoodsList),
          _otherGoods2(context, floorGoodsList)
        ],
      ),
    );
  }

  //楼层Item
  Widget _goodsItem1(context, item) {
    return Container(
      width: ScreenUtil().setWidth(375),
      padding: EdgeInsets.all(10),
      child: InkWell(
          onTap: () {
            Application.router.navigateTo(context, "/detail?id=${item['id']}");
          },
          child: Image.network(
            item['goods_img'],
            fit: BoxFit.fill,
            height: ScreenUtil().setHeight(700),
          )),
    );
  }

  //楼层Item
  Widget _goodsItem2(context, item) {
    return Container(
      padding: EdgeInsets.all(10),
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: () {
          print('点击楼层商品');
        },
        child: Expanded(
            child: Image.network(
          item['goods_img'],
          fit: BoxFit.fill,
          height: ScreenUtil().setHeight(300),
        )),
      ),
    );
  }

  Widget _firstRow(context, floorGoodsList) {
    return Row(
      children: [
        _goodsItem1(context, floorGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem2(context, floorGoodsList[1]),
            _goodsItem2(context, floorGoodsList[2]),
          ],
        )
      ],
    );
  }

  Widget _otherGoods(context, floorGoodsList) {
    return Row(
      children: [
        _goodsItem2(context, floorGoodsList[3]),
        _goodsItem2(context, floorGoodsList[4]),
      ],
    );
  }

  Widget _firstRow1(context, floorGoodsList) {
    return Row(
      children: [
        _goodsItem1(context, floorGoodsList[5]),
        Column(
          children: <Widget>[
            _goodsItem2(context, floorGoodsList[6]),
            _goodsItem2(context, floorGoodsList[7]),
          ],
        )
      ],
    );
  }

  Widget _otherGoods2(context, floorGoodsList) {
    return Row(
      children: [
        _goodsItem2(context, floorGoodsList[8]),
        _goodsItem2(context, floorGoodsList[9]),
      ],
    );
  }
}

//火爆专区
class HotGoods extends StatefulWidget {
  @override
  _HotGoodsState createState() => _HotGoodsState();
}

class _HotGoodsState extends State<HotGoods> {
  @override
  void initState() {
    super.initState();
    _getHotGoods();
  }

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [HotTitle, _WrapList()],
      ),
    );
  }

  _getHotGoods() {
    print('6');
    request('homePageBelowConten', {'page': currentpage}).then((val) {
      // print(val['hotGoods']['current_page'] + 1);
      // print(val['hotGoods']['data']);
      setState(() {
        currentpage += 1;
        hotGoodsList.addAll(val['hotGoods']['data']);
        print(hotGoodsList.length);
      });
    });
  }

  Widget HotTitle = Container(
    margin: EdgeInsets.only(top: 10, bottom: 10),
    alignment: Alignment.center,
    color: Colors.transparent,
    child: Text(
      '火爆专区',
      style: TextStyle(color: Colors.pink),
    ),
  );

  Widget _WrapList() {
    if (hotGoodsList.length > 0) {
      List<Widget> listWidget = hotGoodsList.map((item) {
        return InkWell(
          onTap: () {
            Application.router.navigateTo(context, "/detail?id=${item['id']}");
          },
          child: Container(
            width: ScreenUtil().setWidth(370),
            color: Colors.white,
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(bottom: 3),
            child: Column(
              children: [
                Image.network(
                  item['goods_img'],
                  width: ScreenUtil().setWidth(370),
                  height: ScreenUtil().setHeight(200),
                ),
                Text(
                  item['goods_name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.pink, fontSize: ScreenUtil().setSp(26)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "￥${item['goods_price']}",
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "￥${item['goods_malprice']}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black12,
                          decoration: TextDecoration.lineThrough),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();
      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    } else {
      return Text('');
    }
  }
}
