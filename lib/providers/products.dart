
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:shop_app_with_firbase/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'blue t-shirt',
      description: 'blue t-shirt - its pretty good',
      price: 650,
      imageUrl:
      'https://media.istockphoto.com/photos/handsome-man-in-black-tshirt-picture-id517998640?b=1&k=20&m=517998640&s=170667a&w=0&h=8NntV4vxG4KdBEUfeWhPaDR3IIye92MIBYzhzdym9Kk=',
      isFavourite: false,
      quantity: 1,
    ),
    Product(
      id: 'p2',
      title: 'grey t-shirt',
      description: 'grey t-shirt - its pretty good',
      price: 600,
      imageUrl:
      'https://media.istockphoto.com/photos/hispanic-man-posing-with-a-casual-gray-tshirt-picture-id1307504291?b=1&k=20&m=1307504291&s=170667a&w=0&h=rCq6V1lh1ZXArXoMQ5K418d7KdqKijUcXwWDS3iuE20=',
      isFavourite: false,
      quantity: 1,
    ),
    Product(
      id: 'p3',
      title: 'yellow t-shirt',
      description: 'yellow t-shirt - its pretty good',
      price: 700,
      imageUrl:
      'https://media.istockphoto.com/photos/man-yellow-tshirt-picture-id674454186?b=1&k=20&m=674454186&s=170667a&w=0&h=HObiJvtbA9YHb3LR3Nfl8iPsfqX89YpiP5_Z0EVDEis=',
      isFavourite: false,
      quantity: 1,
    ),
    Product(
      id: 'p4',
      title: 'white t-shirt',
      description: 'white t-shirt - its pretty good',
      price: 680,
      imageUrl:
      'https://media.istockphoto.com/photos/tshirt-design-and-people-concept-close-up-of-young-man-in-blank-white-picture-id1138400603?b=1&k=20&m=1138400603&s=170667a&w=0&h=8mvAdXp8Yum3igeLP_MJI5Z4Nh6g48m7dD6BgS228Vc=',
      isFavourite: false,
      quantity: 1,
    ),
    Product(
      id: 'p5',
      title: 'green t-shirt',
      description: 'green t-shirt - its pretty good',
      price: 720,
      imageUrl:
      'https://media.istockphoto.com/photos/man-posing-with-blank-green-shirt-picture-id515838111?b=1&k=20&m=515838111&s=170667a&w=0&h=hGRKlmoABCpJesSdRMU7o6RVygpS8YWitpMl93IJFDM=',
      isFavourite: false,
      quantity: 1,
    ),
  ];

  var _showFavouritesOnly = false;

  List<Product> get items {
    // if(_showFavouritesOnly){
    // return _items.where((prodItem) => prodItem.isFavourite).toList();
    // }
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((prodItem) => prodItem.isFavourite).toList();
  }

  Future<Product> findById(String id) async {
    Product findProduct = Product.empty();
    await FirebaseDatabase.instance
        .ref()
        .child('Products')
        .child(id)
        .get()
        .then((value) {
      Product product = Product.fromJson(jsonDecode(jsonEncode(value.value)));
    });
    return findProduct;
  }

  //void showFavouritesOnly(){
  //_showFavouritesOnly = true;
  //notifyListeners();
  //}
  //void showAll(){
  // _showFavouritesOnly = false;
  //notifyListeners();
  //}
  /*Future<void>fetchAndSetProducts() async {

    const url = 'https://shop-app-e1d14-default-rtdb.firebaseio.com';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body)as Map<String,dynamic>;
      final List<Products> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
       loadedProducts.add(Product(
         id: prodId,
         title: prodData['title'],
         description: prodData['description'],
         price: prodData['price'],
         imageUrl: prodData['imageUrl'],
         quantity: prodData['quantity'],
         isFavourite: prodData['isFavourite'],
        ));
      });
      _items = loadedProducts.cast<Product>();
      notifyListeners();
    }catch(error) {
      throw(error);
    }
  }*/

  Future<void> addProduct(Product product) async {
    // FirebaseDatabase.instance.ref().child('products').child(id).
    const url = 'https://shop-app-e1d14-default-rtdb.firebaseio.com/Products';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavourite': product.isFavourite,
        }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        isFavourite: product.isFavourite,
        id: json.decode(response.body)['name'],
        quantity: product.quantity,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    FirebaseDatabase.instance.ref().child('products').child(id).update({
      'title': newProduct.title,
      'description': newProduct.description,
      'imageUrl': newProduct.imageUrl,
      'price': newProduct.price
    });
  }

  Future<void> deleteProduct(String id) async {
    FirebaseDatabase.instance.ref().child('Products').child(id).remove();
  }
}
