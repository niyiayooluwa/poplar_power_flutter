// File: lib/ui/splash/widgets/splash_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_auth/local_auth.dart'; // Import local_auth
import 'package:poplar_power/core/application/user_provider.dart';
import 'package:poplar_power/data/repositories/auth_repository_impl.dart';
import 'package:poplar_power/data/services/settings_service.dart';
import 'package:poplar_power/data/storage/credentials_storage.dart';

/// A stateless widget that displays the splash screen of the application.
///
/// This screen shows a centered logo, waits for a short
/// duration (e.g. 3 seconds), and then navigates
/// to the next screen in the app's flow.
///
/// Used to preload assets, perform auth checks, and show branding.
class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    final credentialsStorage = ref.watch(credentialsStorageProvider);
    final userNotifier = ref.read(userProvider.notifier);
    final settingsService = SettingsService();
    final localAuth = LocalAuthentication(); // Add LocalAuthentication instance

    useEffect(() {
      Future<void> _checkAuthStatus() async {
        final hasToken = await authRepository.hasToken();

        if (hasToken) {
          final biometricEnabled = await credentialsStorage.getBiometricPreference();
          final canCheckBiometrics = await localAuth.canCheckBiometrics;
          final isDeviceSupported = await localAuth.isDeviceSupported();

          if (biometricEnabled && canCheckBiometrics && isDeviceSupported) {
            // If biometrics enabled AND device supports it, go to login screen to offer biometric option
            context.go('/login');
          } else {
            // If biometrics disabled OR device doesn't support it, attempt automatic login with stored credentials
            final storedEmail = await credentialsStorage.getEmail();
            final storedPassword = await credentialsStorage.getPassword();

            if (storedEmail != null && storedPassword != null) {
              final result = await authRepository.login(storedEmail, storedPassword);
              result.fold(
                ifLeft: (failure) async {
                  // If login with stored credentials fails, clear them and go to login
                  await credentialsStorage.deleteCredentials();
                  context.go('/login');
                },
                ifRight: (user) {
                  userNotifier.onLoginSuccess(user);
                  context.go('/home');
                },
              );
            } else {
              // No stored credentials, go to login
              context.go('/login');
            }
          }
        } else {
          // No token, check onboarding status
          final hasCompletedOnboarding = await settingsService.hasCompletedOnboarding();
          if (hasCompletedOnboarding) {
            context.go('/get-started');
          } else {
            context.go('/onboarding');
          }
        }
      }

      _checkAuthStatus();
      return null;
    }, const []);

    return Scaffold(
      backgroundColor: Colors.white, // Can use your theme later
      body: Center(
        child: FlutterLogo(size: 150)
        ),
    );
  }
}