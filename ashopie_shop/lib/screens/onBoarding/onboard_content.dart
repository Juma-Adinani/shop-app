import 'package:flutter/material.dart';

// import '../../../constants.dart';
import 'package:ashopie_shop/size_config.dart';

class OnBoardContent extends StatelessWidget {
  const OnBoardContent({
    Key? key,
    this.text,
    this.image,
  }) : super(key: key);
  final String? text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Spacer(),
        Text(
          "AShopie Shop",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(36),
            color: Colors.blue.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          text!,
          textAlign: TextAlign.center,
        ),
        const Spacer(flex: 2),
        Image.asset(
          image!,
          height: getProportionateScreenHeight(265),
          width: getProportionateScreenWidth(235),
        ),
      ],
    );
  }
}
