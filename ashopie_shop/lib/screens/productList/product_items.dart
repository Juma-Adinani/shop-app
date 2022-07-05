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
        height: 250,
        width: double.infinity,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 170,
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
                footer: GridTileBar(
                  backgroundColor: Colors.white,
                  title: Row(
                    children: [
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
                  trailing: IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Huraaay!..., You have added to your favourites (still on progress....)'),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.favorite_outline,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:<Widget>[
                Text(
                  'TZS ${product.price}',
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                Text(
                  '${product.productName}',
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            Text(
              'Kategoria: ${product.categoryName}',
              style: const TextStyle(
                fontSize: 15,
              ),
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
