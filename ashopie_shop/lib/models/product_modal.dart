// import 'dart:convert';
// import 'dart:developer';
// import 'package:http/http.dart' as http;
// import 'package:ashopie_shop/api/api.dart';

class Product {
  String? id;
  String? productName;
  String? description;
  String? price;
  String? quantity;
  String? productPhoto;
  String? postedOn;
  String? categoryId;
  String? userId;

  Product(
      {this.id,
      this.productName,
      this.description,
      this.price,
      this.quantity,
      this.productPhoto,
      this.postedOn,
      this.categoryId,
      this.userId});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    description = json['description'];
    price = json['price'];
    quantity = json['quantity'];
    productPhoto = json['product_photo'];
    postedOn = json['posted_on'];
    categoryId = json['category_id'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_name'] = productName;
    data['description'] = description;
    data['price'] = price;
    data['quantity'] = quantity;
    data['product_photo'] = productPhoto;
    data['posted_on'] = postedOn;
    data['category_id'] = categoryId;
    data['user_id'] = userId;
    return data;
  }
}

// Future<List<Product>> fetchProducts() async {
//   final response = await http.get(Uri.parse(Request.getProductList));

//   if (response.statusCode == 200) {
//     var list = json.decode(response.body) as List<dynamic>;
//     var products = list.map((product) => Product.fromJson(product)).toList();
//     return products;
//   } else {
//     log('There is an error');
//     throw Exception('Failed to Load Products');
//   }
// }
