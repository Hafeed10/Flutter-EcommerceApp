class OrderModel {
  int? id;
  String? username;
  double? totalamount;
  String? paymentmethod;
  DateTime? date;
  List<Product>? products;

  OrderModel({
    this.id,
    this.username,
    this.totalamount,
    this.paymentmethod,
    this.date,
    this.products,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json["id"],
        username: json["username"],
        totalamount: json["totalamount"]?.toDouble(),
        paymentmethod: json["paymentmethod"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        products: json["products"] == null
            ? []
            : List<Product>.from(
                json["products"]!.map((x) => Product.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "totalamount": totalamount,
        "paymentmethod": paymentmethod,
        "date": date?.toIso8601String(),
        "products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}

class Product {
  String? productname;
  double? price;
  String? image;
  int? quantity;

  Product({
    this.productname,
    this.price,
    this.image,
    this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productname: json["productname"],
        price: json["price"]?.toDouble(),
        image: json["image"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "productname": productname,
        "price": price,
        "image": image,
        "quantity": quantity,
      };
}