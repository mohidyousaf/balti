class Cart {
  final String id;
  final String userId;
  final String businessId;

  Cart({
    required this.id,
    required this.userId,
    required this.businessId,
  });
}




// import 'package:flutter/foundation.dart';

// class CartProduct {
//   final String productId;
//   final String productQuantity;
//   final String productImages;

//   CartProduct({
//     required this.productId,
//     required this.productQuantity,
//     required this.productImages,
//   });

//   factory CartProduct.fromJson(Map<String, dynamic> json) {
//     return CartProduct(
//         productId: json['_id'],
//         productQuantity: json["qty"],
//         productImages: json["Images"]);
//   }
// }
