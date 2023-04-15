
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_with_firbase/widgets/product_item.dart';

import '../providers/product.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    /*final productsData = Provider.of<Products>(context);
    final products = showFavs? productsData.favouriteItems : productsData.items;*/

    return StreamBuilder<DatabaseEvent>(
        stream: FirebaseDatabase.instance.ref().child('Products').onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Product> products = snapshot.data!.snapshot.children
                .map((e) => Product.fromJson(jsonDecode(jsonEncode(e.value))))
                .toList();
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: products.length,
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                value: products[i],
                child: ProductItem(product: products[i]),
              ),
            );
          }
          return Container();
        });
  }
}
