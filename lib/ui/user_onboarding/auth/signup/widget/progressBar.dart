import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double progress; // Value between 0.0 and 1.0
  final double height; // Height of the progress bar

  const ProgressBar({super.key, required this.progress, this.height = 6.0});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // This ensures it appears below the system bar
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 8, 0, 16),
        child: SizedBox(
          width: double.infinity,
          height: height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(height / 8), // Rounded caps
            child: Stack(
              children: [
                // Background
                Container(color: Colors.grey[300]),
                // Progress with gradient
                ClipRRect(
                  borderRadius: BorderRadius.circular(height / 8),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: MediaQuery.of(context).size.width * progress,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF8ec0ff),
                          Color(0xFF1309fe),
                        ], // Customize your gradient colors
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
