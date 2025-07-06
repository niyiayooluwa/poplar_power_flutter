import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: Colors.white),

        Positioned.fill(
          child: Opacity(
            opacity: 0.5, // Value between 0.0 (fully transparent) and 1.0 (fully opaque)
            child: SvgPicture.asset(
              'assets/drawables/get_started_bg.svg',
              fit: BoxFit.cover,
            ),
          ),
        ),

        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.9),
                ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )
          )
        ),

        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),

                Text(
                  'Get Started with "Poplar Power?"',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonal(
                    onPressed: () { context.go('/signup');},
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      fixedSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Create an Account',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () { context.go('/login');},
                    style: FilledButton.styleFrom(
                      fixedSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Login to your Account',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
