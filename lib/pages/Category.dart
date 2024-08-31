import 'dart:developer';
import 'package:ecommerce_app/models/Product.dart';
import 'package:ecommerce_app/webservcis/Webservice.dart';
import 'package:flutter/material.dart';
import 'Details.dart'; // Ensure this import is correct

class CategoryProduct extends StatefulWidget {
  final String catname;
  final int catid;

  CategoryProduct({required this.catid, required this.catname}) : super();

  @override
  _CategoryProductState createState() => _CategoryProductState();
}

class _CategoryProductState extends State<CategoryProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.catname,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: Webservice().fetchProductsByCategory(widget.catid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading products.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found.'));
          } else {
            final products = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.75,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                log(Webservice().imageurl + (product.image ?? ''));
                return InkWell(
                  onTap: () {
                    log("Product clicked");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(
                          image: Webservice().imageurl + (product.image ?? ''),
                          title: product.productname ?? 'No Title',
                          price: product.price ?? 0.0,
                          description: product.description ?? 'No Description',
                          productId: product.id ?? 0,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            constraints: const BoxConstraints(
                              minHeight: 100,
                              maxHeight: 250,
                            ),
                            child: Image.network(
                              Webservice().imageurl + (product.image ?? ''),
                              fit: BoxFit.cover,
                              height: 165,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error); // Error icon
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product.productname ?? 'No Title',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 195, 15, 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
