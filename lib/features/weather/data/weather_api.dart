import 'package:dio/dio.dart';
import '../../../core/utils/constants.dart';
import 'models/current_weather.dart';
import 'models/forecast.dart';

class WeatherApi {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // ---------------- CURRENT WEATHER ----------------
  Future<CurrentWeather> fetchCurrentWeather(String city, String units) async {
    try {
      final response = await dio.get(
        "${Constants.baseUrl}/weather",
        queryParameters: {
          "q": city,
          "appid": Constants.apiKey,
          "units": units,
        },
      );

      return CurrentWeather.fromJson(response.data);
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  // ---------------- FORECAST ----------------
  Future<Forecast> fetchForecast(String city, String units) async {
    try {
      final response = await dio.get(
        "${Constants.baseUrl}/forecast",
        queryParameters: {
          "q": city,
          "appid": Constants.apiKey,
          "units": units,
        },
      );

      return Forecast.fromJson(response.data);
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  // ---------------- NO MORE ONECALL API ----------------
  Future<List<dynamic>> fetchAlerts(double lat, double lon) async {
    return []; // always empty, free API does NOT support alerts
  }

  // ---------------- ERROR HANDLER ----------------
  void _handleError(DioException e) {
    if (e.response != null) {
      final code = e.response?.statusCode;

      if (code == 401) {
        throw Exception("401: Invalid API Key");
      } else if (code == 404) {
        throw Exception("404: City not found");
      } else if (code == 429) {
        throw Exception("429: Rate limit exceeded");
      } else {
        throw Exception("API Error: ${e.response?.data}");
      }
    } else {
      throw Exception("Network Error: ${e.message}");
    }
  }
}
