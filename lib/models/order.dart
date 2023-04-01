import 'package:logger/logger.dart';

class Order {
  final String id;
  final String userId;
  final String userName;
  final String businessId;
  final String timeOfOrder;
  final double payableAmount;
  final String deliveryTime;
  final String deliveryLocation;
  final double lat;
  final double lng;
  final String status;
  final int quantity;
  final int price;

  Order(
      {required this.id,
      required this.userId,
      required this.businessId,
      required this.timeOfOrder,
      required this.payableAmount,
      required this.deliveryTime,
      required this.deliveryLocation,
      required this.lat,
      required this.lng,
      required this.status,
      required this.price,
      required this.quantity,
      required this.userName});

  factory Order.fromJson(Map<String, dynamic> json) {
    double total = 0;

    for (var i = 0; i < json['products'].length; i = i + 1) {
      total += json['products'][i]['qty'];
    }

    var log = Logger();
    log.wtf(total);
    return Order(
      id: json['_id'],
      userName: json['User']['name'],
      quantity: total.toInt(),
      price: json['payable_amount'],
      userId: json['User']['_id'],
      businessId: json['Business'],
      timeOfOrder: json['time_of_order'],
      payableAmount: json['payable_amount'].toDouble(),
      lat: 0, // hardcoded for now, to be changed when backend is fixed
      lng: 0, // hardcoded for now, to be changed when backend is fixed
      deliveryTime:
          json['delivery_time'] != null ? json['delivery_time'] : "50",
      deliveryLocation:
          json['delivery_location'] != null ? json['delivery_time'] : "Behria",
      status: json['status'],
    );
  }
}
