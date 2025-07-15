import 'package:flutter/material.dart';
import 'package:tripstick/screens/favorites_screen.dart';
import 'package:tripstick/screens/bookings_screen.dart';
import 'package:tripstick/screens/profile_screen.dart';
import 'package:tripstick/screens/home_screen.dart';
import 'package:tripstick/screens/real_hotels_screen.dart';
import 'package:tripstick/screens/reservation_screen.dart';  

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
        const HomeScreen(),
        const FavoritesScreen(),
        const ReservationScreen(),
        const RealHotelsScreen(),  // ← new screen
        const ProfileScreen(),
      ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // allow more than 3 tabs
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
          
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_rounded),
            label: 'Reservations',
          ),
          
          BottomNavigationBarItem(                    // ← new tab
            icon: Icon(Icons.location_city_rounded),
            label: 'Real Hotels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
