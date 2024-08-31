// File: produtmodel.dart
class ProductModel {
  final String? image;
  final String? productname;
  final double? price;
  final String? description;
  final int? id;
  var Description;

  ProductModel({
    this.image,
    this.productname,
    this.price,
    this.description,
    this.id,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      image: json['image'],
      productname: json['productname'],
      description: json['description'],
      price: json ['price'],
      id: json['id'],
    );
  }
}
