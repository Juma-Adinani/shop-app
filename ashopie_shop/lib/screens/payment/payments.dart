import 'dart:convert';
import 'package:ashopie_shop/api/api.dart';
import 'package:ashopie_shop/screens/order-history/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CashPaymentScreen extends StatefulWidget {

  final int quantity;
  const CashPaymentScreen({Key? key, required this.quantity}) : super(key: key);

  @override
  State<CashPaymentScreen> createState() => _CashPaymentScreenState();
}

class _CashPaymentScreenState extends State<CashPaymentScreen> {
  final _paymentFormKey = GlobalKey<FormState>();

  _messageDialog(String textMessage, Color color, Widget screen) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(textMessage),
          titleTextStyle: TextStyle(
            color: color,
            // fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          actions: <Widget>[screen],
        );
      },
    );
  }

  TextEditingController phoneNumber = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController pin = TextEditingController();

  Future<void> _makeOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final userid = prefs.getString('id');

    var response = await http.post(Uri.parse(Request.makeOrder), body: {
      'userid': userid,
      'phone': phoneNumber.text.toString(),
      'amount': amount.text.toString(),
      'pin': pin.text.toString(),
      'quantity':widget.quantity.toString(),
    });

    var result = json.decode(response.body);

    if (response.statusCode == 200) {
      if (result['status'].toString().contains('SUCCESS')) {
        return _messageDialog(
          result['message'].toString(),
          Colors.green,
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const OrderHistoryScreen(),
                ),
              );
            },
          ),
        );
      } else if (result['status'].toString().contains('ERROR')) {
        return _messageDialog(
          result['message'].toString(),
          Colors.red,
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        );
      }
    }
  }

  // functionality to pay in cash should be here, then updates the order history screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 236, 236),
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        title: const Text(
          'Payment for your order',
          style: TextStyle(color: Colors.grey),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF3D82AE),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notification_important,
              color: Color(0xFF3D82AE),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: 350,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(10),
              elevation: 5.0,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: 80,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.green[800],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Mpesa',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 80,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey[200],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Paypal',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 70,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey[200],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Card',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text('LIPA NA'),
                    Image.asset('assets/images/1200px-M-PESA_LOGO-01.svg.png',
                        width: 150),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Form(
                        key: _paymentFormKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: phoneNumber,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter phone number';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                labelText: "Enter phone number",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.phone),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: amount,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter amount';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Enter amount",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.money),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: pin,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter PIN';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Enter PIN",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.key),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                MaterialButton(
                                  onPressed: () {
                                    if (_paymentFormKey.currentState!
                                        .validate()) {
                                      _makeOrder();
                                    }
                                  },
                                  color: Colors.green[800],
                                  hoverColor: Colors.green[700],
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                    ),
                                    child: Text(
                                      'Pay now',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
