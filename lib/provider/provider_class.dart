import 'dart:math';
import 'package:ecommerce_app/models/Cart.dart';
import 'package:flutter/material.dart';

class Cart extends ChangeNotifier {
  final List<CartProductModel> _list = [];
  var total;
  void addItem(
    int id,
    String name,
    double price,
    int qty,
    String imageUrl,
  ){
    final product = CartProductModel(id: id, name: name, price: price, imageUrl: imageUrl);
    _list.add(product);
    notifyListeners();
    log("add product !!!!!!!!" as num);
  }
  List<CartProductModel> get getItem {
    return _list;
  }
  int? get count {
    return _list.length;
  }
  void increment(CartProductModel product) {
    product.increase();
    notifyListeners();
  }
  void reduceByOne(CartProductModel product){
    product.decrease();
    notifyListeners();
  }
  void removeItem(CartProductModel product){
    _list.remove(product);
    notifyListeners();
  }
  void clearCart(){
    _list.clear();
    notifyListeners();
  }
  double get totalprice {
    var total = 0.0;
    for (var item in _list){
      total = total + (item.price * item.qty);
    }return total;
  }
  void decrement(CartProductModel item) {}

  void markAsPurchased() {}
}