import 'package:ashopie_shop/screens/authentication/login.dart';
import 'package:ashopie_shop/screens/cart/cart_screen.dart';
import 'package:ashopie_shop/screens/order-history/order_screen.dart';
import 'package:ashopie_shop/screens/productList/product_list.dart';
import 'package:ashopie_shop/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuSideBar extends StatefulWidget {
  const MenuSideBar({Key? key}) : super(key: key);

  @override
  State<MenuSideBar> createState() => _MenuSideBarState();
}

class _MenuSideBarState extends State<MenuSideBar> {
  late bool homeColor = false;

  late bool cartColor = false;

  late bool historyColor = false;

  late bool aboutColor = false;

  late bool contactUsColor = false;

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear().then(
          (value) => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          ),
        );
  }

  var fname = "";
  var phone = "";
  var lname = "";

  _sessions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fname = prefs.getString('fname') ?? '';
      lname = prefs.getString('lname') ?? '';
      phone = prefs.getString('phone') ?? '';
    });
  }

  @override
  void initState() {
    _sessions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            onDetailsPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const UserProfileScreen(),
                ),
              );
            },
            accountName: Text(
              fname + ' ' + lname,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('images/profile.jpg'),
            ),
            accountEmail: Text(
              phone,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            decoration: const BoxDecoration(
              color: Color(0xfff2f2f2),
            ),
          ),
          ListTile(
            selected: homeColor,
            onTap: () {
              setState(() {
                homeColor = true;
                cartColor = false;
                historyColor = false;
                aboutColor = false;
                contactUsColor = false;
              });
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProductListScreen(),
                ),
              );
            },
            leading: const Icon(Icons.home),
            title: const Text('Mwanzo'),
          ),
          ListTile(
            selected: cartColor,
            onTap: () {
              setState(() {
                cartColor = true;
                homeColor = false;
                historyColor = false;
                aboutColor = false;
                contactUsColor = false;
              });
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Kikapu'),
          ),
          ListTile(
            selected: historyColor,
            onTap: () {
              setState(() {
                historyColor = true;
                cartColor = false;
                homeColor = false;
                aboutColor = false;
                contactUsColor = false;
              });
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const OrderHistoryScreen(),
                ),
              );
            },
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Historia ya oda'),
          ),
          ListTile(
            selected: aboutColor,
            onTap: () {
              setState(() {
                aboutColor = true;
                cartColor = false;
                historyColor = false;
                homeColor = false;
                contactUsColor = false;
              });
            },
            leading: const Icon(Icons.info),
            title: const Text('Kuhusu sisi'),
          ),
          ListTile(
            selected: contactUsColor,
            onTap: () {
              setState(() {
                contactUsColor = true;
                cartColor = false;
                historyColor = false;
                aboutColor = false;
                homeColor = false;
              });
            },
            leading: const Icon(Icons.phone),
            title: const Text('Wasiliana nasi'),
          ),
          ListTile(
            enabled: true,
            onTap: () {
              _logout();
            },
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Ondoka'),
          ),
        ],
      ),
    );
  }
}
