import 'package:flutter/foundation.dart';

import '../models/city_model.dart';
import '../models/weather_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

// Enum to represent different Loading/Error states of the app
enum WeatherStatus { loading, success, failure }

class WeatherNotifier extends ChangeNotifier {
  final ApiService _apiService;
  final StorageService _storageService;

  WeatherNotifier({required this._apiService, required this._storageService});

  WeatherStatus _status = WeatherStatus.loading;
  WeatherModel? _weather;
  bool _isOffline = false;
  String? _errorMessage;

  // City search state
  CityModel? _selectedCity;
  bool _isSearching = false;
  List<CityModel> _searchResults = [];
  String? _searchError;

  WeatherStatus get status => _status;
  WeatherModel? get weather => _weather;
  bool get isOffline => _isOffline;
  String? get errorMessage => _errorMessage;

  CityModel? get selectedCity => _selectedCity;
  bool get isSearching => _isSearching;
  List<CityModel> get searchResults => _searchResults;
  String? get searchError => _searchError;

  // Initialize App: Load saved city, cached data, then fetch fresh from internet
  Future<void> initialize() async {
    _selectedCity = await _storageService.loadSelectedCity();
    _weather = await _storageService.loadWeather();
    await fetchWeather();
  }

  // Fetch weather data from internet (for selected city, or default Tehran)
  Future<void> fetchWeather() async {
    _status = WeatherStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final city = _selectedCity;
      final freshWeather = city == null
          ? await _apiService.fetchWeather()
          : await _apiService.fetchWeather(
              latitude: city.latitude,
              longitude: city.longitude,
              cityName: city.name,
            );
      _weather = freshWeather;
      _isOffline = false;
      _status = WeatherStatus.success;

      // Save fresh data to local storage for offline fallback
      await _storageService.saveWeather(freshWeather);
    } catch (e) {
      // If there is cached data, show it with offline status
      if (_weather != null) {
        _isOffline = true;
        _status = WeatherStatus.success;
        _errorMessage = 'Offline: showing cached data';
      } else {
        // No cache and no internet -> show failure state
        _isOffline = false;
        _status = WeatherStatus.failure;
        _errorMessage = 'Failed to load weather data. Please try again.';
      }
    }
    notifyListeners();
  }

  // Search for cities using the Geocoding API
  Future<void> searchCities(String query) async {
    if (query.trim().isEmpty) {
      _isSearching = false;
      _searchResults = [];
      _searchError = null;
      notifyListeners();
      return;
    }

    _isSearching = true;
    _searchError = null;
    notifyListeners();

    try {
      _searchResults = await _apiService.searchCities(query);
    } catch (e) {
      _searchResults = [];
      _searchError = 'Search failed. Please check your connection.';
    }
    _isSearching = false;
    notifyListeners();
  }

  // Select a city and fetch its weather
  Future<void> selectCity(CityModel city) async {
    _selectedCity = city;
    await _storageService.saveSelectedCity(city);
    await fetchWeather();
  }

  // Reset search state (e.g. when entering the search page)
  void resetSearch() {
    _isSearching = false;
    _searchResults = [];
    _searchError = null;
    notifyListeners();
  }
}
