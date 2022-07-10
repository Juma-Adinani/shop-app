import 'package:ashopie_shop/api/api.dart';
import 'package:flutter/material.dart';
import 'package:ashopie_shop/models/product_modal.dart';

class ProductListItems extends StatelessWidget {
  final Product product;
  const ProductListItems({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        // height: 1000,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 110,
              width: 160,
              child: GridTile(
                child: Hero(
                  tag: "tag${product.id}",
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/no-image.png',
                    image: Request.imageUrl + '${product.productPhoto}',
                    // fit: BoxFit.cover,
                  ),
                ),
                // footer: GridTileBar(
                //   backgroundColor: Colors.white,
                //   title: Row(
                //     children: [
                //       const Icon(
                //         Icons.shopping_bag,
                //         color: Colors.grey,
                //       ),
                //       Text(
                //         '${product.quantity}',
                //         style: const TextStyle(color: Colors.black),
                //       ),
                //     ],
                //   ),
                //   trailing: IconButton(
                //     onPressed: () {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         const SnackBar(
                //           content:
                //               Text('Huraaay!..., You have added to your favourites (still on progress....)'),
                //         ),
                //       );
                //     },
                //     icon: const Icon(
                //       Icons.favorite_outline,
                //       color: Colors.red,
                //     ),
                //   ),
                // ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      'TZS ${product.price}',
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Huraaay!..., You have added to your favourites (still on progress....)'),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.favorite_outline,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      '${product.productName}',
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        const Icon(
                          Icons.shopping_bag,
                          color: Colors.grey,
                        ),
                        Text(
                          '${product.quantity}',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
                // Text(
                //   'category: ${product.categoryName}',
                //   style: const TextStyle(
                //     fontSize: 10,
                //   ),
                // ),
              ],
            ),
            const SizedBox(
              height: 3,
            ),
          ],
        ),
      ),
    );
  }
}
