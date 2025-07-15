// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tripstick/screens/main_screen.dart';


class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  // ───────────────────────── Utility helpers ──────────────────────────
  DateTime _parseDate(dynamic value) {
    try {
      if (value is DateTime)  return value;
      if (value is Timestamp) return value.toDate();
      if (value is String)    return DateTime.parse(value);
    } catch (e) {
      print("Date parse error: $e");
    }
    return DateTime.now(); // fallback
  }

  String _formatDate(dynamic value) {
    final date = _parseDate(value);
    return "${date.day}/${date.month}/${date.year}";
  }

  bool _canCancel(DateTime checkInDate) {
    final now = DateTime.now();
    return checkInDate.difference(now).inDays >= 3;
  }

  Future<void> _cancelReservation(
    BuildContext context,
    String docId,
    DateTime checkIn,
  ) async {
    if (!_canCancel(checkIn)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You cannot cancel less than 3 days before your reservation date.',
          ),
        ),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel booking?'),
        content: const Text(
          'Are you sure you want to cancel this reservation?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Yes, cancel'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await FirebaseFirestore.instance
          .collection('reservations')
          .doc(docId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reservation cancelled.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cancelling: $e')),
      );
    }
  }

  // ──────────────────────────── UI ────────────────────────────
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("You must be logged in to see bookings.")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(
        title: const Text("Your Bookings"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reservations')
            .where('userId', isEqualTo: user.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No bookings found."));
          }

          final reservations = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: reservations.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final doc = reservations[index];
              final data = doc.data() as Map<String, dynamic>;

              // Parse dates safely
              final checkIn = _parseDate(data['checkIn']);
              final checkOut = _parseDate(data['checkOut']);
              final cancellable = _canCancel(checkIn);

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: data['imageUrl'] != null
                            ? Image.network(
                                data['imageUrl'],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 200,
                              )
                            : Image.asset(
                                'assets/images/hotel1.png',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 200,
                              ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        data['hotelName'] ?? 'Unnamed Hotel',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text("Location: ${data['location'] ?? 'Unknown'}"),
                      Text("Guests: ${data['guests'] ?? 'N/A'}"),
                      Text("Rooms: ${data['rooms'] ?? 'N/A'}"),
                      Text("Check-in: ${_formatDate(checkIn)}"),
                      Text("Check-out: ${_formatDate(checkOut)}"),
                      const SizedBox(height: 8),
                      Text(
                        "Price per night: \$${data['pricePerNight'] ?? '0'}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                cancellable ? const Color.fromARGB(255, 255, 0, 0) : const Color.fromARGB(255, 255, 0, 0),
                          ),
                          onPressed: () => _cancelReservation(
                            context,
                            doc.id,
                            checkIn,
                          ),
                          icon: const Icon(Icons.cancel, color: Color.fromARGB(255, 255, 255, 255),),
                          label: const Text('Cancel Booking', style: TextStyle(color: Colors.white),),
                          
                        ),
                      ),
                    ],
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
