// File: lib/screens/home_screen.dart
//


import 'package:flutter/material.dart';
import 'package:tripstick/screens/real_hotels_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /* ───────── static perks ───────── */
  static final _perks = <_Perk>[
    _Perk(
      icon: Icons.local_offer,
      title: 'Exclusive Discounts',
      description: 'Save up to 30% when you book through Tripstick.',
    ),
    _Perk(
      icon: Icons.card_giftcard,
      title: 'Reward Nights',
      description: 'Collect 10 nights and get 1 night free.',
    ),
    _Perk(
      icon: Icons.directions_car_filled,
      title: 'Free Airport Pickup',
      description: 'Complimentary pickup in 50+ cities.',
    ),
    _Perk(
      icon: Icons.wifi,
      title: 'Fast Wi-Fi Guaranteed',
      description: 'All partner hotels feature ≥100 Mbps.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(
        title: const Text('Tripstick'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* ───────── hero banner ───────── */
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F5BD5), Color(0xFF962FBF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to Tripstick 🎉',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Book smarter. Travel better.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            /* ───────── perks list ───────── */
            const Text(
              'Why book with us?',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo),
            ),
            const SizedBox(height: 12),
            ..._perks.map((p) => _PerkCard(perk: p)),

            const SizedBox(height: 24),
            /* ───────── discover button ───────── */
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RealHotelsScreen(),
                    ),
                  );
                },
                icon:
                    const Icon(Icons.apartment_rounded, color: Colors.white),
                label: const Text(
                  'Discover Real Hotels',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ══════════════ helper classes ══════════════ */

class _Perk {
  final IconData icon;
  final String title;
  final String description;
  const _Perk({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _PerkCard extends StatelessWidget {
  final _Perk perk;
  const _PerkCard({required this.perk});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.indigo.shade100,
          child: Icon(perk.icon, color: Colors.indigo),
        ),
        title: Text(perk.title,
            style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(perk.description),
      ),
    );
  }
}
