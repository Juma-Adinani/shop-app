import 'dart:convert';
import 'package:ashopie_shop/api/api.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/product_modal.dart';

class ProductRequest {
  static List<Product> parseProducts(String responseBody) {
    var list = json.decode(responseBody) as List<dynamic>;
    List<Product> products =
        list.map((model) => Product.fromJson(model)).toList();
    return products;
  }

  static Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(Request.getProductList));
    if (response.statusCode == 200) {
      return compute(parseProducts, response.body);
    } else {
      throw Exception('Cant get products');
    }
  }
}
