import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../data/mock/mock_repository/mock_cable_repository.dart';
import 'buy_cable_state.dart';

/// This file defines the providers used for managing cable package purchases.
///
/// It includes providers for the cable package repository and the view model
/// responsible for handling the business logic of buying cable packages.

/// ViewModel for managing the state and logic of buying cable packages.
class BuyCableViewModel extends StateNotifier<BuyCableState> {
  final CablePackagesRepository _repository;

  /// Creates a [BuyCableViewModel] with the given [_repository].
  ///
  /// Initializes the state to [BuyCableState.initial] and loads cable providers.
  BuyCableViewModel(this._repository) : super(BuyCableState.initial()) {
    _loadCableProviders();
  }

  /// Loads cable providers from the repository and updates the state.
  ///
  /// This method is called when the ViewModel is initialized.
  void _loadCableProviders() async {
    final providers = await _repository.fetchCableProviders();
    state = state.copyWith(cableProviders: providers);
  }

  /// Sets the account number in the state.
  ///
  /// [number] is the account number to set.
  void setAccountNumber(String number) {
    state = state.copyWith(accountNumber: number);
  }

  /// Selects a cable provider by name and updates the state.
  ///
  /// [name] is the name of the cable provider to select.
  /// Resets the selected package when a new provider is selected.
  void selectCableProvider(String name) {
    final selected = state.cableProviders.firstWhere(
      (provider) => provider.name == name,
      // It's good practice to provide an orElse to handle cases where the provider is not found,
      // though in this controlled environment, it might not be strictly necessary if the UI ensures
      // only valid provider names are passed.
      // orElse: () => null, // Or throw an error, or handle as appropriate.
    );
    state = state.copyWith(selectedProvider: selected, selectedPackage: null);
  }

  /// Selects a cable package by name from the currently selected provider and updates the state.
  ///
  /// [name] is the name of the cable package to select.
  void selectCablePackage(String name) {
    // Ensures that a provider is selected before trying to select a package.
    final package = state.selectedProvider?.packages.firstWhere(
      (p) => p.name == name,
      // Similar to selectCableProvider, consider an orElse for robustness.
      // orElse: () => null, // Or throw an error, or handle as appropriate.
    );
    state = state.copyWith(selectedPackage: package);
  }

  /// Resets the selected provider, package, and account number to their initial states.
  void reset() {
    state = state.copyWith(
      selectedProvider: null,
      selectedPackage: null,
      accountNumber: '',
    );
  }

  /// Checks if the form is valid based on the current state.
  ///
  /// The form is considered valid if a provider and package are selected,
  /// and the account number is not null and has a length between 11 and 16 characters (inclusive).
  bool get isFormValid {
    return state.selectedProvider != null &&
        state.selectedPackage != null &&
        state.accountNumber != null &&
        state.accountNumber!.length >=
            10; // Account number must be greater than 10 characters.
  }
}
