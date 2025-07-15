// File: lib/screens/about_us_screen.dart
//
// A beautifully designed “About Us” page listing the Tripstick developers.

import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  static const _team = <_Member>[
    _Member(
      name: 'Adham Nasr',
      role: 'Junior Flutter Developer',
      initials: 'A',
    ),
    _Member(
      name: 'Mohamed Mostafa Rezk',
      role: 'Junior Flutter Developer',
      initials: 'M',
    ),
    _Member(
      name: 'Shehab Emad',
      role: 'Senior Flutter Developer\n(BlackRockets)',
      initials: 'S',
    ),
    _Member(
      name: 'Ahmed Mounir',
      role: 'Robotics Programmer\n(Tokyo, Japan)',
      initials: 'A',
    ),
    _Member(
      name: 'Amr Khaled Osman',
      role: 'Senior Fullstack Developer',
      initials: 'A',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('About Us'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Meet the Team',
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: _team.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, i) {
                  final m = _team[i];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: theme.colorScheme.primary,
                            child: Text(
                              m.initials,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 28),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            m.name,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            m.role,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Member {
  final String name;
  final String role;
  final String initials;
  const _Member({
    required this.name,
    required this.role,
    required this.initials,
  });
}
