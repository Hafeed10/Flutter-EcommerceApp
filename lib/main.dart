import 'package:ecommerce_app/home.dart';
import 'package:ecommerce_app/pages/Login.dart';
import 'package:ecommerce_app/provider/provider_class.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Cart()),
    ],
    child: const MyApp(),
  ));
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? loggedIn = prefs.getBool('isLoggedIn');
    setState(() {
      isLoggedIn = loggedIn ?? false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ecommerce APP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 215, 230, 11),
        ),
        useMaterial3: true,
      ),
      home: isLoggedIn ? const HomePage() : const LoginPage(),
    );
  }
}
