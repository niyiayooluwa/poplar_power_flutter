import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/services/electricity_providers.dart';
import 'package:poplar_power/ui/quick_actions/electricity/viewmodel/buy_electricity_state.dart';
import 'package:poplar_power/ui/quick_actions/electricity/viewmodel/buy_electricity_viewmodel.dart';

import 'package:poplar_power/data/services/profile_providers.dart';

final buyElectricityViewModelProvider =
    StateNotifierProvider<BuyElectricityViewModel, BuyElectricityState>((ref) {
  final getDiscos = ref.watch(getDiscosForCategoryUseCaseProvider);
  final getProducts = ref.watch(getProductsForDiscoUseCaseProvider);
  final buyToken = ref.watch(buyElectricityTokenUseCaseProvider);
  final getProfile = ref.watch(getProfileUseCaseProvider);

  return BuyElectricityViewModel(getDiscos, getProducts, buyToken, getProfile);
});