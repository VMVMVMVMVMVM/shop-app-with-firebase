
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../providers/orders.dart';
import '../widgets/app_drawer.dart';
import '../widgets/orders_item.dart';
import 'package:shop_app_with_firbase/widgets/app_drawer.dart';


class OrdersScreen extends StatelessWidget {
  static const routeName = '/Orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Orders')),
      drawer: AppDrawer(),
      body: StreamBuilder<DatabaseEvent>(
          stream: FirebaseDatabase.instance.ref().child('addOrder').onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<OrderItem> orderData = snapshot.data!.snapshot.children
                  .map((e) =>
                  OrderItem.fromJson(jsonDecode(jsonEncode(e.value))))
                  .toList();
              return ListView.builder(
                itemBuilder: (ctx, i) => OrderItemWidget(orderData[i]),
                itemCount: orderData.length,
              );
            }
            return Container();
          }),
    );
  }
}
