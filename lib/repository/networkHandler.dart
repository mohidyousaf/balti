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
    log.i(url);
    // String token = await storage.read(key: 'token');
    var resp = await http.get(Uri.parse(url));
    log.wtf(resp.body);

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

    if (response.statusCode == 200) {
      log.d(response.statusCode);
      // log.wtf(jsonDecode(response.body));
      return response;
    } else {
      log.e(response.statusCode);
      throw Exception('Failed to load album');
    }
  }

  Future<http.Response> patch(String url, Map<String, String> body) async {
    url = formatter(url);
    // String? token = await storage.read(key: 'token');
    var response = await http.patch(Uri.parse(url),
        headers: {"Content-type": "application/json"}, body: json.encode(body));

    log.wtf(response.statusCode);
    return response;
  }

  Future<http.Response> put(String url, Map<String, String> body) async {
    url = formatter(url);
    // String token = await storage.read(key: 'token');
    var response = await http.put(Uri.parse(url),
        headers: {"Content-type": "application/json"}, body: json.encode(body));

    log.i(response, response.body);
    return response;
  }

  Future<String> postDataWithImage(
      String url, String filepath, Map<String, String> body) async {
    url = formatter(url);
    log.d(url);
    // String? token = await storage.read(key: 'token');
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    dynamic request;
    try {
      request = http.MultipartRequest('POST', Uri.parse(url))
        ..headers.addAll(headers)
        ..files.add(await http.MultipartFile.fromPath("img", filepath))
        ..fields.addAll(body);
    } catch (e) {
      log.e(e);
    }
    log.d(request);

    var response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      log.i(response);
      return "added";
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<String> postDataWithImages(
      String url, List<String> filepath, Map<String, String> body) async {
    url = formatter(url);
    log.d(url);
    // String? token = await storage.read(key: 'token');
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    dynamic request;
    try {
      request = http.MultipartRequest('POST', Uri.parse(url));
      if (filepath.isNotEmpty) {
        for (var i = 0; i < filepath.length; i++) {
          request.files
              .add(await http.MultipartFile.fromPath("img", filepath[i]));
        }
      }
      request.headers.addAll(headers);
      request.fields.addAll(body);
    } catch (e) {
      log.e(e);
    }
    log.d(request);

    var response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      log.i(response);
      return "product added";
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  String formatter(url) {
    return baseurl + url;
  }
}
