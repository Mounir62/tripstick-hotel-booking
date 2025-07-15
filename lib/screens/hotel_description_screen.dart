// File: lib/screens/hotel_description_screen.dart

import 'package:flutter/material.dart';
import '../models/real_hotel.dart';
import '../widgets/reservations_manager.dart';
import 'reservation_screen.dart';

class HotelDescriptionScreen extends StatefulWidget {
  final Property property;
  const HotelDescriptionScreen({super.key, required this.property});

  @override
  State<HotelDescriptionScreen> createState() =>
      _HotelDescriptionScreenState();
}

class _HotelDescriptionScreenState extends State<HotelDescriptionScreen> {
  bool _showAllAmenities = false;
  final _reserveMgr = ReservationsManager();

  @override
  Widget build(BuildContext context) {
    final p = widget.property;
    final allA = p.amenities;
    final firstFour = allA.take(4).toList();
    final rest = allA.skip(4).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(p.name),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image
            if (p.images.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  p.images.first.originalImage,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
            ],

            _sectionTitle('Rate per Night'),
            Text(p.ratePerNight.lowest.isNotEmpty
                ? p.ratePerNight.lowest
                : 'N/A'),
            const SizedBox(height: 12),

            _sectionTitle('Total Rate'),
            Text(p.totalRate.lowest.isNotEmpty
                ? p.totalRate.lowest
                : 'N/A'),
            const SizedBox(height: 12),

            _sectionTitle('GPS Coordinates'),
            Text(
              'Lat: ${p.gpsCoordinates.latitude},  '
              'Lng: ${p.gpsCoordinates.longitude}',
            ),
            const SizedBox(height: 12),

            _sectionTitle('Nearby Places'),
            p.nearbyPlaces.isEmpty
                ? const Text('No nearby places.')
                : Column(
                    children: p.nearbyPlaces.map((np) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(np.name),
                        subtitle: np.transportations?.isNotEmpty == true
                            ? Text(
                                np.transportations!
                                    .map((t) => '${t.type} • ${t.duration}')
                                    .join('  |  '))
                            : null,
                      );
                    }).toList(),
                  ),
            const SizedBox(height: 16),

            _sectionTitle('Amenities'),
            // First four in two columns:
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 5,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: firstFour.map((a) {
                return Row(
                  children: [
                    const Icon(Icons.check, size: 16, color: Colors.green),
                    const SizedBox(width: 6),
                    Expanded(child: Text(a)),
                  ],
                );
              }).toList(),
            ),

            // If expanded, show the rest *above* the button:
            if (_showAllAmenities && rest.isNotEmpty) ...[
              const SizedBox(height: 8),
              GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 5,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: rest.map((a) {
                  return Row(
                    children: [
                      const Icon(Icons.check, size: 16, color: Colors.green),
                      const SizedBox(width: 6),
                      Expanded(child: Text(a)),
                    ],
                  );
                }).toList(),
              ),
            ],

            // Show/hide toggle button
            if (rest.isNotEmpty) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: () =>
                    setState(() => _showAllAmenities = !_showAllAmenities),
                child: Text(
                  _showAllAmenities ? 'Hide amenities' : 'Show all amenities',
                  style: const TextStyle(color: Colors.indigo),
                ),
              ),
            ],

            const SizedBox(height: 16),
            _sectionTitle('Vendor Prices'),
            p.prices.isEmpty
                ? const Text('No vendor prices.')
                : Column(
                    children: p.prices.map((price) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(price.source),
                        trailing: Text(
                          price.ratePerNight.lowest.isNotEmpty
                              ? price.ratePerNight.lowest
                              : '–',
                        ),
                        subtitle: Text('Guests: ${price.numGuests}'),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),

      // Reserve / View Reservation button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ValueListenableBuilder<List<Property>>(
            valueListenable: _reserveMgr.notifier,
            builder: (_, list, __) {
              final already = _reserveMgr.isReserved(p);
              return ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (!already) {
                    _reserveMgr.add(p);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reservation added!')),
                    );
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ReservationScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.calendar_month, color: Colors.white),
                label: Text(
                  already ? 'View Reservation' : 'Reserve Now',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.indigo,
          ),
        ),
      );
}
