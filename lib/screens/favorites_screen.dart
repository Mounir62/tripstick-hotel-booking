// File: lib/screens/favorites_screen.dart

import 'package:flutter/material.dart';
import '../widgets/favorites_manager.dart';
import '../models/real_hotel.dart';
import 'hotel_description_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favMgr = FavoritesManager();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ValueListenableBuilder<List<Property>>(
        valueListenable: favMgr.notifier,
        builder: (context, favs, _) {
          if (favs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Replace with your actual asset path
                  Image.asset(
                    'assets/images/favourite.png',
                    width: 120,
                    height: 120,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet.',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: favs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final p = favs[i];
              final thumb = p.images.isNotEmpty ? p.images.first.thumbnail : null;
              final price = p.ratePerNight.lowest.isNotEmpty
                  ? p.ratePerNight.lowest
                  : '—';

              return ListTile(
                tileColor: Colors.indigo.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: thumb != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          thumb,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.photo, size: 50, color: Colors.grey),
                title: Text(
                  p.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
                subtitle: Text('From: $price'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => favMgr.toggle(p),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HotelDescriptionScreen(property: p),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
