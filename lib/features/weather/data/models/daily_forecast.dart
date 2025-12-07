class DailyForecast {
  final String date;        // example: "2025-02-14"
  final double minTemp;
  final double maxTemp;
  final String icon;
  final String description;

  DailyForecast({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.icon,
    required this.description,
  });
}
