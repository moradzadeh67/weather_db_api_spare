import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mcp_toolkit/mcp_toolkit.dart';
import 'dart:async';

import 'pages/weather_page.dart';
import 'services/api_service.dart';
import 'services/storage_service.dart';
import 'state/weather_notifier.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize MCP Toolkit
      MCPToolkitBinding.instance
        ..initialize()
        ..initializeFlutterToolkit();

      // Full screen (Edge-to-Edge): draw behind status & navigation bars
      // with transparent bars on all Android versions (and iOS status bar).
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
          // Light icons on the dark weather background
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );

      // Simple dependency injection (no extra packages needed)
      final weatherNotifier = WeatherNotifier(
        apiService: ApiService(),
        storageService: StorageService(),
      );

      runApp(WeatherApp(notifier: weatherNotifier));
    },
    (error, stack) {
      // Handle zone errors for MCP server error reporting
      MCPToolkitBinding.instance.handleZoneError(error, stack);
    },
  );
}

class WeatherApp extends StatelessWidget {
  final WeatherNotifier notifier;

  const WeatherApp({super.key, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B1D33)),
      ),
      home: WeatherPage(notifier: notifier),
    );
  }
}
