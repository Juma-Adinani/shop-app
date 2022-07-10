import 'dart:convert';
import 'package:ashopie_shop/api/api.dart';
import 'package:ashopie_shop/screens/payment/payments.dart';
import 'package:ashopie_shop/screens/productList/product_list.dart';
import 'package:http/http.dart' as http;
import 'package:ashopie_shop/screens/sidebar/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  var totalAmount = 0;
  var totalQuantity = 0;
  Future<List<dynamic>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final userid = prefs.getString('id');
    final response = await http.post(Uri.parse(Request.getCart), body: {
      'user_id': userid,
    });
    Map<String, dynamic> items = json.decode(response.body);
    Map<String, dynamic> data = items["data"];
    if (response.statusCode == 200) {
      if (items['status'].toString().contains('EMPTY')) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(items['message'].toString()),
              titleTextStyle: const TextStyle(
                color: Colors.lightBlue,
                // fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("Add"),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ProductListScreen(),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      } else {
        totalAmount = int.parse(data['total']);
        totalQuantity = data['totalQuantity'];
        setState(() {
          totalAmount;
        });
      }
    }
    return data["products"];
  }

  _removeFromCart(String cartid) async {
    final prefs = await SharedPreferences.getInstance();
    final userid = prefs.getString('id');
    final response = await http.post(Uri.parse(Request.removeCart),
        body: {'userid': userid, 'cartid': cartid});

    if (response.statusCode == 200) {
      var removeCart = json.decode(response.body);

      if (removeCart['status'].toString().contains('OK')) {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(removeCart['message']),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: const MenuSideBar(),
      appBar: AppBar(
        title: const Text(
          'Cart',
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
              totalAmount > 0
                  ? Expanded(
                      child: MaterialButton(
                        height: 60.0,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Pay now to order'),
                                titleTextStyle: const TextStyle(
                                  color: Color.fromARGB(255, 33, 49, 61),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                actions: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(
                                              fontSize: 17.8,
                                              color: Colors.red),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          "Pay now $totalAmount",
                                          style:
                                              const TextStyle(fontSize: 17.8),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CashPaymentScreen(
                                                      quantity: totalQuantity),
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
                        },
                        color: Colors.blueAccent,
                        child: const Text(
                          'Make an order',
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                      ),
                    )
                  : const Text(''),
            ],
          ),
        ),
      ),
      body: Center(
        child: FutureBuilder<dynamic>(
          future: getCart(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('No available products in your cart');
            } else if (snapshot.hasData) {
              var cartItems = snapshot.data as List;
              return ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  return Container(
                    // margin: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
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
                          offset:
                              const Offset(0, 3), // changes position of shadow
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
                              cartItems[index]['product_photo']),
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
                                  cartItems[index]['product_name'],
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  cartItems[index]['description'],
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  "TZS ${cartItems[index]['price']} @",
                                ),
                                Text(
                                  "Quantity ordered: ${cartItems[index]['ordered_quantity']}",
                                ),
                                // Text(
                                //   "Total (tzs): ${cartItems[index]['totalPrice']}",
                                // ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _removeFromCart(cartItems[index]['id']);
                                      },
                                      icon: const Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
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
          },
        ),
      ),
    );
  }
}
