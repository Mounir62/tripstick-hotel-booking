// File: lib/screens/reservation_screen.dart

import 'package:flutter/material.dart';
import '../widgets/reservations_manager.dart';
import '../models/real_hotel.dart';
import 'hotel_description_screen.dart';
import 'real_hotels_screen.dart'; // ← import the RealHotels screen

class ReservationScreen extends StatelessWidget {
  const ReservationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reserveMgr = ReservationsManager();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservations'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ValueListenableBuilder<List<Property>>(
        valueListenable: reserveMgr.notifier,
        builder: (_, list, __) {
          if (list.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Placeholder icon when no bookings
                  Image.asset(
                    'assets/images/no_reservations.png',
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'You have no upcoming bookings',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Where are you going next?',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RealHotelsScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.explore, color: Colors.white,),
                    label: const Text('Find Hotels', style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final p = list[i];
              final thumb =
                  p.images.isNotEmpty ? p.images.first.thumbnail : null;

              return ListTile(
                tileColor: Colors.indigo.shade50,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
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
                subtitle: Text(
                  'Rate per night: ${p.ratePerNight.lowest.isNotEmpty ? p.ratePerNight.lowest : '—'}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => reserveMgr.remove(p),
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
