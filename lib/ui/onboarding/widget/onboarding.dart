import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../viewmodel/onboarding_view_model.dart';

/// List of content for each onboarding step.
///
/// Each map contains the title, subtitle, and background image path.
/// These values are used dynamically based on the current onboarding page index.
final List<Map<String, String>> onboardingContent = [
  {
    'title': 'Pay Bills with a Tap',
    'subtitle': 'Fast, Easy and Secure Payments',
    'bg': 'assets/images/onboarding_1.jpg',
    'color': '2563EB',
    //'attribution': '"https://storyset.com/data"> Data illustrations by Storyset</a>'
  },
  {
    'title': 'Simplify Payments',
    'subtitle': 'Simplify your payments with the tool built for you',
    'bg': 'assets/images/onboarding_2.jpg',
    'color': '059669',
  },
  {
    'title': 'Track Spending with Ease',
    'subtitle': 'Track your financial transactions and manage your budget effortlessly',
    'bg': 'assets/images/onboarding_3.jpg',
    'color': '8B5CF6',
  },
];

/// Main onboarding screen that displays a dynamic background, slide content,
/// a custom progress indicator, and navigation controls.
class OnboardingScreen extends HookConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current page index from the Riverpod view model
    final currentPage = ref.watch(onboardingViewModelProvider);
    final controller = ref.read(onboardingViewModelProvider.notifier);

    // Pull current content from onboardingContent using the page index
    final slide = onboardingContent[currentPage];

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image that changes with each slide
        Image.asset(
          slide['bg']!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Color(int.parse("0xFF${slide['color']}")), // Fallback color
              child: Center(
                child: Icon(Icons.broken_image_rounded, color: Colors.white, size: 48),
              ),
            );
          },
        ),

        // Semi-transparent overlay to improve contrast for text
        /**Container(
          color: Colors.black.withOpacity(0.45),
        ),*/

        // Foreground content
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),

                // Big header text (title)
                Text(
                  slide['title']!,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),

                const SizedBox(height: 12),

                // Smaller subheader text (subtitle)
                Text(
                  slide['subtitle']!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.left,
                ),

                const Spacer(),

                // Bottom section with indicator and navigation buttons
                _OnboardingControls(
                  currentPage: currentPage,
                  onNext: () {
                    controller.nextPage(context);
                  },
                  onSkip: () {
                    controller.skip();
                  },
                  isLastPage: controller.isLastPage,
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Bottom controls widget that contains:
/// - A custom progress indicator
/// - A row with "Skip" and "Next"/"Get Started" buttons
class _OnboardingControls extends StatelessWidget {
  final int currentPage;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final bool isLastPage;

  const _OnboardingControls({
    required this.currentPage,
    required this.onNext,
    required this.onSkip,
    required this.isLastPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Custom WhatsApp-style indicator (bars with animation)
        Expanded(
         flex: 3,
         child:  Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: List.generate(3, (index) {
             final isActive = index == currentPage;
             return AnimatedContainer(
               duration: const Duration(milliseconds: 300),
               margin: const EdgeInsets.symmetric(horizontal: 4),
               height: 8,
               width: isActive ? 28 : 12,
               decoration: BoxDecoration(
                 color: isActive ? Colors.black : Colors.white,
                 borderRadius: BorderRadius.circular(12),
               ),
             );
           }),
         ),
       ),

        SizedBox(width: 32),

        // Navigation buttons row
        Expanded(
          flex: 7,
          child: Row(
            children: [
              // "Skip" button (black text)
              if (!isLastPage)
                Expanded(
                  flex: 3,
                  child: TextButton(
                    onPressed: onSkip,
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

              // "Next" or "Get Started" button
              Expanded(
                flex: 7,
                child: FilledButton(
                  onPressed: onNext,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)
                    ),
                  ),
                  child: Text(
                      isLastPage ? 'Get Started' : 'Next',
                      style: const TextStyle(
                        color: Color(0xff2563EB),
                        fontSize: 16
                      )
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}