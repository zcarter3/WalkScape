import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Lightweight weather service using Open-Meteo (free, no API key needed).
/// Uses device IP geolocation as fallback when GPS isn't available.
class WeatherService {
  WeatherService._();
  static final WeatherService instance = WeatherService._();

  static const String _keyCachedWeather = 'weather_condition';
  static const String _keyCachedTemp = 'weather_temp';
  static const String _keyCachedCity = 'weather_city';
  static const String _keyCachedTime = 'weather_cached_at';

  final Dio _dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 8)));

  String _condition = '';
  double _tempC = 0;
  String _city = '';

  String get condition => _condition.isEmpty ? _fallbackCondition() : _condition;
  double get tempC => _tempC;
  String get city => _city;
  int get tempF => (_tempC * 9 / 5 + 32).round();

  /// Fetch weather once; results are cached for 30 minutes.
  Future<void> refresh() async {
    final prefs = await SharedPreferences.getInstance();

    // Use cache if fresh enough (30 min).
    final cachedAt = prefs.getInt(_keyCachedTime) ?? 0;
    if (DateTime.now().millisecondsSinceEpoch - cachedAt < 1800000 &&
        prefs.getString(_keyCachedWeather) != null) {
      _condition = prefs.getString(_keyCachedWeather) ?? '';
      _tempC = prefs.getDouble(_keyCachedTemp) ?? 0;
      _city = prefs.getString(_keyCachedCity) ?? '';
      if (_condition.isNotEmpty) return;
    }

    try {
      // Step 1: Get approximate location from IP.
      final geoResp = await _dio.get('https://ipapi.co/json/');
      final geoData = geoResp.data is String ? jsonDecode(geoResp.data) : geoResp.data;
      final double lat = (geoData['latitude'] as num).toDouble();
      final double lon = (geoData['longitude'] as num).toDouble();
      _city = geoData['city'] as String? ?? '';

      // Step 2: Get current weather from Open-Meteo (no key needed).
      final wxResp = await _dio.get(
        'https://api.open-meteo.com/v1/forecast',
        queryParameters: {
          'latitude': lat,
          'longitude': lon,
          'current_weather': true,
        },
      );
      final wxData = wxResp.data is String ? jsonDecode(wxResp.data) : wxResp.data;
      final current = wxData['current_weather'] as Map<String, dynamic>;

      _tempC = (current['temperature'] as num).toDouble();
      final int wmoCode = (current['weathercode'] as num).toInt();
      _condition = _wmoToCondition(wmoCode);

      // Persist.
      await prefs.setString(_keyCachedWeather, _condition);
      await prefs.setDouble(_keyCachedTemp, _tempC);
      await prefs.setString(_keyCachedCity, _city);
      await prefs.setInt(_keyCachedTime, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      debugPrint('WeatherService: $e');
      // Fall back to cached or time-based.
      _condition = prefs.getString(_keyCachedWeather) ?? _fallbackCondition();
    }
  }

  /// WMO weather interpretation codes → human-readable condition.
  String _wmoToCondition(int code) {
    if (code == 0) return 'Clear';
    if (code == 1) return 'Sunny';
    if (code <= 3) return 'Cloudy';
    if (code <= 49) return 'Foggy';
    if (code <= 59) return 'Drizzle';
    if (code <= 69) return 'Rainy';
    if (code <= 79) return 'Snowy';
    if (code <= 84) return 'Rainy';
    if (code <= 86) return 'Snowy';
    if (code <= 99) return 'Stormy';
    return 'Cloudy';
  }

  /// Time-of-day fallback when network is unavailable.
  String _fallbackCondition() {
    final h = DateTime.now().hour;
    if (h >= 6 && h < 12) return 'Sunny';
    if (h >= 12 && h < 18) return 'Cloudy';
    return 'Clear';
  }
}
