import 'package:flutter/material.dart';


class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final int quantity;
  bool isFavourite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.isFavourite,
  });


//from Json
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      imageUrl: json['imageUrl'],
      quantity: json['quantity'],
      isFavourite: json['isFavourite'],
    );
  }

//to Json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'isFavourite': isFavourite,
    };
  }

  factory Product.empty() {
    return Product(
      id: '',
      title: '',
      description: '',
      price: 0,
      imageUrl: '',
      quantity: 0,
      isFavourite: false,
    );
  }



  void toggleFavouriteStatus() {
    isFavourite = !isFavourite;
    notifyListeners();
  }
}