// File: lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../main.dart';                  
import 'about_us_screen.dart';         

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);

    return Scaffold(
      
      appBar: AppBar(
        title: const Text('My Profile'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.indigo,
        centerTitle: true,
       
      ),
      body: user == null
          ? const Center(child: Text('Not signed in.'))
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              children: [
                
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: theme.colorScheme.primary,
                    child: Text(
                      user.email![0].toUpperCase(),
                      style: const TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    user.email!,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    'User ID: ${user.uid}',
                    style: theme.textTheme.bodySmall,
                  ),
                ),

                const SizedBox(height: 24),
                const Divider(),

                // — Edit Profile —
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit Profile'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    
                  },
                ),

                // — Payment Methods —
                ListTile(
                  leading: const Icon(Icons.payment),
                  title: const Text('Payment Methods'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    
                  },
                ),

                // — Push Notifications Toggle —
                SwitchListTile(
                  secondary: const Icon(Icons.notifications),
                  title: const Text('Push Notifications'),
                  value: true, 
                  onChanged: (v) {
                    
                  },
                ),

                // — Theme Toggle —
                ValueListenableBuilder<ThemeMode>(
                  valueListenable: themeNotifier,
                  builder: (_, mode, __) {
                    return SwitchListTile(
                      secondary: const Icon(Icons.brightness_6),
                      title: const Text('Dark Mode'),
                      value: mode == ThemeMode.dark,
                      onChanged: (isDark) {
                        themeNotifier.value =
                            isDark ? ThemeMode.dark : ThemeMode.light;
                      },
                    );
                  },
                ),

                // — Help Center —
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Help Center'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    
                  },
                ),

                // — About Tripstick —
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About Us'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AboutUsScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // — Logout Button —
                ElevatedButton.icon(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text('Log Out', style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
