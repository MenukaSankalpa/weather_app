class CurrentWeather {
  final String city;
  final double temp;
  final String description;
  final double lat;
  final double lon;

  CurrentWeather({
    required this.city,
    required this.temp,
    required this.description,
    required this.lat,
    required this.lon,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      city: json["name"],
      temp: (json["main"]["temp"] as num).toDouble(),
      description: json["weather"][0]["description"],
      lat: (json["coord"]["lat"] as num).toDouble(),
      lon: (json["coord"]["lon"] as num).toDouble(),
    );
  }
}
