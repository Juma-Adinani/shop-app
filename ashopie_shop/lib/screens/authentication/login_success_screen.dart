import 'package:ashopie_shop/screens/productList/product_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:ashopie_shop/size_config.dart';

class LoginSuccessScreen extends StatefulWidget {
  final String name;
  const LoginSuccessScreen({Key? key, required this.name}) : super(key: key);

  @override
  State<LoginSuccessScreen> createState() => _LoginSuccessScreenState();
}

class _LoginSuccessScreenState extends State<LoginSuccessScreen> {
  String id = '';
  var user = <String, String>{};
  late Future<Map<String, String>> userFuture;

  Future<Map<String, String>> getData() async {
    var prefs = await SharedPreferences.getInstance();
    user.addAll({
      "id": prefs.getString("id")??'',
      "phone": prefs.getString("phone") ?? '',
      "role": prefs.getString("role") ?? '',
      "firstname": prefs.getString("fname") ?? '',
      "lastname":prefs.getString("lname")??'',
    });    
    // debugPrint(user.toString());
    // debugPrint(user['phone'].toString());
    return user;
  }

  @override
  initState(){
    super.initState();
    userFuture = getData();
    userFuture.then((value) => debugPrint(value.toString()));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const SizedBox(),
        title: const Text(
          "Login Success",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              Image.asset(
                "assets/images/success.png",
                height: SizeConfig.screenHeight * 0.4, //40%
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.08),
              Text(
                "Habari ${widget.name}, Karibu",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(30),
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: SizeConfig.screenWidth * 0.6,
                child: SizedBox(
                  width: double.infinity,
                  height: getProportionateScreenHeight(56),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      primary: Colors.white,
                      backgroundColor: const Color(0xFF3D82AE),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProductListScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Tazama bidhaa sasa',
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(14),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
