// File: lib/ui/onboarding/view_model/onboarding_view_model.dart

import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'onboarding_view_model.g.dart';


/// A [StateNotifier] that holds and manages onboarding state.
///
/// It tracks the current onboarding page index, provides methods to
/// navigate forward or skip, and exposes whether the user is on the last page.
@riverpod
class OnboardingViewModel extends _$OnboardingViewModel {
  /// Initializes the onboarding state with the first page index (0).
  @override
  int build() => 0;

  void navigateToNext(context) {
    GoRouter.of(context).go('/home');
  }

  /// Advances to the next page if not already on the last one.
  void nextPage(context) {
    if (state < 2) {
      state++;
    } else {
      navigateToNext(context);
    }
  }

  /// Skips directly to the last page.
  void skip() {
    state = 2;
  }

  /// Returns true if the current page is the last slide.
  bool get isLastPage => state == 2;
}
