//import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shop_app_with_firbase/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'products': products.map((e) => e.toJson()).toList(),
        'dateTime': dateTime.toIso8601String(),
      };

  OrderItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        amount = json['amount'],
        products = (json['products'] as List<dynamic>)
            .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        dateTime = DateTime.parse(json['dateTime']);
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProduts) async {
    FirebaseDatabase.instance
        .ref()
        .child('addOrder')
        .child(DateTime.now().millisecondsSinceEpoch.toString())
        .set(OrderItem(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                amount: cartProduts
                    .map((e) => e.price)
                    .toList()
                    .reduce((value, element) => value + element),
                products: cartProduts,
                dateTime: DateTime.now())
            .toJson());

    notifyListeners();
  }
}
