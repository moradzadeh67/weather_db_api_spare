import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/weather_model.dart';
import '../state/weather_notifier.dart';
import 'city_search_page.dart';

class WeatherPage extends StatefulWidget {
  final WeatherNotifier notifier;

  const WeatherPage({super.key, required this.notifier});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  WeatherNotifier get _notifier => widget.notifier;

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to ensure initialization (which notifies listeners)
    // happens after the first frame is built, avoiding "setState() called during build" error.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifier.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        // The Scaffold itself extends behind the status / nav bars.
        // Each child view fills the body edge-to-edge so the gradient
        // covers the entire physical screen.
        extendBodyBehindAppBar: true,
        extendBody: true,
        backgroundColor: const Color(0xFF0B1D33),
        body: ListenableBuilder(
          listenable: _notifier,
          builder: (context, _) {
            return _buildScreen(_notifier);
          },
        ),
      ),
    );
  }

  // Build the main screen based on app status
  Widget _buildScreen(WeatherNotifier notifier) {
    switch (notifier.status) {
      case WeatherStatus.loading:
        return const _LoadingView();
      case WeatherStatus.failure:
        return _ErrorView(
          errorMessage: notifier.errorMessage,
          onRetry: notifier.fetchWeather,
        );
      case WeatherStatus.success:
        return _WeatherView(
          weather: notifier.weather!,
          countryFlag: notifier.selectedCity?.countryFlag ?? '',
          isOffline: notifier.isOffline,
          onRefresh: notifier.fetchWeather,
          onSearch: _openSearch,
        );
    }
  }

  // Open the city search page
  void _openSearch() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CitySearchPage(notifier: widget.notifier),
      ),
    );
  }
}

// ===================== Loading View =====================
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: const Color(0xFF0B1D33)),
        SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(color: Colors.white70),
                SizedBox(height: 20),
                Text(
                  'Loading Weather...',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ===================== Error View =====================
class _ErrorView extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback onRetry;

  const _ErrorView({this.errorMessage, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: const Color(0xFF0B1D33)),
        SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_off, size: 72, color: Colors.white38),
                  const SizedBox(height: 16),
                  const Text(
                    'Could not load weather data',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    errorMessage ?? '',
                    style: const TextStyle(color: Colors.white54, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0B1D33),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ===================== Weather View =====================
class _WeatherView extends StatelessWidget {
  final WeatherModel weather;
  final String countryFlag;
  final bool isOffline;
  final VoidCallback onRefresh;
  final VoidCallback onSearch;

  const _WeatherView({
    required this.weather,
    required this.countryFlag,
    required this.isOffline,
    required this.onRefresh,
    required this.onSearch,
  });

  // ----- Theme palette (light surfaces) -----
  // We render the same gradient for any weather code, but for "sunny / bright"
  // codes the glass cards must stay readable on the bright orange lower half.
  // That's why the cards use a dark translucent fill (see _InfoCard).

  // Get gradient colors based on weather condition
  List<Color> _getBackgroundGradient() {
    if (isOffline) {
      return const [Color(0xFF2C3E50), Color(0xFF555555)];
    }
    switch (weather.weatherCode) {
      case 0:
        // Clear sky / sunny: warm sunrise palette
        return const [Color(0xFF3A6EA5), Color(0xFFD98E3B)];
      case 1:
      case 2:
      case 3:
        return const [Color(0xFF3C4B64), Color(0xFF708090)];
      case 45:
      case 48:
        return const [Color(0xFF5D6D7E), Color(0xFF85929E)];
      case 51:
      case 53:
      case 55:
      case 61:
      case 63:
      case 65:
        return const [Color(0xFF2E4053), Color(0xFF5D6D7E)];
      case 71:
      case 73:
      case 75:
        return const [Color(0xFF85929E), Color(0xFFD5DBDB)];
      case 80:
      case 81:
      case 82:
        return const [Color(0xFF34495E), Color(0xFF7F8C8D)];
      case 95:
      case 96:
      case 99:
        return const [Color(0xFF1A1A2E), Color(0xFF4A4A68)];
      default:
        return const [Color(0xFF0B1D33), Color(0xFF4A90E2)];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use a Stack so the gradient covers the full physical screen
    // (edge-to-edge, behind status & navigation bars), and the
    // scrollable content uses MediaQuery padding to stay clear of
    // the system bars while the background keeps painting under them.
    final media = MediaQuery.of(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _getBackgroundGradient(),
        ),
      ),
      child: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.white24,
        onRefresh: () async => onRefresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            24,
            24 + media.padding.top,
            24,
            24 + media.padding.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search City Button (top right)
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: onSearch,
                  tooltip: 'Search city',
                  icon: const Icon(Icons.search, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withValues(alpha: 0.18),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Offline Warning Banner
              if (isOffline) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.cloud_off, color: Colors.white70, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Offline: showing saved data',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // City Name & Last Updated
              Text(
                '${weather.cityName} $countryFlag'.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28, // افزایش سایز از ۱۸ به ۲۸ برای خوانایی بیشتر
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Last update: ${_formatTime(weather.lastUpdated)}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),

              const SizedBox(height: 40),

              // Main Weather Display
              Text(
                weather.weatherEmoji,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 88),
              ),
              const SizedBox(height: 8),
              Text(
                '${weather.temperature.round()}°C',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 72,
                  fontWeight: FontWeight.w300,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                weather.weatherCondition,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 32),

              // Refresh Button
              Align(
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh, size: 20),
                  label: const Text('Update Weather'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0B1D33),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // Additional Info Grid
              Row(
                children: [
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.water_drop_outlined,
                      label: 'Humidity',
                      value: '${weather.humidity}%',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: '${weather.windSpeed.toStringAsFixed(1)} km/h',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.speed,
                      label: 'Pressure',
                      value: '${weather.pressure.toStringAsFixed(0)} hPa',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.thermostat,
                      label: 'Feels Like',
                      value: '${_calculateFeelsLike(weather).round()}°C',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Format time to HH:mm
  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Simple feels-like calculation using humidity
  double _calculateFeelsLike(WeatherModel weather) {
    // Basic approximation: Humidex-like formula
    final temp = weather.temperature;
    final humidity = weather.humidity;
    final dewPoint = temp - ((100 - humidity) / 5);
    return dewPoint + 5;
  }
}

// ===================== Info Card =====================
// Glass card: dark translucent fill with subtle border so it stays
// readable on BOTH dark and bright (sunny) gradient backgrounds.
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Dark translucent surface -> contrasts well with bright orange
        // as well as with dark night gradients.
        color: Colors.black.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
