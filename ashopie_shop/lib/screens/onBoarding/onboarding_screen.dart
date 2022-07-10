import 'package:flutter/material.dart';
import 'package:ashopie_shop/size_config.dart';
import './onboard_content.dart';
import 'package:ashopie_shop/screens/authentication/login.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({Key? key}) : super(key: key);

  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  int currentPage = 0;
  List<Map<String, String>> onBoardData = [
    {
      "text": "Welcome to AShopie Shop!",
      "image": "assets/images/splash_1.png"
    },
    {
      "text": "We help people conect with furniture stores \naround Tanzania",
      // "text":
      //     "Tunasaidia wateja kuwaunganisha na maduka ya samani\nyenye bidhaa bora hapa nchini Tanzania",
      "image": "assets/images/splash_2.png"
    },
    {
      "text": "We show the easy way to shop. \nJust stay at home with us",
      // "text":
      //     "Tunakupatia njia bora, rahisi na salama katika kununua bidhaa,\nTulia nyumbani tukuhudumie",
      "image": "assets/images/splash_3.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: PageView.builder(
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemCount: onBoardData.length,
                  itemBuilder: (context, index) => OnBoardContent(
                    image: onBoardData[index]["image"],
                    text: onBoardData[index]['text'],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20)),
                  child: Column(
                    children: <Widget>[
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          onBoardData.length,
                          (index) => buildDot(index: index),
                        ),
                      ),
                      const Spacer(flex: 1),
                      SizedBox(
                        width: double.infinity,
                        height: getProportionateScreenHeight(56),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            primary: Colors.white,
                            backgroundColor: const Color(0xFF3D82AE),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Welcome',
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(18),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index
            ? const Color(0xFF3D82AE)
            : const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
