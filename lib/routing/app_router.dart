import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poplar_power/ui/core/widgets/bottom_nav_shell.dart';
import 'package:poplar_power/ui/home/home_screen.dart';
import 'package:poplar_power/ui/notifications/notifications_screen.dart';
import '../data/model/transaction_class.dart';
import '../ui/quick_actions/internet/widget/internet_screen.dart';
import '../ui/send/widget/send_screen.dart';
import '../ui/transaction_history_detail/transaction_detail_screen.dart';
import '../ui/transaction_history_detail/transaction_history_screen.dart';
import '../ui/user_onboarding/auth/login/widget/login_screen.dart';
import '../ui/user_onboarding/auth/signup/widget/sign_up_one_screen.dart';
import '../ui/user_onboarding/auth/signup/widget/sign_up_two_screen.dart';
import '../ui/user_onboarding/onboarding/widget/get_started.dart';
import '../ui/user_onboarding/onboarding/widget/onboarding.dart';
import '../ui/user_onboarding/splash/widget/splash_screen.dart';
import '../ui/quick_actions/internet/widget/confirm_details_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    /// Public routes - no navbar
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/get-started',
      builder: (context, state) => const GetStartedScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
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
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: HomeScreen()),
        ),
        GoRoute(
          path: '/pay',
          name: 'pay',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: PayScreen()),
        ),
        GoRoute(
          path: '/more',
          name: 'more',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: MoreScreen()),
        ),
      ],
    ),

    GoRoute(path: '/send', builder: (context, state) => const SendScreen()),

    GoRoute(path: '/scan', builder: (context, state) => const SendScreen()),

    GoRoute(path: '/topup', builder: (context, state) => const SendScreen()),

    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationScreen(),
    ),

    GoRoute(
      path: '/internet',
      builder: (context, state) => const InternetScreen(),
    ),

    GoRoute(
      path: '/confirm-details',
      builder: (context, state) => const ConfirmDetailsScreen(),
    ),

    GoRoute(
      path: '/transaction-history',
      builder: (context, state) => const TransactionHistoryScreen(),
    ),

    GoRoute(
      path: '/transaction-detail',
      builder: (context, state) {
        final transaction = state.extra as Transaction;
        return TransactionDetailScreen(transaction: transaction);
      },
    ),
  ],
);
