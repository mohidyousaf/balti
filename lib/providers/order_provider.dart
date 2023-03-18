import 'dart:convert';
import 'dart:ffi';

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

  Future<Void?> getOrdersByStatus(String status, String userId) async {
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
          approvalOrders.add(Order.fromJson(response[i]));
        }
      } else if (status == "In Processing") {
        if (response) {}
        for (var i = 0; i < response.length; i = i + 1) {
          processedOrders.add(Order.fromJson(response[i]));
        }
      } else if (status == "Completed") {
        for (var i = 0; i < response.length; i = i + 1) {
          completedOrders.add(Order.fromJson(response[i]));
        }
      }
    }

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
      productsToAdd.add({
        'product_id': products[i].id,
        'product_name': products[i].name,
        'qty': quantity[i].quantity,
        'price': quantity[i].price
      });
    }

    body['products'] = productsToAdd;

    log.wtf('after', body);

    dynamic response;
    try {
      response = await http.post(
        Uri.parse(
            'http://baltiproject-env.eba-tyyrezah.ap-northeast-1.elasticbeanstalk.com/api/orders'),
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
  //       .get(Uri.parse('http://baltiproject-env.eba-tyyrezah.ap-northeast-1.elasticbeanstalk.com/api/businesses/list/$id'));

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
