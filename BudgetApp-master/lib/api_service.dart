// lib/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {

  static const String _baseUrl = 'http://192.168.1.120:8000/api'; 
  
  final _storage = const FlutterSecureStorage();

  Future<void> _saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
  
  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
  }


  Future<bool> login(String email, String password) async {

    final url = Uri.parse('$_baseUrl/auth/login.php'); 

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          await _saveToken(data['token']);
          return true;
        }
      }
      return false;
    } catch (e) {
      print("Erreur réseau (login): $e");
      return false;
    }
  }
  Future<Map<String, dynamic>> register(String email, String password) async {
    final url = Uri.parse('$_baseUrl/auth/register.php');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      return {
        'success': response.statusCode < 300,
        'message': data['message'] ?? 'Ein unbekannter Fehler ist aufgetreten'
      };
    
    } catch (e) {
      print("Erreur réseau (register): $e");
      return {
        'success': false,
        'message': 'Netzwerkfehler. Bitte versuchen Sie es später erneut.'
      };
    }
  }  


Future<Map<String, dynamic>?> getBudgets({required int year, required int month}) async {
  final token = await getToken();
  if (token == null) return null;


  final url = Uri.parse('$_baseUrl/budgets/budgets.php?year=$year&month=$month'); 

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  } catch (e) {
    print("Erreur réseau (getBudgets): $e");
    return null;
  }
}


  Future<List<dynamic>?> getCategories() async {

    final url = Uri.parse('$_baseUrl/categories/categories.php');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data['data'];
        }
      }
      return null;
    } catch (e) {
      print("Erreur réseau (getCategories): $e");
      return null;
    }
  }
  Future<bool> addBudget({
    required String name,
    required int categoryId,
    required double amount,
    required String type,
  }) async {
    final token = await getToken();
    if (token == null) return false;

    final url = Uri.parse('$_baseUrl/budgets/budgets.php');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'category_id': categoryId,
          'amount': amount,
          'type': type,
        }),
      );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] ?? false;
    }
    return false;
  } catch (e) {
    print("Erreur réseau (addBudget): $e");
    return false;
  }
}

Future<bool> addCategory({
  required String name,
  required double budget,
}) async {
  final token = await getToken();
  if (token == null) return false;

  final url = Uri.parse('$_baseUrl/categories/categories.php');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'budget': budget,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] ?? false;
    }
    return false;
  } catch (e) {
    print("Erreur réseau (addCategory): $e");
    return false;
  }
}
}