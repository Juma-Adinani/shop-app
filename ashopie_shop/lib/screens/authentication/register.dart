import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ashopie_shop/api/api.dart';
import 'package:ashopie_shop/screens/authentication/login.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
//accepting user inputs values from textwidget
  TextEditingController firstname = TextEditingController();
  TextEditingController sirname = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  final _registerFormKey = GlobalKey<FormState>();
  Future<void> userRegistration() async {
    var response = await http.post(Uri.parse(Request.registration), body: {
      'firstname': firstname.text,
      'sirname': sirname.text,
      'phone_number': phoneNumber.text.toString(),
      'password': password.text
    });
    Map<String, dynamic> result = json.decode(response.body);

    if (response.statusCode == 200) {
      if (result['status'].toString().contains('OK')) {
        // debugPrint(result['message'].toString());
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      } else {
        // debugPrint(result['message'].toString());
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(result['message'].toString()),
              titleTextStyle: const TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("Jaribu tena!"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      debugPrint('There is an error' + result['message']);
    }

    return json.decode(result['message'].toString());
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "JISAJILI",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF3D82AE),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Form(
                  key: _registerFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Tafadhali ingiza jina lako la kwanza';
                          }
                          return null;
                        },
                        controller: firstname,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          labelText: "Ingiza jina la kwanza",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Tafadhali ingiza jina la mwisho';
                          }
                          return null;
                        },
                        controller: sirname,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          labelText: "Ingiza jina la mwisho",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Tafadhali ingiza namba ya simu';
                          }
                          return null;
                        },
                        controller: phoneNumber,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: "Ingiza namba ya simu",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Tafadhali ingiza neno siri.';
                          }
                          return null;
                        },
                        controller: password,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Ingiza neno siri",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: Icon(Icons.remove_red_eye),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF3D82AE),
                              Color.fromARGB(255, 51, 115, 155)
                            ],
                          ),
                        ),
                        child: MaterialButton(
                          onPressed: () {
                            if (_registerFormKey.currentState!.validate()) {
                              userRegistration();
                            }
                          },
                          child: const Text(
                            "JISAJILI",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  height: 30,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Umeshajisajili tayari?",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text("Ingia"),
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
























