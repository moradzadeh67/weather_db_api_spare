import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/city_model.dart';
import '../models/weather_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

// Enum to represent different Loading/Error states of the app
enum WeatherStatus { loading, success, failure }

class WeatherNotifier extends ChangeNotifier {
  final ApiService _apiService;
  final StorageService _storageService;

  WeatherNotifier({
    required ApiService apiService,
    required StorageService storageService,
  }) : _apiService = apiService,
       _storageService = storageService;

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

    // If we have cached weather, show it immediately while fetching fresh data in background
    if (_weather != null) {
      _status = WeatherStatus.success;
      _isOffline = true; // Temporary status until background fetch finishes
      notifyListeners();
    }

    await fetchWeather();
  }

  // Fetch weather data from internet (for selected city, or default Tehran)
  Future<void> fetchWeather() async {
    // Only show loading if we don't have ANY data (initial state or city change)
    if (_weather == null || _status == WeatherStatus.failure) {
      _status = WeatherStatus.loading;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      // Check for internet connection before making the request
      final connectivityResult = await Connectivity().checkConnectivity();
      final hasNoInternet = connectivityResult.contains(
        ConnectivityResult.none,
      );

      if (hasNoInternet) {
        throw Exception('No internet connection available.');
      }

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
      _errorMessage = null;

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
        _errorMessage = e.toString().contains('internet')
            ? 'No internet connection. Please check your network.'
            : 'Failed to load weather data. Please try again.';
      }
    }
    notifyListeners();
  }

  // Set the searching state immediately (to show loader and clear old errors)
  void startSearch() {
    _isSearching = true;
    _searchError = null;
    _searchResults = [];
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

    // Ensure state is correctly set if startSearch wasn't called manually
    _isSearching = true;
    _searchError = null;
    notifyListeners();

    try {
      final rawResults = await _apiService.searchCities(query);
      final lowercaseQuery = query.trim().toLowerCase();

      // Filter results to only keep those containing the query in name, country, or admin1
      _searchResults = rawResults.where((city) {
        return city.name.toLowerCase().contains(lowercaseQuery) ||
            (city.country != null &&
                city.country!.toLowerCase().contains(lowercaseQuery)) ||
            (city.admin1 != null &&
                city.admin1!.toLowerCase().contains(lowercaseQuery));
      }).toList();
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
