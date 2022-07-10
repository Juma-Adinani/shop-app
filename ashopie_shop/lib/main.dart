import 'package:ashopie_shop/screens/onBoarding/onboarding_screen.dart';
import 'package:ashopie_shop/screens/productList/product_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userId = prefs.getString('id');
  // var userName = prefs.getString('fname');
  // debugPrint(userId);
  runApp(
    MaterialApp(
      title: 'AShopie | shop smartly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF3D82AE),
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userId == null
          ? const OnBoardScreen()
          : const ProductListScreen(),
    ),
  );
  // runApp(const MyApp());
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   isLoggedIn() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var userId = prefs.getString('id');
//     var userName = prefs.getString('firstname');
//     debugPrint(userId);
//     userId == null
//         ? const OnBoardScreen()
//         : LoginSuccessScreen(
//             name: userName.toString(),
//           );
//   }

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'AShopie | shop smartly',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: const Color(0xFF3D82AE),
//         scaffoldBackgroundColor: Colors.white,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: isLoggedIn(),
//     );
//   }
// }
