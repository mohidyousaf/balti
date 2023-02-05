// ignore_for_file: file_names
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../models/business.dart';
import '../repository/networkHandler.dart';

var nw = NetworkHandler();

class Businesses with ChangeNotifier {
  // final String authToken;
  final String userId;
  Businesses({
    // required this.authToken,
    required this.businesses,
    required this.userId,
  });

  List<Business> businesses = [];

  List<Business> get getBusinesses {
    return [...businesses];
  }

  Future<void> findByUserId(String id) async {
    print({userId: id});
    businesses = [];

    dynamic response;
    try {
      response = await nw.get("businesses/list/$id");
    } catch (e) {
      debugPrint('debug: $e');
    }

    print(response.length);
    if (response.length > 0) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      for (var i = 0; i < response.length; i = i + 1) {
        print("********************");
        print({i: response[i]});
        print(response[i]['location']);
        // print(response[i]?.location?.coordinates);
        try {
          businesses.add(Business.fromJson(response[i]));
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
    print({businesses});
    notifyListeners();
  }

  Future<void> addBusiness(Business business) async {
    //Send Api call to server for add
    final response = await http.post(
      Uri.parse('https://balti.herokuapp.com/api/businesses'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user": business.ownerId,
        "name": business.name,
        "type": business.type,
        "description": business.description,
        "image": business.imageUrl,
        "phoneNumber": business.phoneNumber,
        "delivery_charges": business.deliveryCharges,
        "latitude": business.lat,
        "longitude": business.lng,
        "locationDesc": business.locationDescription,
      }),
    );
    print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
    if (response.statusCode == 200) {
      print("Business Created");
      businesses.add(Business.fromJson(jsonResponse));
      notifyListeners();
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create business.');
    }
  }

  Future<void> editBusiness(Business business) async {
    //Send Api call to server for edit
    final response = await http.put(
      Uri.parse('https://balti.herokuapp.com/api/businesses/${business.id}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user": business.ownerId,
        "name": business.name,
        "type": business.type,
        "description": business.description,
        "image": business.imageUrl,
        "phoneNumber": business.phoneNumber,
        "delivery_charges": business.deliveryCharges,
        "latitude": business.lat,
        "longitude": business.lng,
        "locationDesc": business.locationDescription,
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print("Successfully edited business");
      print(jsonDecode(response.body));
      // return jsonDecode(response.body).id;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to edit business.');
    }
    notifyListeners();
  }

  Future<void> deleteBusiness(String id) async {
    //Send Api call to server for delete
    final response = await http
        .delete(Uri.parse('https://balti.herokuapp.com/api/businesses/$id'));
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print("Successfully deleted business");
      print(jsonDecode(response.body));
      // return jsonDecode(response.body).id;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to edit business.');
    }
    notifyListeners();
  }

  Future<void> getAllBusinesses() async {
    //Send Api call to server for delete
    final response =
        await http.get(Uri.parse('https://balti.herokuapp.com/api/businesses'));

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      var jsonResponse = jsonDecode(response.body);
      for (var i = 0; i < jsonResponse.length; i = i + 1) {
        print("********************");
        // print(jsonResponse[i]);
        businesses.add(Business.fromJson(jsonResponse[i]));
      }
    } else {
      throw Exception('Failed to load album');
    }
    notifyListeners();
  }

  Future<void> fetchAndSetBusinesses() async {
    businesses = [
      Business(
          id: '2',
          ownerId: '2',
          name: 'Arcadian Cafe',
          phoneNumber: '2345678',
          type: 'Restaurant',
          lat: 12.01,
          lng: 22.1,
          description: 'Finest dining in the city',
          imageUrl: 'assets/images/arcadian.jpg',
          rating: 4.5,
          deliveryCharges: 200,
          locationDescription: ""),
      Business(
          id: '1',
          ownerId: '2',
          name: 'Subway',
          phoneNumber: '98765432',
          type: 'Restaurant',
          lat: 10.01,
          lng: 20.1,
          description: 'Find the best sandwiches in the city',
          imageUrl: 'assets/images/subway.png',
          rating: 4.0,
          deliveryCharges: 0,
          locationDescription: ""),
    ];
    //Fetch products from api and set local products list
    notifyListeners();
  }
}
