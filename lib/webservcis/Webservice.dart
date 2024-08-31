import 'dart:convert';
import 'package:ecommerce_app/models/Category.dart';
import 'package:ecommerce_app/models/Order.dart';
import 'package:ecommerce_app/models/Product.dart';
import 'package:ecommerce_app/models/User.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Webservice {
  final String imageurl = 'https://bootcamp.cyralearnings.com/products/';
  // ignore: prefer_const_declarations
  static final String mainurl = 'http://bootcamp.cyralearnings.com';
  final String baseUrl = 'http://bootcamp.cyralearnings.com';
  // Fetch categories
  Future<List<CategoryModel>> fetchCategory() async {
    final response = await http.get(Uri.parse('http://bootcamp.cyralearnings.com/ecom.getcategories.php'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => CategoryModel.fromJson(json)).toList();  // Convert JSON to List<CategoryModel>
    } else {
      throw Exception('Failed to load categories');
    }
  }
  // Fetch offer products
  Future<List<ProductModel>> fetchOfferProducts() async {
    final response = await http.get(Uri.parse('http://bootcamp.cyralearnings.com/ecom.view_offerproducts.php'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) =>ProductModel.fromJson(json)).toList();  // Convert JSON to List<ProdutModel>
    } else {
      throw Exception('Failed to load offer products');
    }
  }
 Future<List<ProductModel>> fetchProductsByCategory(int catid) async {
  final response = await http.post(
    Uri.parse(baseUrl + '/ecom.get_category_products.php'),
    body: {'catid': catid.toString()}, // Corrected conversion to string
  );
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => ProductModel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load category products');
  }
}
Future<List<OrderModel>> fetchOrderDetails(String username) async {
    try {
      final response = await http.post(
        Uri.parse('http://bootcamp.cyralearnings.com/ecom.get_orderdetails.php'),
        body: {"username": username},
      );
      if (response.statusCode == 200) {
        final productJson = json.decode(response.body);
        return productJson
            .map<OrderModel>((json) => OrderModel.fromJson(json))
            .toList();
      } else {
        throw Exception(
            'API request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching Order products: $e');
    }
  }
   Future<UserModel> fetchUser(String username) async {
    try {
      final response = await http.post(
        Uri.parse('http://bootcamp.cyralearnings.com/ecom.get_user.php'),
        body: {"username": username},
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'API request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching User details: $e');
    }
  }
}
