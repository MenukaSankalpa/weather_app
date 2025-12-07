
import 'daily_forecast.dart';

class Forecast {
  final List<DailyForecast> days;

  Forecast({required this.days});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    List<dynamic> list = json["list"];

    Map<String, List<dynamic>> grouped = {};

    // Group entries by date (yyyy-mm-dd)
    for (var entry in list) {
      String dtTxt = entry["dt_txt"];
      String date = dtTxt.split(" ")[0];

      grouped.putIfAbsent(date, () => []);
      grouped[date]!.add(entry);
    }

    List<DailyForecast> finalDays = [];

    // Convert grouped data to DailyForecast objects
    grouped.forEach((date, entries) {
      double min = entries.first["main"]["temp_min"];
      double max = entries.first["main"]["temp_max"];
      String icon = entries.first["weather"][0]["icon"];
      String desc = entries.first["weather"][0]["description"];

      for (var e in entries) {
        double tMin = e["main"]["temp_min"];
        double tMax = e["main"]["temp_max"];
        if (tMin < min) min = tMin;
        if (tMax > max) max = tMax;
      }

      finalDays.add(
        DailyForecast(
          date: date,
          minTemp: min,
          maxTemp: max,
          icon: icon,
          description: desc,
        ),
      );
    });

    // Keep only 5 days
    finalDays.sort((a, b) => a.date.compareTo(b.date));

    return Forecast(days: finalDays.take(5).toList());
  }
}
