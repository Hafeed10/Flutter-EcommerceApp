import 'dart:convert';
import 'dart:developer';
import 'package:ecommerce_app/models/Cart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentScreen extends StatefulWidget {
  final List<CartProductModel> cart;
  final String amount;
  final String paymentmethod;
  final String date;
  final String name;
  final String phone;
  final String address;

  PaymentScreen({
    required this.cart,
    required this.amount,
    required this.paymentmethod,
    required this.date,
    required this.name,
    required this.phone,
    required this.address,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Razorpay? razorpay;
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    razorpay = Razorpay();
    razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    razorpay?.clear();
    super.dispose();
  }

  void _loadUsername() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      username = pref.getString('username');
    });
  }

  void flutterpayment(String orderId, int amount) {
    log('inside working');
    var options = {
      "key": "rzp_test_jcg1B0jek81GzE",
      "amount": amount * 100, // Amount in paise (smallest currency unit)
      "name": "hafeex",
      "currency": "INR",
      "description": "maligai",
      "external": {
        "wallets": ["payment"]
      },
      "retry": {"enabled": true, "max_count": 1},
      "send_sms_hash": true,
      "prefill": {"contact": "7558847558", "email": "hafeexhafe@gmail.com"},
    };
    try {
      log('Initiating payment with options: $options');
      razorpay!.open(options);
    } catch (e) {
      log('Error opening Razorpay: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    log('Payment successful: ${response.paymentId}');
    _orderPlace(response.paymentId.toString());
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    log('Payment Error: ${response.message}, Code: ${response.code}');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment Failed'),
        content: Text('Something went wrong during the payment. Please try again.'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log("External Wallet selected: ${response.walletName}");
  }

  Future<void> _orderPlace(String paymentId) async {
    try {
      String jsondata = jsonEncode(widget.cart);
      log('jsondata=$jsondata');

      final response = await http.post(
        Uri.parse('http://bootcamp.cyralearnings.com/ecom.order.php'),
        body: {
          "username": username,
          "amount": widget.amount,
          "paymentmethod": widget.paymentmethod,
          "date": widget.date,
          "quantity": "1", // Assuming you want to send the quantity
          "cart": jsondata,
          "name": widget.name,
          "address": widget.address,
          "phone": widget.phone,
          "payment_id": paymentId,
        },
      );

      if (response.statusCode == 200) {
        log('Order placed successfully: ${response.body}');
        _showSuccessDialog();
      } else {
        log('Failed to place order: ${response.statusCode}, ${response.body}');
        _showErrorDialog('Failed to place order. Please try again.');
      }
    } catch (e) {
      log('Error: $e');
      _showErrorDialog('An error occurred. Please try again.');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Order Confirmation'),
          content: const Text('Your order has been placed successfully!'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Return to previous screen
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Details'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            flutterpayment("orderId", int.parse(widget.amount));
          },
          child: Text('Pay Now'),
        ),
      ),
    );
  }
}
