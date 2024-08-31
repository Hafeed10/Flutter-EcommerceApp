import 'dart:convert';
import 'dart:developer';
import 'package:ecommerce_app/home.dart';
import 'package:ecommerce_app/pages/Login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});
  @override
  State<RegistrationPage> createState() => _RegisterPageState();
}
class _RegisterPageState extends State<RegistrationPage> {
  String? name, phone, address, username, password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  SharedPreferences? pref;
  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }
  Future<void> _loadPreferences() async {
    pref = await SharedPreferences.getInstance();
  }
  Future<void> setPref() async {
    if (pref != null) {
      await pref!.setBool('isLoggedIn', true);
      await pref!.setString('username', username!);
    }
  }
  Future<void> register(String name, String phone, String address, String username, String password) async {
  final Map<String, dynamic> registrationData = {
    'name': name,
    'phone': phone,
    'address': address,
    'username': username,
    'password': password,
  };
  try {
    final response = await http.post(
      Uri.parse('http://bootcamp.cyralearnings.com/ecom.registration.php'),
      body: registrationData,
    );
    print('Response status code: ${response.statusCode}');
   log('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
       print('Registration successfully completed');
      if (responseBody['msg'] == 'success' && context.mounted) {
        log('Registration successfully completed');
        await setPref();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        log('Registration failed: ${responseBody['message']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${responseBody['message']}')),
        );
      }
    } else {
      log('Server error: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Server error. Please try again.')),
      );
    }
  } catch (e) {
    log('Exception occurred: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred. Please try again.')),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Text(
              'Register Account',
              style: TextStyle(
                fontSize: 28,
                color: const Color(0xFF0E113A),
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text('Complete your details \n'),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
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
                              hintText: 'Name',
                            ),
                            onChanged: (value) {
                              name = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter your Name';
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
                            style: const TextStyle(fontSize: 15),
                            decoration: const InputDecoration.collapsed(
                              hintText: 'Phone',
                            ),
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {
                              phone = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter your Phone';
                              } else if (value.length != 10) {
                                return 'Please enter a valid number';
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
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                         color: Color.fromARGB(255, 232, 229, 229),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Center(
                          child: TextFormField(
                            maxLines: 4,
                            style: const TextStyle(fontSize: 15),
                            decoration: const InputDecoration.collapsed(
                              hintText: 'Address',
                            ),
                            onChanged: (value) {
                              address = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter your Address';
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
                            style: const TextStyle(fontSize: 15),
                            decoration: const InputDecoration.collapsed(
                              hintText: 'Username',
                            ),
                            onChanged: (value) {
                              username = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter your Username';
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
                          backgroundColor: const Color(0xFF0E113A)
                        ),
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            await register(
                              name!,
                              phone!,
                              address!,
                              username!,
                              password!,
                            );
                          }
                        },
                        child: const Text(
                          'Register',
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
                        "Do you have an account? ",
                        style: TextStyle(fontSize: 16),
                      ),
                    GestureDetector(
                     onTap: () {
                       Navigator.of(context).push(
                         MaterialPageRoute(
                           builder: (context) => const LoginPage(),
                         ),
                       );
                     },
                     child: Container(
                       padding: EdgeInsets.all(16.0),
                       child: Text("Go to Login"),
                     ),
                   )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
