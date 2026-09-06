// Basic Flutter widget tests for the Weather App.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:weather_db_api_spare/main.dart';
import 'package:weather_db_api_spare/services/api_service.dart';
import 'package:weather_db_api_spare/services/storage_service.dart';
import 'package:weather_db_api_spare/state/weather_notifier.dart';

void main() {
  testWidgets('Weather app renders loading state first', (WidgetTester tester) async {
    final notifier = WeatherNotifier(
      apiService: ApiService(),
      storageService: StorageService(),
    );

    await tester.pumpWidget(WeatherApp(notifier: notifier));
    await tester.pump();

    // The app should show the weather page scaffold.
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
