import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poplar_power/ui/auth/login/widget/login_screen.dart';
import 'package:poplar_power/ui/auth/signup/widget/sign_up_one_screen.dart';
import 'package:poplar_power/ui/auth/signup/widget/sign_up_two_screen.dart';
import 'package:poplar_power/ui/home/home_screen.dart';
import 'package:poplar_power/ui/onboarding/widget/get_started.dart';
import 'package:poplar_power/ui/onboarding/widget/onboarding.dart';
import 'package:poplar_power/ui/splash/widget/splash_screen.dart';
import 'package:poplar_power/ui/core/widgets/bottom_nav_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    /// Public routes - no navbar
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
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
      builder: (context, state) => const SignupStep1Screen(),
    ),
    GoRoute(
      path: '/signup-two',
      builder: (context, state) => const SignupStep2Screen(),
    ),

    /// Shell route - wraps screens with bottom nav
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => BottomNavShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
        ),
        GoRoute(
          path: '/pay',
          name: 'pay',
          pageBuilder: (context, state) => const NoTransitionPage(child: PayScreen()),
        ),
        GoRoute(
          path: '/more',
          name: 'more',
          pageBuilder: (context, state) => const NoTransitionPage(child: MoreScreen()),
        ),
      ],
    ),
  ],
);
