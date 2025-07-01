//File: lib/routing/app_router.dart

import 'package:go_router/go_router.dart';
import 'package:poplar_power/ui/auth/signup/widget/sign_up_one_screen.dart';
import 'package:poplar_power/ui/auth/signup/widget/sign_up_two_screen.dart';
import 'package:poplar_power/ui/onboarding/widget/get_started.dart';
import '../ui/auth/login/widget/login_screen.dart';
import '../ui/home/widget/home_screen.dart';
import '../ui/onboarding/widget/onboarding.dart';
import '../ui/splash/widget/splash_screen.dart';

///Central router configuration for the app
///
/// Defines all routes, initial screen, and transition behaviours using go_router.
final GoRouter appRouter = GoRouter(
  initialLocation: '/get-started',

  //All routes are defined here
  routes: [
    GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen()
    ),

    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    GoRoute(
      path: '/get-started',
      builder: (context, state) => const GetStartedScreen(),
    ),

    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),

    GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupStep1Screen()
    ),

    GoRoute(
        path: '/signup-two',
        builder: (context, state) => const SignupStep2Screen()
    ),

    GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen()
    ),

  ],
);
