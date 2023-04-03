// ignore: file_names
import 'dart:convert';
import 'package:balti_app/models/business.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:objectid/objectid.dart';
import 'package:logger/logger.dart';
import '../models/product.dart';

import '../repository/networkHandler.dart';

var nw = NetworkHandler();

var log = Logger();

class Products with ChangeNotifier {
  final String authToken;
  final String userId;
  Products({
    required this.authToken,
    required this.products,
    required this.userId,
  });

  List<Product> products = [];
  List<Product> businessProducts = [];
  List<Product> allBusinessProducts = [];
  List<Product> filteredProducts = [];

  List<Product> get getProducts {
    return [...products];
  }

  List<Product> get favoriteProducts {
    return products.where((prod) => prod.isFav).toList();
  }

  Product findById(String id) {
    return products.firstWhere((prod) => prod.id == id);
  }

  Future<void> findByBusinessId(String id) async {
    print({id});
    businessProducts = [];

    dynamic response;
    try {
      response = await nw.get("businesses/listProducts/$id");
    } catch (e) {
      debugPrint('debug: $e');
    }

    // log.i(response);

    if (response.length > 0) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      for (var i = 0; i < response.length; i = i + 1) {
        print("********************");
        // log.i(response[i]);
        try {
          businessProducts.add(Product.fromJson(response[i]));
        } catch (e) {
          debugPrint('debug: $e');
        }
      }
      // return businesses.firstWhere((bus) => bus.id == id);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
    log.i(businessProducts);
    notifyListeners();
    // return products.where((prod) => prod.businessId == id).toList();
  }

  Future<void> findAllByBusinessId(List<String> ids) async {
    print({ids});
    allBusinessProducts = [];

    for (var i = 0; i < ids.length; i++) {
      String id = ids[i];
      dynamic response;
      try {
        response = await nw.get("businesses/listProducts/$id");
      } catch (e) {
        debugPrint('debug: $e');
      }

      // log.i(response);

      if (response.length > 0) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        for (var i = 0; i < response.length; i = i + 1) {
          try {
            allBusinessProducts.add(Product.fromJson(response[i]));
          } catch (e) {
            debugPrint('debug: $e');
          }
        }
        // return businesses.firstWhere((bus) => bus.id == id);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }
      log.i(allBusinessProducts);
      notifyListeners();
    }

    // return products.where((prod) => prod.businessId == id).toList();
  }

  Future<String> addProduct(Product product) async {
    //Send Api call to server for add
    Map<String, String> body = {
      "business_id": product.businessId,
      "name": product.name,
      "price": product.price.toString(),
      "description": product.description,
      "duration": product.duration.toString(),
      // "rating": 0,
      // "images": product.images,
      // "videos": product.videos,
    };

    log.wtf(body);
    dynamic response;
    try {
      response = await nw.postDataWithImages("products", product.images, body);
    } catch (e) {
      debugPrint('debug: $e');
    }
    return response;
  }

  Future<void> editProduct(Product product) async {
    //Send Api call to server for edit
    var bod = jsonEncode({
      "business_id": product.businessId,
      "name": product.name,
      "price": product.price,
      "description": product.description,
      "duration": product.duration,
      // "rating": 0,
      // "images": product.images,
      // "videos": product.videos,
    });
    final response = await http.put(
      Uri.parse(
          'http://Baltiprojectprod-env.eba-tegvsnxd.us-east-1.elasticbeanstalk.com/api/products/${product.id}'),
      headers: {"Content-Type": "application/json"},
      body: bod,
    );
    print(response.statusCode);
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      log.i("Product Updated");
      log.wtf(jsonDecode(response.body));
      notifyListeners();
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create product.');
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    //Send Api call to server for delete
    final response = await http.delete(Uri.parse(
        'http://Baltiprojectprod-env.eba-tegvsnxd.us-east-1.elasticbeanstalk.com/api/products/$id'));
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print("Successfully deleted product");
      print(jsonDecode(response.body));
      // return jsonDecode(response.body).id;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to edit business.');
    }
    notifyListeners();
  }

  Future<void> findAllProducts() async {
    products = [];
    final response = await http.get(Uri.parse(
        'http://Baltiprojectprod-env.eba-tegvsnxd.us-east-1.elasticbeanstalk.com/api/products'));

    if (response.statusCode == 200) {
      // print(jsonDecode(response.body));
      var jsonResponse = jsonDecode(response.body);
      for (var i = 0; i < jsonResponse.length; i = i + 1) {
        // print("********************");
        // print(jsonResponse[i]);
        products.add(Product.fromJson(jsonResponse[i]));
      }
    } else {
      throw Exception('Failed to load album');
    }
    notifyListeners();
  }

  Future<void> filterProducts(List<String> ids) async {
    log.i(ids);
    filteredProducts = [];
    for (var i = 0; i < products.length; i++) {
      if (ids.contains(products[i].businessId)) {
        filteredProducts.add(products[i]);
      }
    }

    notifyListeners();
  }

  Future<void> fetchAndSetProducts() async {
    products = [
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
        description: 'sjskdfb fkdhfkjdhf kfh sdkfh',
        businessId: '2',
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
        description: 'sjskdfb fkdhfkjdhf kfh sdkfh',
        businessId: '1',
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
        description: 'sjskdfb fkdhfkjdhf kfh sdkfh',
        businessId: '3',
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
        description: 'sjskdfb fkdhfkjdhf kfh sdkfh',
        businessId: '1',
        price: 350,
        rating: 4,
        duration: 25,
        imageUrl: 'assets/images/salad.jpg',
        images: [],
        videos: [],
      ),
    ];

    //Fetch products from api and set local products list
    notifyListeners();
  }
}
