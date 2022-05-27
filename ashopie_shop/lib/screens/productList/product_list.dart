import 'package:ashopie_shop/models/product_modal.dart';
import 'package:ashopie_shop/screens/productList/detail_screen.dart';
import 'package:ashopie_shop/screens/productList/product_items.dart';
import 'package:ashopie_shop/screens/sidebar/sidebar.dart';
import 'package:ashopie_shop/services/service.dart';
import 'package:flutter/material.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  Widget gridView(AsyncSnapshot<List<Product>> snapshot) {
    return Container(
      color: Colors.grey[200],
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 100,
            child: Column(
              children: [
                SizedBox(
                  height: 80,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Search your product...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 1,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              children: snapshot.data!.map((product) {
                return GestureDetector(
                  child: Expanded(child: ProductListItems(product: product)),
                  onTap: () {
                    gotoDetailPage(context, product);
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  gotoDetailPage(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => DetailScreen(product: product),
      ),
    );
  }

  loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: const MenuSideBar(),
      appBar: AppBar(
        title: const Text(
          'Bidhaa zetu',
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: FutureBuilder<List<Product>>(
              future: ProductRequest.getProducts(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Hakuna bidhaa hivi sasa..',
                      style: TextStyle(
                        fontSize: 20.3,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey
                      ),
                    ),
                  );
                } else if (snapshot.hasData) {
                  return gridView(snapshot);
                }
                return loading();
              },
            ),
          ),
        ],
      ),
    );
  }
}
