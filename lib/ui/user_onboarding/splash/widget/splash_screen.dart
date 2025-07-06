// File: lib/ui/splash/widgets/splash_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A stateless widget that displays the splash screen of the application.
///
/// This screen shows a centered logo, waits for a short
/// duration (e.g. 3 seconds), and then navigates
/// to the next screen in the app's flow.
///
/// Used to preload assets, perform auth checks, and show branding.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

/// Private state class for the SplashScreen widget.
///
/// Handles the timer logic and navigation after a delay.
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait 3 seconds, then navigate to the next screen.
    Timer(const Duration(seconds: 4), _navigateToNext);
  }

  /// Navigates to the next screen after the splash timeout(3s).
  void _navigateToNext() {
    context.go('/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Can use your theme later
      body: Center(
        child: FlutterLogo(size: 150)
        ),
    );
  }
}