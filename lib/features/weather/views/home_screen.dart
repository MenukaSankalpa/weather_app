import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/weather_provider.dart';
import 'favorites_screen.dart';
import 'forecast_screen.dart';
import 'alerts_screen.dart';
import 'settings_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController cityCtrl = TextEditingController();
  int _currentIndex = 0;

  // ----------------------------------------------------------
  // All Navigation Screens
  // ----------------------------------------------------------
  List<Widget> get _screens {
    return [
      _homeView(), // Home
      FavoritesScreen(
        onSelectCity: () {
          setState(() => _currentIndex = 0);
        },
      ),
      const ForecastScreen(),
      const AlertsScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Weather App"),
        actions: [
          IconButton(
            icon: Icon(provider.isDark ? Icons.dark_mode : Icons.light_mode),
            onPressed: provider.toggleTheme,
          ),
        ],
      ),

      body: _screens[_currentIndex],

      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // ----------------------------------------------------------
  // Modern Bottom Navigation Bar
  // ----------------------------------------------------------
  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.deepPurpleAccent,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        setState(() => _currentIndex = index);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star_border),
          label: "Favorites",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.show_chart),
          label: "Forecast",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.warning_amber_rounded),
          label: "Alerts",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Settings",
        ),
      ],
    );
  }

  // ----------------------------------------------------------
  // HOME MAIN VIEW
  // ----------------------------------------------------------
  Widget _homeView() {
    return Consumer<WeatherProvider>(
      builder: (context, provider, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: _buildBackground(context),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildSearchBox(provider),
                const SizedBox(height: 30),

                // ------ SHOW LOADER ------
                if (provider.isLoading)
                  const CircularProgressIndicator(),

                // ------ SHOW ERROR MESSAGE ------
                if (!provider.isLoading && provider.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      provider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                // ------ SHOW WEATHER CARD ------
                if (!provider.isLoading &&
                    provider.errorMessage == null &&
                    provider.current != null)
                  _buildWeatherCard(provider),

                // ------ EMPTY UI ------
                if (!provider.isLoading &&
                    provider.errorMessage == null &&
                    provider.current == null)
                  _buildEmptyState(),
              ],
            ),
          ),
        );
      },
    );
  }

  // Background gradient
  BoxDecoration _buildBackground(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Theme.of(context).colorScheme.primary.withOpacity(0.25),
          Theme.of(context).colorScheme.secondary.withOpacity(0.18),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  // ----------------------------------------------------------
  // Search Box UI
  // ----------------------------------------------------------
  Widget _buildSearchBox(WeatherProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Colors.white70),
          const SizedBox(width: 10),

          Expanded(
            child: TextField(
              controller: cityCtrl,
              style: const TextStyle(fontSize: 18, color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Enter city name...",
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
            ),
          ),

          ElevatedButton(
            onPressed: () => provider.fetchCity(cityCtrl.text.trim()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text("Search", style: TextStyle(fontSize: 16)),
          )
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // Weather Card
  // ----------------------------------------------------------
  Widget _buildWeatherCard(WeatherProvider provider) {
    final weather = provider.current!;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 700),
      opacity: 1,
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
          gradient: LinearGradient(
            colors: [
              Colors.blueAccent.withOpacity(0.4),
              Colors.indigo.withOpacity(0.25),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 16,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Column(
          children: [
            Text(
              weather.city,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              "${weather.temp.toStringAsFixed(1)}°C",
              style: const TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              weather.description,
              style: const TextStyle(
                fontSize: 22,
                fontStyle: FontStyle.italic,
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton.icon(
              onPressed: () {
                final city = weather.city;

                provider.favorites.contains(city)
                    ? provider.removeFavorite(city)
                    : provider.addFavorite(city);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.85),
                foregroundColor: Colors.black87,
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: Icon(
                provider.favorites.contains(weather.city)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.redAccent,
              ),
              label: Text(
                provider.favorites.contains(weather.city)
                    ? "Remove Favorite"
                    : "Add to Favorites",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // Empty state when user has not searched
  // ----------------------------------------------------------
  Widget _buildEmptyState() {
    return Column(
      children: [
        Icon(Icons.cloud_queue,
            size: 100, color: Colors.grey.withOpacity(0.7)),
        const SizedBox(height: 20),
        Text(
          "Search for a city to view weather.",
          style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
