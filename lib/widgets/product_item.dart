



import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product.dart';

import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: StreamBuilder<DatabaseEvent>(
                stream: FirebaseDatabase.instance
                    .ref()
                    .child("Favorite Products")
                    .child(product.id)
                    .onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Icon(snapshot.data!.snapshot.exists
                        ? Icons.favorite
                        : Icons.favorite_border);
                  }
                  return Container();
                }),
            onPressed: () {
              FirebaseDatabase.instance
                  .ref()
                  .child("Favorite Products")
                  .child(product.id)
                  .get()
                  .then((value) {
                if (value.exists) {
                  FirebaseDatabase.instance
                      .ref()
                      .child("Favorite Products")
                      .child(product.id)
                      .remove();
                } else {
                  FirebaseDatabase.instance
                      .ref()
                      .child("Favorite Products")
                      .child(product.id)
                      .set(product.toJson());
                }
              });
            },
            color: Theme.of(context).splashColor,
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              FirebaseDatabase.instance
                  .ref()
                  .child("add to cart")
                  .child(product.id)
                  .get()
                  .then((value) {
                if (value.exists) {
                  FirebaseDatabase.instance
                      .ref()
                      .child("add to cart")
                      .child(product.id)
                      .remove();
                } else {
                  FirebaseDatabase.instance
                      .ref()
                      .child("add to cart")
                      .child(product.id)
                      .set(product.toJson());
                }
              });
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Added item to cart!',
                    textAlign: TextAlign.center,
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      //cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).splashColor,
          ),
        ),
      ),
    );
  }
}
