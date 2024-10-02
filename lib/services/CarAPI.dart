import 'dart:convert';
import '../model/Car.dart';
import 'package:http/http.dart' as http;

class CarAPI {
  static const apiServer = 'extranet.esimed.fr:3333';
  static const carRoute = '/car';

  // Pass the token as a parameter to this method
  static Future<List<Car>> getAll(String token) async {
    try {
      final response = await http.get(
        Uri.http(apiServer, carRoute),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> result = await jsonDecode(response.body);
        return result.map((json) => Car.fromMap(json)).toList();
      } else {
        throw Exception('Failed to load cars');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static addCar(String token, Car car) async {
    final response = await http.post(
      Uri.http(apiServer, carRoute),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: car.toMap(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to insert car');
    }

    return car;
  }

  static deleteCar(String token, int id) async {
    final response = await http.delete(
      Uri.http(apiServer, '$carRoute/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete car');
    }

    return response;
  }

  static editCar(String token, Car car) async {
    final response = await http.put(
      Uri.http(apiServer, carRoute),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: car.toMap(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update car ${response.statusCode}');
    }

    return response;
  }
}
