import 'package:ecommerce_app/pages/Check_Out.dart';
import 'package:ecommerce_app/provider/provider_class.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Cartpage extends StatefulWidget {
  const Cartpage({super.key});

  @override
  State<Cartpage> createState() => _CartpageState();
}
class _CartpageState extends State<Cartpage> {
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Cart>();

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
          "Cart",
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
                    cart.clearCart();
                  },
                  icon: const Icon(
                    Icons.delete_forever_rounded,
                    color: Color.fromARGB(255, 56, 55, 55),
                  ),
                ),
        ],
      ),
      body: cart.getItem.isEmpty
          ? const Center(
              child: Text(
                "Your cart is empty!",
                style: TextStyle(fontSize: 20, color: Colors.black54),
              ),
            )
          : ListView.builder(
              itemCount: cart.getItem.length,
              itemBuilder: (context, index) {
                final item = cart.getItem[index];

                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: SizedBox(
                      height: 100,
                      child: Row(
                        children: [
                          SizedBox(
                            height: 80,
                            width: 100,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 9),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  item.imageUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                        ),
                                      );
                                    }
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error);
                                  },
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      item.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "\$${item.price}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                        Container(
                                          height: 35,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  if (item.qty == 1) {
                                                    cart.removeItem(item);
                                                  } else {
                                                    cart.decrement(item);
                                                  }
                                                },
                                                icon: const Icon(
                                                  Icons.remove,
                                                  size: 18,
                                                ),
                                              ),
                                              Text(
                                                item.qty.toString(),
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  cart.increment(item);
                                                },
                                                icon: const Icon(
                                                  Icons.add,
                                                  size: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total: \$${cart.totalprice.toString()}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade900,
              ),
            ),
            InkWell(
              onTap: () {
                if (cart.getItem.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                      padding: const EdgeInsets.all(15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      content: const Text(
                        "Cart is empty !!!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutPage(
                        name: 'John Doe',       // Provide required arguments
                        phone: '123-456-7890',
                        address: '123 Main St',
                        cartList: cart.getItem,
                      ),
                    ),
                  );
                }
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width / 2.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFF0E113A),
                ),
                child: const Center(
                  child: Text(
                    "Order Now",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
