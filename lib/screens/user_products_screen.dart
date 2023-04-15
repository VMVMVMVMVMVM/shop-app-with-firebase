


import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_with_firbase/providers/product.dart';
import '../providers/product.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import './edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-products';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: StreamBuilder<DatabaseEvent>(
            stream: FirebaseDatabase.instance.ref().child("Products").onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.snapshot.children.length,
                  itemBuilder: (_, i) {
                    Product product = Product.fromJson(jsonDecode(jsonEncode(
                        snapshot.data!.snapshot.children.elementAt(i).value)));
                    return Column(
                      children: [
                        UserProductItem(
                          product.id,
                          product.title,
                          product.imageUrl,
                        ),
                        Divider(),
                      ],
                    );
                  },
                );
              }

              return Container();
            }),
      ),
    );
  }
}
