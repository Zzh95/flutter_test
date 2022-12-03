import 'package:flutter/material.dart';

import 'model/cart_model.dart';
import 'util/change_notifier_provider.dart';

class ProviderRoute extends StatefulWidget {
  const ProviderRoute({Key? key}) : super(key: key);

  @override
  _ProviderRouteState createState() => _ProviderRouteState();
}

class _ProviderRouteState extends State<ProviderRoute> {
  @override
  Widget build(BuildContext context) {
    print("最外层build");
    return ChangeNotifierProvider<CartModel>(
        data: CartModel(),
        child:providerChildWidget()
        // Builder(builder: (context) {
        //   print("主 build");
        //   return Scaffold(
        //     body:  Container(
        //       width: double.infinity,
        //       height: double.infinity,
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: <Widget>[
        //           Builder(builder: (context) {
        //             print("价格 build");
        //             var cart = ChangeNotifierProvider.of<CartModel>(context);
        //             return Text("总价: ${cart.totalPrice}");
        //           }),
        //           Builder(builder: (context) {
        //             print("ElevatedButton build"); //在后面优化部分会用到
        //             return ElevatedButton(
        //               child: const Text("添加商品"),
        //               onPressed: () {
        //                 //给购物车中添加商品，添加后总价会更新
        //                 ChangeNotifierProvider.of<CartModel>(context,listen: false)
        //                     .add(Item(20.0, 1));
        //               },
        //             );
        //           }),
        //         ],
        //       ),
        //     ),
        //   );
        // }),
    );
  }
  Widget providerChildWidget(){
    print("主2build");
    return Scaffold(
          body:  Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Builder(builder: (context) {
                  print("价格 build");
                  var cart = ChangeNotifierProvider.of<CartModel>(context);
                  return Text("总价: ${cart.totalPrice}");
                }),
                Builder(builder: (context) {
                  print("ElevatedButton build"); //在后面优化部分会用到
                  return ElevatedButton(
                    child: const Text("添加商品"),
                    onPressed: () {
                      //给购物车中添加商品，添加后总价会更新
                      ChangeNotifierProvider.of<CartModel>(context,listen: false)
                          .add(Item(20.0, 1));
                    },
                  );
                }),
              ],
            ),
          ),
        );

  }
}
