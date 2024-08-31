import 'package:flutter/foundation.dart';

class CartProductModel {
  int id;
  String name;
  double price;
  int qty;
  String imageUrl;
  // Constructor with `qty` initialized to 1 by default
  CartProductModel({
    required this.id,
    required this.name,
    required this.price,
    this.qty = 1, // Initialize qty with a default value of 1
    required this.imageUrl,
  });
  // Factory method to create an instance of CartProductModel from JSON
  factory CartProductModel.fromJson(Map<String, dynamic> json) {
    return CartProductModel(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(), // Ensure price is a double
      qty: json['qty'] ?? 1, // Use the provided qty or default to 1
      imageUrl: json['imageUrl'],
    );
  }
  String? get image => null;

  get quantity => null;
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'qty': qty,
    'imageUrl': imageUrl,
  };
  void increase() {
  qty++;
  }
  void decrease(){
    qty--;

  }
}
