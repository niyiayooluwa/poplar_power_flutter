import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavShell extends StatelessWidget {
  final Widget child;

  const BottomNavShell({
    super.key,
    required this.child
  });

  static const tabs = ['/home', '/pay', '/more'];

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    int currentIndex = tabs.indexWhere((path) => location.startsWith(path));
    if (currentIndex == -1) currentIndex = 0;

    return Scaffold(
      body: child,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            context.go(tabs[index]);
          },
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.payment), label: 'Pay'),
            NavigationDestination(icon: Icon(Icons.more_horiz), label: 'More'),
          ],
        )
      )
    );
  }
}

// lib/ui/pay/pay_screen.dart
class PayScreen extends StatelessWidget {
  const PayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Pay Screen"));
  }
}

// lib/ui/pay/pay_screen.dart
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("More Screen"));
  }
}