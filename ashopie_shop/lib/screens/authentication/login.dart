import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ashopie_shop/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ashopie_shop/screens/authentication/login_success_screen.dart';
import 'package:ashopie_shop/screens/authentication/register.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //accepting user inputs
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController password = TextEditingController();

  final _loginFormKey = GlobalKey<FormState>();

//create a method to perform a login functionality
  Future<void> userLogin() async {
    var response = await http.post(Uri.parse(Request.login), body: {
      'phone_number': phoneNumber.text.toString(),
      'password': password.text,
    });

    //take data from json
    var result = json.decode(response.body);
    if (response.statusCode == 200) {
      if (result['status'].toString().contains('OK')) {
        debugPrint(result['message']);
        var getDetails = result['data'];
        debugPrint(getDetails['firstname'].toString());
        // // obtain shared preferences
        final prefs = await SharedPreferences.getInstance();
        // set value
        prefs.setString('id', getDetails['id']);
        prefs.setString('phone', getDetails['phone_number']);
        prefs.setString('role', getDetails['role']);
        prefs.setString('fname', getDetails['firstname']);
        prefs.setString('lname', getDetails['sirname']);
        
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                LoginSuccessScreen(name: getDetails['firstname'].toString()),
          ),
        );
      } else {
        // debugPrint('Empty -> $result');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(result['message'].toString()),
              titleTextStyle: const TextStyle(
                color: Colors.red,
                // fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("Try again!"),
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
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Check your server connection'),
            titleTextStyle: const TextStyle(
              color: Colors.red,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Try Again!"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
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
                  "LOGIN",
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
                  key: _loginFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                        controller: phoneNumber,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: "Enter phone number",
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
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        controller: password,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Enter password",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: Icon(Icons.remove_red_eye),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text("Forgot password?"),
                          ),
                        ],
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
                            if (_loginFormKey.currentState!.validate()) {
                              userLogin();
                            }
                          },
                          child: const Text(
                            "SIGN IN",
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
                      "Not have an account?",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text("Create account"),
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
