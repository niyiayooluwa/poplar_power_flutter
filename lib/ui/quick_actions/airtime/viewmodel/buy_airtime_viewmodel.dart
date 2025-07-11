import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poplar_power/domain/models/network_provider.dart';

class AirtimePurchaseState {
  final String phoneNumber;
  final int? selectedAmount;
  final int? customAmount;
  final NetworkProvider? selectedNetwork;

  const AirtimePurchaseState({
    this.phoneNumber = '',
    this.selectedAmount,
    this.customAmount,
    this.selectedNetwork,
  });

  int get effectiveAmount => selectedAmount ?? customAmount ?? 0;

  bool get isFormValid =>
      phoneNumber.length == 11 &&
      effectiveAmount >= 50 &&
      effectiveAmount <= 150000 &&
      selectedNetwork != null;

  AirtimePurchaseState copyWith({
    String? phoneNumber,
    int? selectedAmount,
    int? customAmount,
    NetworkProvider? selectedNetwork,
    bool clearSelectedAmount = false,
    bool clearCustomAmount = false,
  }) {
    return AirtimePurchaseState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      selectedAmount: clearSelectedAmount ? null : (selectedAmount ?? this.selectedAmount),
      customAmount: clearCustomAmount ? null : (customAmount ?? this.customAmount),
      selectedNetwork: selectedNetwork ?? this.selectedNetwork,
    );
  }
}

class AirtimePurchaseViewModel extends StateNotifier<AirtimePurchaseState> {
  AirtimePurchaseViewModel() : super(const AirtimePurchaseState());

  void setPhoneNumber(String number) {
    state = state.copyWith(phoneNumber: number);
  }

  void selectNetwork(NetworkProvider network) {
    state = state.copyWith(selectedNetwork: network);
  }

  void selectPresetAmount(int amount) {
    state = state.copyWith(
      selectedAmount: amount,
      clearCustomAmount: true,
    );
  }

  void setCustomAmount(int amount) {
    state = state.copyWith(
      customAmount: amount,
      clearSelectedAmount: true,
    );
  }

  void clearAmounts() {
    state = state.copyWith(
      clearCustomAmount: true,
      clearSelectedAmount: true,
    );
  }

  void reset() {
    state = const AirtimePurchaseState();
  }
}

final airtimePurchaseProvider =
    StateNotifierProvider.autoDispose<
      AirtimePurchaseViewModel,
      AirtimePurchaseState
    >((ref) => AirtimePurchaseViewModel());