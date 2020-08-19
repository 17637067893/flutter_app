import 'package:flutter/material.dart';
import './pages/index_page.dart';
import 'package:provide/provide.dart';
import './provide/counter.dart';
import './provide/categoryProvide.dart';
import 'package:fluro/fluro.dart';
import './routers/routes.dart';
import './routers/application.dart';
import './provide/details_info.dart';
import './provide/cart.dart';
import './provide/currentIndex.dart';

void main() {
  var counter = Counter();
  var categoryProvide = CategoryProvide();
  var detailsInfoProvide = DetailsInfoProvide();
  var currentIndexProvide = CurrentIndexProvide();
  var cartProvide = CartProvide();
  var providers = Providers();

  //初始化 路由
  final router = Router();
  Routes.configureRoutes(router);
  Application.router = router;

  providers
    ..provide(Provider<Counter>.value(counter))
    ..provide(Provider<CategoryProvide>.value(categoryProvide))
    ..provide(Provider<DetailsInfoProvide>.value(detailsInfoProvide))
    ..provide(Provider<CartProvide>.value(cartProvide))
    ..provide(Provider<CurrentIndexProvide>.value(currentIndexProvide));

  runApp(ProviderNode(child: MyApp(), providers: providers));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        title: '小商城',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.pink),
        onGenerateRoute: Application.router.generator,
        home: IndexPage(),
      ),
    );
  }
}
