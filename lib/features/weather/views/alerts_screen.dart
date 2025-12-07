import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/weather_provider.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    final alerts = provider.alerts;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather Alerts",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.2),
              Theme.of(context).colorScheme.surface.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: alerts.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: alerts.length,
          itemBuilder: (context, index) {
            final alert = alerts[index];
            return _buildAnimatedAlertCard(alert, index);
          },
        ),
      ),
    );
  }

  // ------------------------------------------
  // Modern Empty UI
  // ------------------------------------------
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none,
              size: 90, color: Colors.grey.withOpacity(0.6)),
          const SizedBox(height: 15),
          const Text(
            "No Weather Alerts",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            "There are currently no weather warnings.",
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          )
        ],
      ),
    );
  }

  // ------------------------------------------
  // Modern Alert Card
  // ------------------------------------------
  Widget _buildAnimatedAlertCard(Map<String, dynamic> alert, int index) {
    return AnimatedPadding(
      duration: Duration(milliseconds: 300 + (index * 80)),
      padding: const EdgeInsets.only(bottom: 14),
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 500 + (index * 80)),
        opacity: 1,
        child: _alertCard(alert),
      ),
    );
  }

  // ------------------------------------------
  // Glass-style gradient card
  // ------------------------------------------
  Widget _alertCard(Map<String, dynamic> alert) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            Colors.redAccent.withOpacity(0.15),
            Colors.orange.withOpacity(0.10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.redAccent.withOpacity(0.3),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Alert Title Row
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded,
                    size: 32, color: Colors.redAccent),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    alert["event"] ?? "Weather Alert",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 14),

            // Description
            Text(
              alert["description"] ?? "No details available.",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 14),

            // Source + dates
            Row(
              children: [
                const Icon(Icons.account_tree_rounded,
                    size: 18, color: Colors.deepOrange),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "Source: ${alert["sender_name"] ?? "Unknown"}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: Colors.blue),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "From: ${_format(alert["start"])}",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.timer_off, size: 18, color: Colors.red),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "Until: ${_format(alert["end"])}",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Convert timestamps safely
  String _format(dynamic value) {
    if (value == null) return "N/A";
    return DateTime.fromMillisecondsSinceEpoch(value * 1000).toString();
  }
}
