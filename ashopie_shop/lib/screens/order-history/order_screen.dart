import 'dart:convert';

import 'package:ashopie_shop/api/api.dart';
import 'package:ashopie_shop/screens/payment/installment_payment.dart';
import 'package:ashopie_shop/screens/productList/product_list.dart';
import 'package:ashopie_shop/screens/sidebar/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  _completePaymentDialog(String textMessage, String cancelText,
      String confirmText, Widget screen) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(textMessage),
          titleTextStyle: const TextStyle(
            color: Color.fromARGB(255, 33, 49, 61),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                  child: Text(
                    cancelText,
                    style: const TextStyle(fontSize: 17.8, color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(
                    confirmText,
                    style: const TextStyle(fontSize: 17.8),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => screen,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  _cancelDialog(String textMessage, String cancelText, String confirmText,
      String orderid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(textMessage),
          titleTextStyle: const TextStyle(
            color: Color.fromARGB(255, 33, 49, 61),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                  child: Text(
                    cancelText,
                    style: const TextStyle(fontSize: 17.8, color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(
                    confirmText,
                    style: const TextStyle(fontSize: 17.8),
                  ),
                  onPressed: () {
                    _cancelOrder(orderid);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  _messageDialog(
      String textMessage, String buttonMessage, Widget screen, Color color) {
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
          actions: <Widget>[
            TextButton(
              child: Text(buttonMessage),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => screen,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  var count = 0;
  var totalAmount = 0;

  Future<List<dynamic>> getOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final userid = prefs.getString('id');
    final response = await http.post(Uri.parse(Request.showOrder), body: {
      'userid': userid,
    });

    Map<String, dynamic> items = json.decode(response.body);

    if (response.statusCode == 200) {
      if (items['status'].toString().contains('EMPTY')) {
        _messageDialog(
          items['message'].toString(),
          'Order now',
          const ProductListScreen(),
          Colors.blue,
        );
      } else {
        totalAmount = int.parse(items['totalAmount']);
        setState(() {
          totalAmount;
        });
      }
    }
    return items["data"];
  }

  @override
  void initState() {
    getOrders();
    super.initState();
  }

  _cancelOrder(String orderid) async {
    final prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('id');
    var response = await http.post(Uri.parse(Request.cancelOrder), body: {
      'userid': userid,
      'orderid': orderid,
    });
    var result = json.decode(response.body);
    if (response.statusCode == 200) {
      return _messageDialog(result['message'].toString(), 'OK',
          const OrderHistoryScreen(), Colors.green);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: const MenuSideBar(),
      appBar: AppBar(
        title: const Text(
          'Order history',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.grey[100],
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onPressed: () {
            _key.currentState!.openDrawer();
          },
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.send,
              color: Colors.black,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Material(
        elevation: 1,
        color: Colors.blueGrey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  "Total: $totalAmount TZS",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: FutureBuilder<dynamic>(
          future: getOrders(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error Ocuurred => ${snapshot.error}');
            } else {
              if (snapshot.hasData) {
                var orderItems = snapshot.data as List;
                return ListView.builder(
                  itemCount: orderItems.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.all(12.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: Row(
                        children: [
                          Image(
                            image: NetworkImage(Request.imageUrl +
                                orderItems[index]['product_photo']),
                            height: 110.0,
                            width: 110.0,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Product ordered: ${orderItems[index]['product']}',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    'ordered quantity: ${orderItems[index]['quantity']}',
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "Amount paid: ${orderItems[index]['amount']} TZS",
                                  ),
                                  Text(
                                    "Date ordered: ${orderItems[index]['order_date']}",
                                  ),
                                  // Text(
                                  //   "order id: ${orderItems[index]['id']}",
                                  // ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      orderItems[index]['status']
                                              .toString()
                                              .contains('Pending')
                                          ? Container(
                                              height: 30,
                                              width: 130,
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: TextButton(
                                                onPressed: () {
                                                  _cancelDialog(
                                                      'Cancelling an order 10% of amount will be taken',
                                                      'Cancel',
                                                      'Proceed',
                                                      orderItems[index]['id']);
                                                },
                                                child: const Text(
                                                  'Cancel order',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      Container(
                                        height: 30,
                                        width: 130,
                                        decoration: BoxDecoration(
                                          color: orderItems[index]['status']
                                                  .toString()
                                                  .contains('Pending')
                                              ? Colors.blue[200]
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: orderItems[index]['status']
                                                .toString()
                                                .contains('Completed')
                                            ? const Icon(
                                                Icons.verified,
                                                color: Colors.blue,
                                              )
                                            : TextButton(
                                                onPressed: () {
                                                  _completePaymentDialog(
                                                    'Complete payment for your order',
                                                    'Cancel',
                                                    'Proceed',
                                                    InstallmentPaymentScreen(
                                                      orderid: orderItems[index]
                                                          ['id'],
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  'Yet: ${orderItems[index]['to_be_paid']} TZS',
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
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
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            }
          },
        ),
      ),
    );
  }
}
