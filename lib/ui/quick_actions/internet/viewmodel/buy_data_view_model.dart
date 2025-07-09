import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../data/mock/mock_repository/mock_data_repository.dart';
import 'buy_data_state.dart';

/// ViewModel for the Buy Data screen.
///
/// Manages the state of the screen, including the list of ISPs,
/// the selected ISP, and the selected data bundle.
class BuyDataViewModel extends StateNotifier<BuyDataState> {
  /// The repository used to fetch data bundles.
  final DataBundleRepository _repository;

  /// Creates a new instance of [BuyDataViewModel].
  ///
  /// Takes a [DataBundleRepository] as a parameter and initializes
  /// the state with [BuyDataState.initial()].
  ///
  /// Also calls [_loadISPs] to fetch the list of ISPs on initialization.
  BuyDataViewModel(this._repository) : super(BuyDataState.initial()) {
    _loadISPs(); // fetch ISPs on initialization
  }

  void setPhoneNumber(String number) {
    state = state.copyWith(phoneNumber: number);
  }

  /// Loads the list of ISPs from the repository.
  ///
  /// Updates the state with the fetched ISPs.
  void _loadISPs() async {
    final providers = await _repository.fetchISPs();
    state = state.copyWith(isps: providers);
  }

  /// Selects an ISP.
  ///
  /// Takes the name of the ISP as a parameter and updates the state
  /// with the selected ISP.
  ///
  /// Also resets the selected bundle if the ISP changes.
  void selectISP(String name) {
    final selected = state.isps.firstWhere((isp) => isp.name == name);
    state = state.copyWith(
      selectedISP: selected,
      selectedBundle: null, // Reset bundle if ISP changes
    );
  }

  /// Selects a data bundle.
  ///
  /// Takes the name of the bundle as a parameter and updates the state
  /// with the selected bundle.
  void selectBundle(String bundleName) {
    final bundle = state.selectedISP?.bundles
        .firstWhere((b) => b.name == bundleName, /*orElse: () => null*/);

    state = state.copyWith(selectedBundle: bundle,);
  }

  void reset() {
    state = state.copyWith(
      selectedISP: null,
      selectedBundle: null,
      phoneNumber: '',
    );
  }
  /// Returns true if the form is valid, false otherwise.
  ///
  /// The form is considered valid if both an ISP and a data bundle
  /// have been selected.
  bool get isFormValid {
    return state.selectedISP != null &&
        state.selectedBundle != null &&
        state.phoneNumber != null &&
        state.phoneNumber!.length == 11;
  }
}