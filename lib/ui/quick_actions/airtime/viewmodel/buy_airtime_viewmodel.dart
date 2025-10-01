/*
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/domain/models/network_provider.dart';
import 'package:poplar_power/ui/quick_actions/airtime/viewmodel/buy_airtime_state.dart';

class AirtimePurchaseViewModel extends StateNotifier<BuyAirtimeState> {
  AirtimePurchaseViewModel() : super(const BuyAirtimeState());

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
    state = const BuyAirtimeState();
  }
}

final airtimePurchaseProvider =
    StateNotifierProvider.autoDispose<
      AirtimePurchaseViewModel,
      BuyAirtimeState
    >((ref) => AirtimePurchaseViewModel());
*/