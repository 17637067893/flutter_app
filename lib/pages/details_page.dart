import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/details_info.dart';
import './details_page/details_top_area.dart';
import './details_page/details_explain.dart';
import './details_page/details_tabBar.dart';
import './details_page/details_bottom.dart';

class DetailsPage extends StatelessWidget {
  final String goodsId;
  DetailsPage(this.goodsId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              print('返回上一页');
              Navigator.pop(context);
            },
          ),
          title: Text('商品详细页'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Container(
                child: ListView(
              children: <Widget>[
                DetailsTopArea(),
                DetailsExplain(),
                DetailsTabBar(),
                // DetailsWeb(),
              ],
            )),
            Positioned(bottom: 0, left: 0, child: DetailsBottom())
          ],
        )
        //      FutureBuilder(
        // future: _getBackInfo(context),
        // builder: (context, snapshot) {
        //   if (snapshot.hasData) {
        //     return Stack(
        //       children: [
        //         Container(
        //             child: ListView(
        //           children: <Widget>[
        //             DetailsTopArea(),
        //             DetailsExplain(),
        //             DetailsTabBar(),
        //             // DetailsWeb(),
        //           ],
        //         )),
        //         Positioned(bottom: 0, left: 0, child: DetailsBottom())
        //       ],
        //     );
        //   } else {
        //     return Center(
        //       child: Text('加载中........',
        //           style: TextStyle(fontSize: ScreenUtil().setSp(50))),
        //     );
        //   }
        // })
        );
  }

  Future _getBackInfo(BuildContext context) async {
    await Provide.value<DetailsInfoProvide>(context).getGoodsInfo(goodsId);
    return '完成加载';
  }
}
