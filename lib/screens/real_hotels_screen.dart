// File: lib/screens/real_hotels_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/serp_hotel_service.dart';
import '../models/real_hotel.dart';
import '../widgets/favorites_manager.dart';
import 'hotel_description_screen.dart';

class RealHotelsScreen extends StatefulWidget {
  const RealHotelsScreen({super.key});

  @override
  State<RealHotelsScreen> createState() => _RealHotelsScreenState();
}

class _RealHotelsScreenState extends State<RealHotelsScreen> {
  final _cityCtrl = TextEditingController();
  final _service  = SerpHotelService();
  final _favMgr   = FavoritesManager();

  DateTime _checkIn  = DateTime.now().add(const Duration(days: 10));
  DateTime _checkOut = DateTime.now().add(const Duration(days: 11));

  Future<List<Property>>? _future;

  String _fmtDate(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  Future<void> _pickDate({required bool isCheckIn}) async {
    final init = isCheckIn ? _checkIn : _checkOut;
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: init,
    );
    if (picked == null) return;
    setState(() {
      if (isCheckIn) {
        _checkIn = picked;
        if (!_checkOut.isAfter(_checkIn)) {
          _checkOut = _checkIn.add(const Duration(days: 1));
        }
      } else {
        _checkOut = picked;
        if (!_checkOut.isAfter(_checkIn)) {
          _checkIn = _checkOut.subtract(const Duration(days: 1));
        }
      }
    });
  }

  void _search() {
    final city = _cityCtrl.text.trim();
    if (city.isEmpty) return;
    setState(() {
      _future = _service.searchHotels(
        query: '$city Resorts',
        checkIn: _checkIn,
        checkOut: _checkOut,
        adults: 2,
        currency: 'EGP',
        geoCountry: 'eg',
        languageCode: 'en',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real Hotels'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityCtrl,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _search,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Search', style: TextStyle(color: Colors.white),),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Date pickers
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _pickDate(isCheckIn: true),
                    child: _dateBox('Check-in', _fmtDate(_checkIn)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () => _pickDate(isCheckIn: false),
                    child: _dateBox('Check-out', _fmtDate(_checkOut)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Results or placeholder
            Expanded(
              child: _future == null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Display this image when no search yet
                          Image.asset(
                            'assets/images/searchicon.png',
                            width: 100,
                            height: 50,
                          ),
                          
                          Text(
                            'Enter a city & tap Search',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  : FutureBuilder<List<Property>>(
                      future: _future,
                      builder: (_, snap) {
                        if (snap.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snap.hasError) {
                          return Center(
                              child:
                                  Text('Error: ${snap.error}'));
                        }
                        final props = snap.data!;
                        if (props.isEmpty) {
                          return const Center(
                              child: Text('No hotels found.'));
                        }
                        return ValueListenableBuilder<List<Property>>(
                          valueListenable: _favMgr.notifier,
                          builder: (_, favs, __) {
                            return ListView.separated(
                              itemCount: props.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (_, i) {
                                final p = props[i];
                                final thumb = p.images.isNotEmpty
                                    ? p.images.first.thumbnail
                                    : null;
                                final fromPrice =
                                    p.ratePerNight.lowest.isNotEmpty
                                        ? p.ratePerNight.lowest
                                        : (p.prices.isNotEmpty
                                            ? p.prices.first
                                                .ratePerNight.lowest
                                            : null);
                                final isFav =
                                    _favMgr.isFavorite(p);

                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.indigoAccent,
                                        width: 1),
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            HotelDescriptionScreen(
                                                property: p),
                                      ),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.all(12),
                                    leading: thumb != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(
                                                    8),
                                            child: Image.network(
                                              thumb,
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.photo,
                                            size: 50,
                                            color: Colors.grey),
                                    title: Text(p.name,
                                        style:
                                            const TextStyle(
                                                fontWeight:
                                                    FontWeight
                                                        .bold)),
                                    subtitle: fromPrice != null
                                        ? Text('From: $fromPrice')
                                        : const Text(
                                            'No price'),
                                    trailing: IconButton(
                                      icon: Icon(
                                        isFav
                                            ? Icons.favorite
                                            : Icons
                                                .favorite_border,
                                        color: isFav
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                      onPressed: () =>
                                          setState(() =>
                                              _favMgr.toggle(p)),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateBox(String label, String value) => Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border:
              Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
          ],
        ),
      );
}
