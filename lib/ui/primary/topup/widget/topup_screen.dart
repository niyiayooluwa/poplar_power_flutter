import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TopUpScreen extends HookWidget {
  const TopUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Top up Wallet'), leading: const BackButton()),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [Center(child: Text("Top up screen"))],
          ),
        ),
      ),
    );
  }
}
