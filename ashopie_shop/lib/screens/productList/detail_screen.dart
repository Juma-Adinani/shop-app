import 'dart:convert';
import 'package:ashopie_shop/api/api.dart';
import 'package:ashopie_shop/screens/productList/product_list.dart';
import 'package:flutter/material.dart';
import 'package:ashopie_shop/models/product_modal.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final Product product;
  const DetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int count = 1;

  _saveToCart() async {
    final prefs = await SharedPreferences.getInstance();
    final userid = prefs.getString('id');

    var response = await http.post(Uri.parse(Request.addCart), body: {
      'user_id': userid,
      'product_id': widget.product.id,
      'ordered_quantity': count.toString()
    });

    Map<String, dynamic> result = json.decode(response.body);

    if (response.statusCode == 200) {
      if (result['status'].toString().contains('info')) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(result['info'].toString()),
              titleTextStyle: const TextStyle(
                color: Colors.red,
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
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Bidhaa imewekwa kwenye kapu kikamilifu'),
              titleTextStyle: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("Sawa"),
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
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(result['message'].toString()),
            titleTextStyle: const TextStyle(
              color: Colors.red,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.grey[200],
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Center(
                child: Container(
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Card(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: SizedBox(
                        height: 230,
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/no-image.png',
                          image: Request.imageUrl +
                              '${widget.product.productPhoto}',
                          // fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 100,
                      child: Row(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${widget.product.productName}',
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                'TZS ' + widget.product.price!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Color(0xff9b96d6),
                                ),
                              ),
                              const Text(
                                'Maelezo',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      child: Wrap(
                        children: <Widget>[
                          Text(
                            '${widget.product.description}',
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Idadi',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 40,
                      width: 130,
                      decoration: BoxDecoration(
                        color: Colors.blue[200],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (count > 1) {
                                  count--;
                                }
                              });
                            },
                            child: const Icon(Icons.remove),
                          ),
                          Text(
                            count.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                count++;
                              });
                            },
                            child: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 60,
                      width: double.infinity,
                      color: const Color(0xFF3D82AE),
                      child: MaterialButton(
                        onPressed: () {
                          _saveToCart();
                        },
                        child: const Text(
                          "Weka kwenye kikapu",
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
            ],
          ),
        ],
      ),
    );
  }
}
