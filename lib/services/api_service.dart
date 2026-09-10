import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/city_model.dart';
import '../models/weather_model.dart';

class ApiService {
  // Base URL for Open-Meteo Free API
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  // Base URL for Open-Meteo Geocoding API (city search)
  static const String _geoBaseUrl =
      'https://geocoding-api.open-meteo.com/v1/search';

  // Default coordinates for Tehran, Iran
  static const double _defaultLat = 35.6892;
  static const double _defaultLon = 51.3890;

  // Fetch Weather Data from API
  Future<WeatherModel> fetchWeather({
    double latitude = _defaultLat,
    double longitude = _defaultLon,
    String cityName = 'Tehran',
  }) async {
    final url = Uri.parse(
      '$_baseUrl?latitude=$latitude&longitude=$longitude&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m,surface_pressure',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return WeatherModel.fromApiJson(data, cityName);
      } else {
        throw Exception(
          'Server error with status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to connect to weather service: $e');
    }
  }

  // Search for cities by name using Open-Meteo Geocoding API
  Future<List<CityModel>> searchCities(String query) async {
    final url = Uri.parse(
      '$_geoBaseUrl?name=${Uri.encodeQueryComponent(query)}&count=25&format=json',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final results = (data['results'] as List<dynamic>?) ?? [];
        return results
            .map((e) => CityModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Server error with status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to search cities: $e');
    }
  }
}
