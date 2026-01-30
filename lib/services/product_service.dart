import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductApi {
  //static const String baseUrl = "http://127.0.0.1:8080/api/v1";

  static const String baseUrl = "https://productdemo-omkr.onrender.com/api/v1";

  // CREATE
  static Future<bool> saveProduct(Product product) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/product"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(product.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Save error: $e");
      return false;
    }
  }

  // GET ALL
  static Future<List<Product>> getAllProducts() async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/products"),
            headers: {"Content-Type": "application/json"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => Product.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print("Fetch error: $e");
      return [];
    }
  }

  // UPDATE
  static Future<bool> updateProduct(int id, Product product) async {
    try {
      final response = await http
          .put(
            Uri.parse("$baseUrl/products/$id"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(product.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      print("Update error: $e");
      return false;
    }
  }

  // DELETE
  static Future<bool> deleteProduct(int id) async {
    try {
      final response = await http
          .delete(Uri.parse("$baseUrl/products/$id"))
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print("Delete error: $e");
      return false;
    }
  }
}
