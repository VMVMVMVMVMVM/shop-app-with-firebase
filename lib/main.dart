import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_with_firbase/providers/auth.dart';
import 'package:shop_app_with_firbase/providers/cart.dart';
import 'package:shop_app_with_firbase/providers/orders.dart';
import 'package:shop_app_with_firbase/providers/products.dart';
import 'package:shop_app_with_firbase/screens/auth_screen.dart';
import 'package:shop_app_with_firbase/screens/cart_screen.dart';
import 'package:shop_app_with_firbase/screens/edit_product_screen.dart';
import 'package:shop_app_with_firbase/screens/orders_screen.dart';
import 'package:shop_app_with_firbase/screens/product_detail_screen.dart';
import 'package:shop_app_with_firbase/screens/product_overview_screen.dart';
import 'package:shop_app_with_firbase/screens/user_products_screen.dart';




void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          splashColor: Colors.deepOrange,
          fontFamily: 'Lat',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          AuthScreen.routeName:(ctx) => AuthScreen(),
          ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductScreen.routeName: (ctx) => UserProductScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}

