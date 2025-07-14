import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../error/failures.dart';

class ApiClient {
  final http.Client client;

  ApiClient({required this.client});

  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await client
          .get(
            Uri.parse('${ApiConstants.baseUrl}$endpoint'),
            headers: {
              'Content-Type': 'application/json',
              'x-api-key': 'reqres-free-v1',
            },
          )
          .timeout(
            Duration(milliseconds: ApiConstants.connectionTimeout),
          );

      return _handleResponse(response);
    } catch (e) {
      throw ServerFailure('Failed to fetch data: $e');
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await client
          .post(
            Uri.parse('${ApiConstants.baseUrl}$endpoint'),
            headers: {
              'Content-Type': 'application/json',
              'x-api-key': 'reqres-free-v1',
            },
            body: json.encode(body),
          )
          .timeout(
            Duration(milliseconds: ApiConstants.connectionTimeout),
          );

      return _handleResponse(response);
    } catch (e) {
      throw ServerFailure('Failed to create data: $e');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw ServerFailure(
        'Server error: ${response.statusCode} - ${response.reasonPhrase}',
      );
    }
  }
} 