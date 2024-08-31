import 'dart:ui';
import 'dart:developer';
import 'dart:convert'; // Import for JSON decoding
import 'package:ecommerce_app/models/Category.dart';
import 'package:ecommerce_app/models/Product.dart';
import 'package:ecommerce_app/pages/Category.dart';
import 'package:ecommerce_app/pages/Details.dart';
import 'package:ecommerce_app/webservcis/Webservice.dart';
import 'package:ecommerce_app/widget/Drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http; // Import http package


class YourWidget extends StatefulWidget {
  const YourWidget({Key? key}) : super(key: key);
  @override
  _YourWidgetState createState() => _YourWidgetState();
}
class _YourWidgetState extends State<YourWidget> {
  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }
  void _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      log('isLoggedIn = $isLoggedIn');
      if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    } catch (e) {
      log('Error loading preferences: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Widget')),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        toolbarHeight: 60,
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFF0E113A),
        title: const Text(
          'E-COMMERCE APP',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Category",
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF131313),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            FutureBuilder<List<CategoryModel>>(
              future: Webservice().fetchCategory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No categories found.'));
                } else {
                  return SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final category = snapshot.data![index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              log("Category clicked");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CategoryProduct(
                                    catid: category.id!,
                                    catname: category.category!,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0x25050227),
                              ),
                              child: Center(
                                child: Text(
                                  category.category!,
                                  style: const TextStyle(
                                    color: Color(0xFF1A1A1E),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Offer Products",
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF131313),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<ProductModel>>(
                future: Webservice().fetchOfferProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No offer products found.'));
                  } else {
                    final products = snapshot.data!;
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                       
                        crossAxisCount: 2,
                        // mainAxisSpacing: 8,
                        // crossAxisSpacing: 8,
                      ),
                     itemCount:snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final product = snapshot.data![index];
                        log( Webservice().imageurl + product.image!);
                        return InkWell(
                          onTap: () {
                            log("Product clicked");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsPage(
                                  image: Webservice().imageurl + product.image!, // Correct URL construction
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    constraints: const BoxConstraints(
                                      minHeight: 100,
                                      maxHeight: 250,
                                    ),
                                    child: Image.network(
                                       Webservice().imageurl + product.image!,
                                      fit: BoxFit.cover,
                                      // width: double.infinity,
                                      height: 165,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(Icons.error); // Display an error icon or placeholder image
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
            ),
          ],
        ),
      ),
    );
  }
}



