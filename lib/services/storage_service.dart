import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../models/city_model.dart';
import '../models/weather_model.dart';

class StorageService {
  static const String _fileName = 'cached_weather_data.json';
  static const String _cityFileName = 'selected_city.json';

  // Get path to local file inside app's documents directory
  Future<File> _getLocalFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }

  // ==================== Weather Cache ====================

  // Save WeatherModel to local storage as JSON
  Future<void> saveWeather(WeatherModel weather) async {
    try {
      final file = await _getLocalFile(_fileName);
      final jsonString = jsonEncode(weather.toJson());
      await file.writeAsString(jsonString);
    } catch (e) {
      // Fail silently or log error
      debugPrint('Error saving cached weather: $e');
    }
  }

  // Load WeatherModel from local storage
  Future<WeatherModel?> loadWeather() async {
    try {
      final file = await _getLocalFile(_fileName);
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        return WeatherModel.fromJson(jsonMap);
      }
    } catch (e) {
      debugPrint('Error loading cached weather: $e');
    }
    return null; // Return null if file doesn't exist or loading fails
  }

  // ==================== Selected City ====================

  // Save selected city to local storage
  Future<void> saveSelectedCity(CityModel city) async {
    try {
      final file = await _getLocalFile(_cityFileName);
      final jsonString = jsonEncode(city.toJson());
      await file.writeAsString(jsonString);
    } catch (e) {
      debugPrint('Error saving selected city: $e');
    }
  }

  // Load selected city from local storage
  Future<CityModel?> loadSelectedCity() async {
    try {
      final file = await _getLocalFile(_cityFileName);
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        return CityModel.fromJson(jsonMap);
      }
    } catch (e) {
      debugPrint('Error loading selected city: $e');
    }
    return null;
  }

  // Clear all cached data
  Future<void> clearCache() async {
    try {
      final weatherFile = await _getLocalFile(_fileName);
      if (await weatherFile.exists()) {
        await weatherFile.delete();
      }
      final cityFile = await _getLocalFile(_cityFileName);
      if (await cityFile.exists()) {
        await cityFile.delete();
      }
    } catch (e) {
      debugPrint('Error deleting cached files: $e');
    }
  }
}
