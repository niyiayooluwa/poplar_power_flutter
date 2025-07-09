import '../../../../domain/models/data_bundle.dart';
import '../../../../domain/models/internet_service_provider.dart';

/// Represents the state of the Buy Data screen.
class BuyDataState {
  /// A list of available Internet Service Providers (ISPs).
  final List<InternetServiceProvider> isps;

  /// The currently selected ISP.
  final InternetServiceProvider? selectedISP;

  /// The currently selected data bundle.
  final DataBundle? selectedBundle;

  /// The recepient phone number
  final String? phoneNumber;

  /// Creates an instance of [BuyDataState].
  ///
  /// [isps] is the list of available ISPs.
  /// [selectedISP] is the currently selected ISP.
  /// [selectedBundle] is the currently selected data bundle.
  const BuyDataState({
    required this.isps,
    required this.selectedISP,
    required this.selectedBundle,
    required this.phoneNumber
  });

  /// Creates an initial state for the Buy Data screen.
  ///
  /// The initial state has an empty list of ISPs, no selected ISP, and no selected data bundle.
  factory BuyDataState.initial() {
    return const BuyDataState(
      isps: [],
      selectedISP: null,
      selectedBundle: null,
      phoneNumber: null,
    );
  }

  /// Creates a copy of the current state with the given fields replaced with the new values.
  BuyDataState copyWith({
    List<InternetServiceProvider>? isps,
    InternetServiceProvider? selectedISP,
    DataBundle? selectedBundle,
    String? phoneNumber,
  }) {
    return BuyDataState(
      isps: isps ?? this.isps,
      selectedISP: selectedISP ?? this.selectedISP,
      selectedBundle: selectedBundle ?? this.selectedBundle,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
