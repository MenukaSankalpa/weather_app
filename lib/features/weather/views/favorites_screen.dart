import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/weather_provider.dart';

class FavoritesScreen extends StatelessWidget {
  final VoidCallback onSelectCity;

  const FavoritesScreen({super.key, required this.onSelectCity});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Cities",
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.18),
              Theme.of(context).colorScheme.secondary.withOpacity(0.10),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: provider.favorites.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.favorites.length,
          itemBuilder: (context, index) {
            final city = provider.favorites[index];
            return _buildAnimatedCard(context, provider, city, index);
          },
        ),
      ),
    );
  }

  // EMPTY STATE
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off_rounded,
              size: 100, color: Colors.grey.withOpacity(0.6)),
          const SizedBox(height: 16),
          const Text("No Favorite Cities",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("Search and add cities to your favorites",
              style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }

  // ANIMATED CARD
  Widget _buildAnimatedCard(
      BuildContext context, WeatherProvider provider, String city, int index) {
    return AnimatedPadding(
      duration: Duration(milliseconds: 350 + index * 100),
      padding: const EdgeInsets.only(bottom: 14),
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 450 + index * 120),
        opacity: 1,
        child: _favoriteCard(context, provider, city),
      ),
    );
  }

  // FAVORITE CARD
  Widget _favoriteCard(
      BuildContext context, WeatherProvider provider, String city) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            Colors.blue.withOpacity(0.20),
            Colors.blueGrey.withOpacity(0.12),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_city_rounded,
              size: 32, color: Colors.lightBlueAccent),
          const SizedBox(width: 16),
          Expanded(
            child: Text(city,
                style:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever_rounded,
                color: Colors.redAccent, size: 30),
            onPressed: () => provider.removeFavorite(city),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 22),
            onPressed: () {
              provider.fetchCity(city);
              onSelectCity(); // SWITCH TO HOME TAB
            },
          ),
        ],
      ),
    );
  }
}
