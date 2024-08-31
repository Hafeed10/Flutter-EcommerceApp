import 'package:ecommerce_app/home.dart';
import 'package:ecommerce_app/pages/Cart.dart';
import 'package:ecommerce_app/pages/Login.dart';
import 'package:ecommerce_app/pages/Order.dart';
import 'package:ecommerce_app/provider/provider_class.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:badges/badges.dart' as badges;

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});
  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}
class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Cart>();
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 50),
          Align(
            alignment: Alignment.center,
            child: const Text(
              "E-COMMERCE",
              style: TextStyle(
                color: Color(0xFF0E113A),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text(
              'Home',
              style: TextStyle(fontSize: 15.0),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          ListTile(
            leading: badges.Badge(
              showBadge: cart.getItem.isNotEmpty,
              badgeColor: Colors.red,
              badgeContent: Text(
                cart.getItem.length.toString(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              child: const Icon(
                Icons.shopping_cart,
                size: 15,
                color: Colors.black,
              ),
            ),
            title: const Text(
              'Cart',
              style: TextStyle(fontSize: 15.0),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Cartpage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.book_online),
            title: const Text(
              "Order Details",
              style: TextStyle(fontSize: 15.0),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailsPage(
                    cart: cart,
                    totalPrice: cart.totalprice.toString(),
                    datetime: DateTime.now().toString(), // Replace with your actual date logic
                    name: "User Name", // Replace with actual user's name
                    address: "User Address", // Replace with actual user's address
                    phone: "User Phone", // Replace with actual user's phone
                    paymentMethod: "Payment Method", // Replace with actual payment method
                  ),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.power_settings_new_rounded),
            title: const Text(
              "Logout",
              style: TextStyle(fontSize: 15.0),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
              color: Colors.black,
            ),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool("isLoggedIn", false);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
