// lib/screens/welcome_screen.dart

import 'package:flutter/material.dart';
import '../utils/routes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // 🌄 Background pattern
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg_pattern.png'),
                repeat: ImageRepeat.repeat,
                fit: BoxFit.none,
              ),
            ),
          ),

          // 💎 Glass-like overlay card
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/icon.png',
                      color: Colors.indigo,
                      height: size.height * 0.22,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Welcome to',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.indigo[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Tripstick',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.indigo[900],
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ——— Get Started button with arrow on the right ———
                    ElevatedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, Routes.signup),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.indigo,
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Get Started',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
