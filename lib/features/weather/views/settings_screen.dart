import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/weather_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: provider.isDark,
            onChanged: (v) => provider.toggleTheme(),
          ),
        ],
      ),
    );
  }
}
