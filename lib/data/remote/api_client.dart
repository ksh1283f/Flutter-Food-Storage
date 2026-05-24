import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

const _baseUrl = 'https://food-storage-back.onrender.com';

class ApiClient {
  ApiClient({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;
  final FirebaseAuth _auth;

  Future<Map<String, String>> _authHeaders() async{
    final token = await _auth.currentUser?.getIdToken();

    return {
      'Content-Type' : 'application/json',
      if(token != null) 'Authorization' : 'Bearer $token',
    };
  }

  Future<T> get<T>(String path) => _request('GET', path);
  Future<T> post<T>(String path, Object body) => _request('POST', path, body: body);
  Future<T> put<T>(String path, Object body) => _request<T>('PUT', path, body: body);
  Future<T> delete<T>(String path) => _request<T>('DELETE', path);

  Future<T> _request<T>(String method, String path, {Object? body}) async {
    final uri = Uri.parse('$_baseUrl$path');
    final headers = await _authHeaders();

    final http.Response response;
    switch (method) {
      case 'POST':
        response = await http.post(uri, headers: headers, body: jsonEncode(body));
      case 'PUT':
        response = await http.put(uri, headers: headers, body: jsonEncode(body));
      case 'DELETE':
        response = await http.delete(uri, headers: headers);
        
      default:
        response = await http.get(uri, headers: headers);
    }

    if(response.statusCode < 200 || response.statusCode >= 300){
      String message = 'HTTP ${response.statusCode}';
      try{
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        message = (json['message'] ?? json['error'] ?? message).toString();
      } catch(_) {
        if(response.body.isNotEmpty) message = response.body;
      }
      throw Exception(message);
    }

    return jsonDecode(response.body) as T;
  }
}