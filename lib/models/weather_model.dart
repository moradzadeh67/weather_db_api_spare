class WeatherModel {
  final double temperature;
  final int humidity;
  final double windSpeed;
  final double pressure;
  final int weatherCode;
  final String cityName;
  final DateTime lastUpdated;

  WeatherModel({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.weatherCode,
    required this.cityName,
    required this.lastUpdated,
  });

  // Factory constructor for creating a WeatherModel from API response JSON
  factory WeatherModel.fromApiJson(Map<String, dynamic> json, String cityName) {
    final current = json['current'] as Map<String, dynamic>;
    return WeatherModel(
      temperature: (current['temperature_2m'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).toInt(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      pressure: (current['surface_pressure'] as num).toDouble(),
      weatherCode: (current['weather_code'] as num).toInt(),
      cityName: cityName,
      lastUpdated: DateTime.now(),
    );
  }

  // Factory constructor for creating a WeatherModel from Saved Local JSON
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toInt(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      pressure: (json['pressure'] as num).toDouble(),
      weatherCode: (json['weatherCode'] as num).toInt(),
      cityName: json['cityName'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  // Convert WeatherModel to JSON map for Local Storage
  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'pressure': pressure,
      'weatherCode': weatherCode,
      'cityName': cityName,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  // Helper method to get readable weather condition text based on WMO code
  String get weatherCondition {
    switch (weatherCode) {
      case 0:
        return 'Clear Sky';
      case 1:
      case 2:
      case 3:
        return 'Partly Cloudy';
      case 45:
      case 48:
        return 'Foggy';
      case 51:
      case 53:
      case 55:
        return 'Drizzle';
      case 61:
      case 63:
      case 65:
        return 'Rainy';
      case 71:
      case 73:
      case 75:
        return 'Snowy';
      case 80:
      case 81:
      case 82:
        return 'Rain Showers';
      case 95:
      case 96:
      case 99:
        return 'Thunderstorm';
      default:
        return 'Unknown';
    }
  }

  // Helper method to get weather emoji
  String get weatherEmoji {
    switch (weatherCode) {
      case 0:
        return '☀️';
      case 1:
      case 2:
      case 3:
        return '🌤️';
      case 45:
      case 48:
        return '🌫️';
      case 51:
      case 53:
      case 55:
        return '🌧️';
      case 61:
      case 63:
      case 65:
        return '🌧️';
      case 71:
      case 73:
      case 75:
        return '❄️';
      case 80:
      case 81:
      case 82:
        return '🌦️';
      case 95:
      case 96:
      case 99:
        return '⚡';
      default:
        return '🌡️';
    }
  }
}
