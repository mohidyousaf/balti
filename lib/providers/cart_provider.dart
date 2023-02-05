import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../models/cart.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import 'package:http/http.dart' as http;

import '../repository/networkHandler.dart';

var nw = NetworkHandler();

class UserCart with ChangeNotifier {
  final String authToken;
  final String userId;

  UserCart({
    required this.authToken,
    required this.cartProducts,
    required this.userId,
  });
  List<Product> cartProducts = [];
  String cartId = "";
  List<Map<String, String>> prodQuantity = [];
  String totalPrice = "";

  List<Product> get getCartProducts {
    return [...cartProducts];
  }

  Future<String> createCart(
      String userId,
      String businessId,
      String productId,
      int quantity,
      double price,
      List<String> images,
      String productName) async {
    //Send Api call to server for add
    // create new cart item with current cart id
    if (cartId != "") {
      var body = {
        "products": [
          {"product_id": productId, "qty": quantity}
        ],
      };

      var log = Logger();
      log.i(body);

      dynamic response;
      try {
        log.d('https://balti.herokuapp.com/api/cart/$cartId');
        response = await http.put(
          Uri.parse('https://balti.herokuapp.com/api/cart/$cartId'),
          headers: {"Content-Type": "application/json"},
          body: json.encode(body),
        );
      } catch (e) {
        log.e(e);
      }

      log.i(response.statusCode);
      log.d(response);
      log.wtf(jsonDecode(response.body));
      if (response.statusCode == 200) {
        var cartCreated = jsonDecode(response.body);
        var product = {
          "_id": productId,
          "business_id": businessId,
          "name": productName,
          "price": price,
          "images": images,
        };

        prodQuantity.add({
          "productId": productId,
          "quantity": quantity.toString(),
          "price": price.toString()
        });
        Product newProduct = Product.fromJson(product);
        cartProducts.add(newProduct);
      }
    }
    if (cartId == "") {
      var body = {
        "User": userId,
        "Business": businessId,
        "products": [
          {"product_id": productId, "qty": quantity}
        ],
      };
      var log = Logger();
      log.i(body);

      dynamic response;
      try {
        response = await http.post(
          Uri.parse('https://balti.herokuapp.com/api/cart'),
          headers: {"Content-Type": "application/json"},
          body: json.encode(body),
        );
      } catch (e) {
        log.e(e);
      }

      log.i(response.statusCode);
      log.i(jsonDecode(response.body));
      if (response.statusCode == 200) {
        var cartCreated = jsonDecode(response.body);

        var product = {
          "_id": productId,
          "business_id": businessId,
          "name": productName,
          "price": price,
          "images": images,
        };

        Product newProduct = Product.fromJson(product);
        cartProducts.add(newProduct);
        cartId = cartCreated['cart']['_id'] ?? "";
        prodQuantity.add({
          "productId": productId,
          "quantity": quantity.toString(),
          "price": price.toString()
        });
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.
        throw Exception('Failed to create product.');
      }
    }

    notifyListeners();
    return cartId;
  }

  Future<void> getProducts() async {
    //Send Api call to server for add
    // create new cart item with current cart id
    cartProducts = [
      Product(
        id: '1',
        name: 'Burger and Fries',
        businessId: '1',
        description: 'sjskdfb fkdhfkjdhf kfh sdkfh',
        price: 550,
        rating: 4.5,
        duration: 25,
        imageUrl: 'assets/images/burger.jpg',
        images: [],
        videos: [],
      ),
      Product(
        id: '2',
        name: 'Paratha Roll',
        businessId: '2',
        description: 'sjskdfb fkdhfkjdhf kfh sdkfh',
        price: 600,
        rating: 4,
        duration: 30,
        imageUrl: 'assets/images/roll.jpg',
        images: [],
        videos: [],
      ),
      Product(
        id: '3',
        name: 'Mexican Tacos',
        businessId: '1',
        description: 'sjskdfb fkdhfkjdhf kfh sdkfh',
        price: 550,
        rating: 4.5,
        duration: 35,
        imageUrl: 'assets/images/tacos.jpg',
        images: [],
        videos: [],
      ),
      Product(
        id: '4',
        name: 'Vietnamese Noodles',
        businessId: '3',
        description: 'sjskdfb fkdhfkjdhf kfh sdkfh',
        price: 650,
        rating: 5,
        duration: 35,
        imageUrl: 'assets/images/food_1.jpeg',
        images: [],
        videos: [],
      ),
      Product(
        id: '5',
        name: 'Summer Salad',
        businessId: '1',
        description: 'sjskdfb fkdhfkjdhf kfh sdkfh',
        price: 350,
        rating: 4,
        duration: 25,
        imageUrl: 'assets/images/salad.jpg',
        images: [],
        videos: [],
      ),
    ];
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    //Send Api call to server for add
    // create new cart item with current cart id
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    //Send Api call to server for delete
    // delete cart item with cart item id
    notifyListeners();
  }
}
