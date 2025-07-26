import 'package:flutter/material.dart';

/// A reusable full-screen overlay widget for simulating loading or transaction processing.
/// To use, wrap your screen with a Stack and toggle [isVisible] to show or hide it.
///
/// Example:
/// ```dart
/// Stack(
///   children: [
///     YourMainContent(),
///     LoadingOverlay(isVisible: isProcessing.value, message: "Processing..."),
///   ],
/// )
/// ```
class LoadingOverlay extends StatelessWidget {
  /// Whether the overlay is visible.
  final bool isVisible;

  /// Optional message displayed below the spinner.
  final String? message;

  const LoadingOverlay({
    super.key,
    required this.isVisible,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.5),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message!,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ],
        ),
      ),
    );
  }
}