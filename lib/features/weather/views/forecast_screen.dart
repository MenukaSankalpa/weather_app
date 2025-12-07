import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../controllers/weather_provider.dart';
import '../data/models/daily_forecast.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    final forecast = provider.forecast;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          provider.current != null
              ? "${provider.current!.city} – 5 Day Forecast"
              : "Forecast",
        ),
      ),

      body: forecast == null
          ? const Center(
        child: Text(
          "No forecast data.\nSearch for a city first.",
          textAlign: TextAlign.center,
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- TITLE ----------
            const Text(
              "5-Day Temperature Trend",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // ---------- TEMPERATURE LINE CHART ----------
            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: (forecast.days.length - 1).toDouble(),
                  minY: _getMin(forecast.days) - 3,
                  maxY: _getMax(forecast.days) + 3,
                  titlesData: const FlTitlesData(show: false),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      barWidth: 4,
                      color: Colors.blueAccent,
                      dotData: const FlDotData(show: true),
                      spots: _buildSpots(forecast.days),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Next 5 Days",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // ---------- HORIZONTAL FORECAST CARDS ----------
            SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: forecast.days.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final DailyForecast day = forecast.days[index];

                  return _buildDayCard(day);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HELPER: Build Spots For Line Graph
  // ============================================================
  List<FlSpot> _buildSpots(List<DailyForecast> days) {
    return List.generate(
      days.length,
          (index) {
        return FlSpot(
          index.toDouble(),
          days[index].maxTemp,
        );
      },
    );
  }

  double _getMin(List<DailyForecast> days) {
    return days.map((e) => e.minTemp).reduce((a, b) => a < b ? a : b);
  }

  double _getMax(List<DailyForecast> days) {
    return days.map((e) => e.maxTemp).reduce((a, b) => a > b ? a : b);
  }

  // ============================================================
  // UI: Beautiful Forecast Card For Each Day
  // ============================================================
  Widget _buildDayCard(DailyForecast day) {
    String iconUrl = "https://openweathermap.org/img/wn/${day.icon}@2x.png";

    return Container(
      width: 130,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.blueAccent.withOpacity(0.45),
            Colors.indigo.withOpacity(0.35),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _formatDate(day.date),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Image.network(iconUrl, width: 50, height: 50),

          const SizedBox(height: 6),

          Text(
            "${day.maxTemp.toStringAsFixed(1)}°C",
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),

          Text(
            day.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  // Format "2025-02-15" -> "Feb 15"
  String _formatDate(String date) {
    final parts = date.split("-");
    final month = int.parse(parts[1]);
    final day = int.parse(parts[2]);

    const months = [
      "",
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];

    return "${months[month]} $day";
  }
}
