import 'package:ecommerce_app/models/Cart.dart';
import 'package:ecommerce_app/pages/Order.dart';
import 'package:ecommerce_app/pages/Razorpay.dart';
import 'package:ecommerce_app/provider/provider_class.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

class CheckoutPage extends StatefulWidget {
  final String name;
  final String phone;
  final String address;
  final List<CartProductModel> cart;

  const CheckoutPage({
    super.key,
    required this.name,
    required this.phone,
    required this.address,
    required this.cart,
  });

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int selectedValue = 1;
  String paymentMethod = 'Cash on delivery';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context); 
    final vm = Provider.of<Cart>(context, listen: false);

    // Use the values passed from the constructor
    String name = widget.name;
    String phone = widget.phone;
    String address = widget.address;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade100,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "CheckOut",
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        actions: [
          cart.getItem.isEmpty
              ? const SizedBox()
              : IconButton(
                  onPressed: () {
                    cart.clearCart(); // Clear the cart when pressed
                  },
                  icon: const Icon(
                    Icons.delete_forever_rounded,
                    color: Color.fromARGB(255, 56, 55, 55),
                  ),
                ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Name: ",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(name.toString()),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text(
                            "Phone: ",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(phone.toString())
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Address: ",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                          Expanded(
                            child: Text(
                              address,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              RadioListTile<int>(
                activeColor: const Color(0xFF0E113A),
                value: 1,
                groupValue: selectedValue,
                onChanged: (int? value) {
                  setState(() {
                    selectedValue = value!;
                    paymentMethod = 'Cash on delivery';
                  });
                },
                title: const Text('Cash on delivery'),
                subtitle: const Text('Pay Cash At Home'),
              ),
              RadioListTile<int>(
                activeColor: const Color(0xFF0E113A),
                value: 2,
                groupValue: selectedValue,
                onChanged: (int? value) {
                  setState(() {
                    selectedValue = value!;
                    paymentMethod = 'Online';
                  });
                },
                title: const Text('Pay Now'),
                subtitle: const Text('Online Payment'),
              ),
            ],
          ),
        ),
      ),
    bottomSheet: Padding(
  padding: const EdgeInsets.all(8.0),
  child: InkWell(
    onTap: () {
      String datetime = DateTime.now().toString();
      if (paymentMethod == 'Online') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(
              cart: widget.cart,
              amount: cart.totalprice.toString(),
              paymentmethod: paymentMethod.toString(),
              date: datetime.toString(),
              name: name.toString(),
              phone: phone.toString(),
              address: address.toString(),
            ),
          ),
        ).then((paymentSuccess) {
          // if (paymentSuccess == true) {
          //   orderPlace(cart, cart.totalprice.toString(), datetime, name, address, phone, paymentMethod);
          // }
        });
      } else if (paymentMethod == 'Cash on delivery') {
        orderPlace(cart, vm.totalprice.toString(),
         paymentMethod!, datetime, name!, address!, phone!
         );

      
      }
    },
    child: Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF0E113A),
      ),
      child: const Center(
        child: Text(
          "CheckOut",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ),
  ),
),

    );
  }

  // Order placement logic
  void orderPlace(Cart cart, String amount, String date, String name, String address, String phone, String paymentMethod) {
    log('Order placed with details: $name, $address, $phone, $paymentMethod, $amount, $date');
    
    // Clear the cart after placing the order
    cart.clearCart();
    
    // Optionally, navigate to an Order confirmation page or show a confirmation dialog
   
  }
}
