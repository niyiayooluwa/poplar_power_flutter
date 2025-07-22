import 'package:poplar_power/domain/models/cable_provider.dart';

/// Represents the state for the Buy Cable feature.
///
/// This class holds the information related to cable providers,
/// selected provider, selected package, and account number.
class BuyCableState {
  /// A list of available cable providers.
  final List<CableProvider> cableProviders;
  /// The currently selected cable provider. Can be null if no provider is selected.
  final CableProvider? selectedProvider;
  /// The currently selected cable package. Can be null if no package is selected.
  final CablePackage? selectedPackage;
  /// The account number associated with the cable subscription. Can be null or empty.
  final String? accountNumber;

  /// Creates an instance of [BuyCableState].
  BuyCableState({
    required this.cableProviders,
    required this.selectedProvider,
    required this.selectedPackage,
    required this.accountNumber,
  });

  /// Creates an initial state for the Buy Cable feature.
  factory BuyCableState.initial() {
    return BuyCableState(
      cableProviders: [],
      selectedProvider: null,
      selectedPackage: null,
      accountNumber: '',
    );
  }

  /// Creates a new [BuyCableState] by copying the current state and updating
  /// the provided fields.
  BuyCableState copyWith({
    List<CableProvider>? cableProviders,
    CableProvider? selectedProvider,
    CablePackage? selectedPackage,
    String? accountNumber,
  }) {
    return BuyCableState(

      cableProviders: cableProviders ?? this.cableProviders,
      selectedProvider: selectedProvider ?? this.selectedProvider,
      selectedPackage: selectedPackage ?? this.selectedPackage,
      accountNumber: accountNumber ?? this.accountNumber,
    );
  }
}