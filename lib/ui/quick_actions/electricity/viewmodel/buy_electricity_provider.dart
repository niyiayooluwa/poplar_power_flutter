import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/mock/mock_repository/mock_disco_repository.dart';

import 'buy_electricity_state.dart';
import 'buy_electricity_viewmodel.dart';

/// Provider for the [ElectricityDiscoRepository].
///
/// This provider creates an instance of [ElectricityDiscoRepository] which is used
/// to fetch electricity disco products. In a real application, this would likely
/// fetch data from a backend API.
final electricityProductsRepositoryProvider =
    Provider<ElectricityDiscoRepository>((ref) {
      // Returns a new instance of ElectricityDiscoRepository.
      // This is a mock repository for demonstration purposes.
      return ElectricityDiscoRepository();
    });

/// Provider for the [BuyElectricityViewModel].
///
/// This provider creates an instance of [BuyElectricityViewModel] and manages its state.
/// It uses `StateNotifierProvider.autoDispose` to automatically dispose of the
/// view model's state when it's no longer in use, preventing memory leaks.
final buyElectricityViewModelProvider =
    StateNotifierProvider.autoDispose<
      BuyElectricityViewModel,
      BuyElectricityState
    >((ref) {
      // Watches the electricityProductsRepositoryProvider to get an instance of ElectricityDiscoRepository.
      final repository = ref.watch(electricityProductsRepositoryProvider);
      // Creates and returns an instance of BuyElectricityViewModel, passing the repository to its constructor.
      return BuyElectricityViewModel(repository);
    });
