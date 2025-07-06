// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$onboardingViewModelHash() =>
    r'dd13ec8b5712dd48d29392114e661483b91ae5c9';

/// A [StateNotifier] that holds and manages onboarding state.
///
/// It tracks the current onboarding page index, provides methods to
/// navigate forward or skip, and exposes whether the user is on the last page.
///
/// Copied from [OnboardingViewModel].
@ProviderFor(OnboardingViewModel)
final onboardingViewModelProvider =
    AutoDisposeNotifierProvider<OnboardingViewModel, int>.internal(
      OnboardingViewModel.new,
      name: r'onboardingViewModelProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$onboardingViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$OnboardingViewModel = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
