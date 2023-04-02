import 'dart:convert';
import 'package:web_ffi/web_ffi.dart';

import 'package:balti_app/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../globals.dart' as globals;
import 'package:intl/intl.dart';

final DateTime now = DateTime.now();
var log = Logger();

class Orders with ChangeNotifier {
  // final String authToken;
  final String userId;
  Orders({
    // required this.authToken,
    required this.orders,
    // required this.orderItems,
    required this.userId,
  });
  List<Orders> orders = [];
  List<Order> approvalOrders = [];
  List<Order> processedOrders = [];
  List<Order> completedOrders = [];
  List<Map<String, Product>> approvalOrdersProducts = [];
  List<Map<String, Product>> processedOrdersProducts = [];
  List<Map<String, Product>> completedOrdersProducts = [];

  List<Order> get getApprovalOrders {
    return approvalOrders;
  }

  List<Order> get getProcessedOrders {
    return processedOrders;
  }

  List<Order> get getCompletedOrders {
    return completedOrders;
  }

  // List<CartItem> orderItems = [];

  // List<CartItem> get getOrderItems {
  //   return [...orderItems];
  // }

  List<Orders> get getOrder {
    return [...orders];
  }

  List<Product> getSpecificOrderProduct(String id, String type) {
    List<Product> products = [];
    if (type == "Approval") {
      for (var i = 0; i < approvalOrdersProducts.length; i++) {
        if (approvalOrdersProducts[i].keys.first == id) {
          products.add(
              approvalOrdersProducts[i][approvalOrdersProducts[i].keys.first]!);
        }
      }
      return products;
    }
    if (type == "Progress") {
      for (var i = 0; i < processedOrdersProducts.length; i++) {
        if (processedOrdersProducts[i].keys.first == id) {
          products.add(processedOrdersProducts[i]
              [processedOrdersProducts[i].keys.first]!);
        }
      }
      log.i("Getting specifics");
      log.wtf(products);
      return products;
    }

    if (type == "Completed") {
      for (var i = 0; i < completedOrdersProducts.length; i++) {
        if (completedOrdersProducts[i].keys.first == id) {
          products.add(completedOrdersProducts[i]
              [completedOrdersProducts[i].keys.first]!);
        }
      }
      log.i("Getting specifics");
      log.wtf(products);
      return products;
    }
    return [];
  }

  Future<void> getOrdersByStatus(String status, String userId) async {
    // log.d("In getOrderbystatus");
    dynamic response;
    try {
      response = await nw.get("orders/business/$userId/$status");
    } catch (e) {
      log.e(e);
    }

    // log.d(response);
    approvalOrders = [];
    processedOrders = [];
    completedOrders = [];
    if (response != null) {
      if (status == "In Approval") {
        for (var i = 0; i < response.length; i = i + 1) {
          Order order = Order.fromJson(response[i]);
          approvalOrders.add(order);
          for (var j = 0; j < response[i]['products'].length; j++) {
            Product product = Product.fromJson(response[i]['products'][j]);
            log.i("product", product.name);
            approvalOrdersProducts.add({order.id: product});
          }
        }
      } else if (status == "In Processing") {
        for (var i = 0; i < response.length; i = i + 1) {
          Order order = Order.fromJson(response[i]);
          processedOrders.add(order);
          for (var j = 0; j < response[i]['products'].length; j++) {
            processedOrdersProducts
                .add({order.id: Product.fromJson(response[i]['products'][j])});
          }
        }
      } else if (status == "Completed") {
        for (var i = 0; i < response.length; i = i + 1) {
          Order order = Order.fromJson(response[i]);
          completedOrders.add(order);
          for (var j = 0; j < response[i]['products'].length; j++) {
            completedOrdersProducts
                .add({order.id: Product.fromJson(response[i]['products'][j])});
          }
        }
      }
    }

    log.wtf(approvalOrdersProducts, completedOrdersProducts);
    notifyListeners();
  }

  Future<Void?> updateOrderStatus(String orderId, String status) async {
    dynamic response;
    Map<String, String> body = {"status": status};
    try {
      response = await nw.put("orders/$orderId", body);
    } catch (e) {
      log.e(e);
    }

    log.wtf(response);

    if (status == "In Approval") {
    } else if (status == "In Processing") {
      Order requiredOrder =
          approvalOrders.firstWhere((element) => element.id == orderId);
      approvalOrders = [
        ...approvalOrders.where((element) => element.id != orderId)
      ];
      processedOrders.add(requiredOrder);
    } else if (status == "Completed") {
      Order requiredOrder =
          processedOrders.firstWhere((element) => element.id == orderId);
      processedOrders = [
        ...processedOrders.where((element) => element.id != orderId)
      ];
      completedOrders.add(requiredOrder);
    } else {
      approvalOrders = [
        ...approvalOrders.where((element) => element.id != orderId)
      ];
      processedOrders = [
        ...processedOrders.where((element) => element.id != orderId)
      ];
      completedOrders = [
        ...completedOrders.where((element) => element.id != orderId)
      ];
    }
    notifyListeners();
  }

  Future<String> createOrder(List<Product> products, List<ProdQuanity> quantity,
      String userId, double total) async {
    //Send Api call to server for add
    // create new cart item with current cart id

    var body = {
      'User': userId,
      'NotifToken': globals.notifToken,
      'Business': products[0].businessId,
      'payable_amount': total.toInt(),
      'time_of_order': now.toString()
    };

    // 'payable_amount': total.toInt(),
    log.wtf('before', body);

    var productsToAdd = [];
    for (var i = 0; i < products.length; i++) {
      log.wtf('image', products[i].images[0]);
      productsToAdd.add({
        'product_id': products[i].id,
        'product_name': products[i].name,
        'qty': quantity[i].quantity,
        'price': quantity[i].price,
        'imageUrl': products[i].images[0]
      });
    }

    body['products'] = productsToAdd;

    log.wtf('after', body);

    dynamic response;
    try {
      response = await http.post(
        Uri.parse(
            'http://Baltiprojectprod-env.eba-tegvsnxd.us-east-1.elasticbeanstalk.com/api/orders'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );
    } catch (e) {
      log.e(e);
    }

    return "cart id";
    notifyListeners();
  }

  // Future<void> getOrderById(String id) async {
  //   //Send Api call to server for add
  //   // create new cart item with current cart id
  //   orderItems = [];
  //   final response = await http
  //       .get(Uri.parse('http://Baltiprojectprod-env.eba-tegvsnxd.us-east-1.elasticbeanstalk.com/api/businesses/list/$id'));

  //   if (response.statusCode == 200) {
  //     // If the server did return a 200 OK response,
  //     // then parse the JSON.
  //     var jsonResponse = jsonDecode(response.body);
  //     for (var i = 0; i < jsonResponse.length; i = i + 1) {
  //       print("********************");
  //       print(jsonResponse[i]);
  //       orders.add(Order.fromJson(jsonResponse[i]));
  //     }
  //     // return businesses.firstWhere((bus) => bus.id == id);
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to load album');
  //   }
  //   notifyListeners();
  // }

  // Future<void> getOrder() async {
  //   //Send Api call to server for add
  //   // create new cart item with current cart id
  //   orders = [];
  //   notifyListeners();
  // }

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
