import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:logger/logger.dart';

class NetworkHandler {
  String baseurl = 'https://balti.herokuapp.com/api/';
  var log = Logger();
  FlutterSecureStorage storage = FlutterSecureStorage();

  Future<dynamic> get(String url) async {
    url = formatter(url);
    // String token = await storage.read(key: 'token');
    var resp = await http.get(Uri.parse(url));

    if (resp.statusCode == 200 || resp.statusCode == 201) {
      log.i(resp.body);
      return json.decode(resp.body);
    }
  }

  Future<http.Response> post(String url, Map<String, String> body) async {
    url = formatter(url);
    // String token = await storage.read(key: 'token');
    var response = await http.post(Uri.parse(url),
        headers: {"Content-type": "application/json"}, body: json.encode(body));

    print(response);
    return response;
  }

  Future<http.Response> patch(String url, Map<String, String> body) async {
    url = formatter(url);
    // String? token = await storage.read(key: 'token');
    var response = await http.patch(Uri.parse(url),
        headers: {"Content-type": "application/json"}, body: json.encode(body));

    print(response);
    return response;
  }

  Future<http.StreamedResponse> patchImage(String url, String filepath) async {
    url = formatter(url);
    String? token = await storage.read(key: 'token');
    var request = http.MultipartRequest('PATCH', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath("img", filepath));
    request.headers.addAll({
      "Content-type": "multipart/form-data",
      "Authorization": "Bearer $token"
    });
    var response = request.send();
    print(response);
    return response;
  }

  String formatter(url) {
    return baseurl + url;
  }
}
