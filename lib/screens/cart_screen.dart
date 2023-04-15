

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart' show Cart;

import 'package:shop_app_with_firbase/widgets/cart_item.dart';
import '../providers/product.dart';
import '../providers/orders.dart';


class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    var title;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.pink,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Spacer(),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
                stream: FirebaseDatabase.instance
                    .ref()
                    .child("add to cart")
                    .onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Product> products =
                    snapshot.data!.snapshot.children.map((e) {
                      return Product.fromJson(jsonDecode(jsonEncode(e.value)));
                    }).toList();
                    return ListView.builder(
                      itemBuilder: (ctx,i) => CartItem(
                        DateTime.now()
                            .millisecondsSinceEpoch
                            .toString(), //1 Jan 1970
                        products[i].id,
                        products[i].price,
                        products[i].quantity,
                        products[i].title,
                      ),
                      itemCount: products.length,
                    );
                  }
                  return Container();
                }),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
        onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
            ? null
            : () async {
          setState(() {
            _isLoading = true;
          });
          //  await Provider.of<Orders>(context, listen: false).addOrder(
          //widget.Products(),

          // );
          setState(() {
            _isLoading = false;
          });
          widget.cart.clear();
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
        ));
  }
}
