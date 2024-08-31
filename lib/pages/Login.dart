import 'dart:convert';
import 'dart:developer';
import 'package:ecommerce_app/home.dart';
import 'package:ecommerce_app/pages/Register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  String? username, password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  SharedPreferences? prefs;
  @override
  void initState() {
    _loadPreferences();
    super.initState();
  }
  Future<void> _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs?.getBool('isLoggedIn') ?? false;
    if (isLoggedIn && context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }
  Future<void> login(String username, String password) async {
    final Map<String, String> loginData = {
      'username': username,
      'password': password,
    };
    final response = await http.post(
      Uri.parse('http://bootcamp.cyralearnings.com/ecom.login.php'),
      body: loginData,
    );
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody['msg'] == 'success' && context.mounted) {
        await prefs?.setBool('isLoggedIn', true);
        await prefs?.setString('username', username);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        log('Login failed: ${responseBody['message']}');
        // Show login failed message to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${responseBody['message']}')),
        );
      }
    } else {
      log('Error: ${response.statusCode}');
      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed. Please try again.')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 200),
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 28,
                    color: const Color(0xFF0E113A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Login with your username and password',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                       color: Color.fromARGB(255, 232, 229, 229),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Center(
                        child: TextFormField(
                          style: const TextStyle(fontSize: 15),
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Username',
                          ),
                          onChanged: (value) {
                            username = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter your username';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 232, 229, 229),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Center(
                        child: TextFormField(
                          obscureText: true,
                          style: const TextStyle(fontSize: 15),
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Password',
                          ),
                          onChanged: (value) {
                            password = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter your Password';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: const Color(0xFF0E113A),
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          login(username!, password!);
                        }
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const RegistrationPage(),
                          ),
                        );
                      },
                      child: const Text(
                        '  Register',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color(0xFF0E113A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
