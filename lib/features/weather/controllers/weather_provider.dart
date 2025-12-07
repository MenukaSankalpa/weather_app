import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/weather_api.dart';
import '../data/models/current_weather.dart';
import '../data/models/forecast.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherApi api = WeatherApi();

  CurrentWeather? current;
  Forecast? forecast;

  bool isDark = false;
  bool isLoading = false;

  List<String> favorites = [];
  String units = "metric";

  // API error message
  String? errorMessage;

  // Alerts (disabled because OneCall API requires paid plan)
  List<dynamic> alerts = [];

  // ----------------------------------------------------
  // INITIAL LOAD
  // ----------------------------------------------------
  Future<void> loadInitial() async {
    var settings = Hive.box("settings");
    var favBox = Hive.box("favorites");

    isDark = settings.get("dark", defaultValue: false);
    units = settings.get("units", defaultValue: "metric");
    favorites = List<String>.from(favBox.get("cities", defaultValue: []));

    notifyListeners();
  }

  // ----------------------------------------------------
  // FETCH CITY WEATHER + FORECAST (NO ALERTS)
  // ----------------------------------------------------
  Future<void> fetchCity(String city) async {
    if (city.trim().isEmpty) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // 1. Current weather
      current = await api.fetchCurrentWeather(city, units);

      // 2. Forecast
      forecast = await api.fetchForecast(city, units);

      // 3. Alerts not supported with free API
      alerts = []; // Always empty

    } catch (e) {
      print("ERROR FETCHING WEATHER: $e");

      current = null;
      forecast = null;
      alerts = [];

      final msg = e.toString();

      if (msg.contains("401")) {
        errorMessage = "Invalid API key. Please update your API key.";
      } else if (msg.contains("404")) {
        errorMessage = "City not found. Check the spelling.";
      } else if (msg.contains("SocketException")) {
        errorMessage = "No internet connection.";
      } else {
        errorMessage = "Unknown error. Try again.";
      }
    }

    isLoading = false;
    notifyListeners();
  }

  // ----------------------------------------------------
  // TOGGLE THEME
  // ----------------------------------------------------
  void toggleTheme() {
    isDark = !isDark;
    Hive.box("settings").put("dark", isDark);
    notifyListeners();
  }

  // ----------------------------------------------------
  // CHANGE UNITS
  // ----------------------------------------------------
  void changeUnits(String value) {
    units = value;
    Hive.box("settings").put("units", units);
    notifyListeners();
  }

  // ----------------------------------------------------
  // FAVORITES
  // ----------------------------------------------------
  void addFavorite(String city) {
    if (!favorites.contains(city)) {
      favorites.add(city);
      Hive.box("favorites").put("cities", favorites);
      notifyListeners();
    }
  }

  void removeFavorite(String city) {
    favorites.remove(city);
    Hive.box("favorites").put("cities", favorites);
    notifyListeners();
  }
}
