import 'package:ecommerce_app/provider/provider_class.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting

class OrderDetailsPage extends StatelessWidget {
  final Cart cart;
  final String totalPrice;
  final String datetime;
  final String name;
  final String address;
  final String phone;
  final String paymentMethod;

  const OrderDetailsPage({
    Key? key,
    required this.cart,
    required this.totalPrice,
    required this.datetime,
    required this.name,
    required this.address,
    required this.phone,
    required this.paymentMethod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
        backgroundColor: const Color.fromARGB(255, 244, 239, 239),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(Icons.person, "Name", name),
            _buildDetailRow(Icons.phone, "Phone", phone),
            _buildDetailRow(Icons.location_on, "Address", address),
            _buildDetailRow(Icons.payment, "Payment Method", paymentMethod),
            _buildDetailRow(Icons.attach_money, "Total Price", totalPrice),
            _buildDetailRow(Icons.date_range, "Order Date", _formatDate(datetime)),
            const SizedBox(height: 20),
            const Text(
              "Items Ordered:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Expanded(
              child: cart.getItem.isEmpty
                  ? const Center(child: Text('No items in the cart.'))
                  : ListView.builder(
                      itemCount: cart.getItem.length,
                      itemBuilder: (context, index) {
                        final item = cart.getItem[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                item.imageUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.broken_image, size: 50);
                                },
                              ),
                            ),
                            title: Text(
                              item.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Price: \$${item.price.toStringAsFixed(2)}',
                              style: const TextStyle(color: Color.fromARGB(255, 219, 21, 21)),
                            ),
                            trailing: CircleAvatar(
                              backgroundColor: const Color.fromARGB(255, 127, 129, 129),
                              child: Text(
                                item.quantity.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String datetime) {
    try {
      DateTime date = DateTime.parse(datetime);
      return DateFormat('yyyy-MM-dd – kk:mm').format(date);
    } catch (e) {
      return datetime; // Fallback if parsing fails
    }
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: const Color.fromARGB(255, 78, 80, 79)),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
