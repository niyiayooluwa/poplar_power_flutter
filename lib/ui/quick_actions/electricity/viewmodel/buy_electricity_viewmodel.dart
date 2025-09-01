import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/models/electricity/buy_token_request_dto.dart';
import 'package:poplar_power/domain/models/biller_product.dart';
import 'package:poplar_power/domain/models/electricity_disco.dart';
import 'package:poplar_power/domain/use_cases/electricity/buy_electricity_token_use_case.dart';
import 'package:poplar_power/domain/use_cases/electricity/get_discos_for_category_use_case.dart';
import 'package:poplar_power/domain/use_cases/electricity/get_products_for_disco_use_case.dart';
import 'package:poplar_power/domain/use_cases/profile/get_profile_use_case.dart';

import 'buy_electricity_state.dart';

class BuyElectricityViewModel extends StateNotifier<BuyElectricityState> {
  final GetDiscosForCategoryUseCase _getDiscosUseCase;
  final GetProductsForDiscoUseCase _getProductsUseCase;
  final BuyElectricityTokenUseCase _buyTokenUseCase;
  final GetProfileUseCase _getProfileUseCase;

  BuyElectricityViewModel(
    this._getDiscosUseCase,
    this._getProductsUseCase,
    this._buyTokenUseCase,
    this._getProfileUseCase,
  ) : super(BuyElectricityState.initial()) {
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    final result = await _getProfileUseCase.execute();
    result.fold(
      ifLeft: (failure) {
        result;
      },
      ifRight: (user) {
        state = state.copyWith(email: user.email, phoneNumber: user.phone);
      },
    );
  }

  void selectDisco(ElectricityDisco disco) {
    state = state.copyWith(
      selectedDisco: disco,
      selectedProduct: null,
      products: const AsyncData(
        [],
      ), // Or AsyncData(null) or back to initial state
    );
  }

  void selectProduct(BillerProduct product) {
    state = state.copyWith(selectedProduct: product);
  }

  void setMeterNumber(String num) => state = state.copyWith(meterNumber: num);

  void setAmount(String amount) => state = state.copyWith(amount: amount);

  void setWalletPin(String pin) => state = state.copyWith(walletPin: pin);

  void setPreference(String pref) =>
      state = state.copyWith(notificationPreference: pref);

  void setEmail(String email) => state = state.copyWith(email: email);

  void setPhoneNumber(String phoneNumber) =>
      state = state.copyWith(phoneNumber: phoneNumber);

  BuyTokenRequestDto buildPurchaseRequest() {
    return BuyTokenRequestDto(
      meterNumber: state.meterNumber,
      amount: int.tryParse(state.amount) ?? 0,
      walletPin: state.walletPin,
      notificationPreference: state.notificationPreference,
      email: state.email,
      phoneNumber: state.phoneNumber,
      provider: state.provider,
      categoryOrBillerGroups: "ELECTRIC_DISCO",
      categoryIdOrBillers: state.selectedDisco!.alias,
      billerIdOrProductId:
          state.selectedProduct!.id, // Fixed: removed quotes around 'state'
    );
  }

  Future<void> fetchDiscos() async {
    state = state.copyWith(discos: const AsyncLoading());
    final result = await _getDiscosUseCase.execute();

    result.fold(
      ifLeft: (failure) => state = state.copyWith(
        discos: AsyncError(failure.message, StackTrace.current),
      ),
      ifRight: (discos) => state = state.copyWith(discos: AsyncData(discos)),
    );
  }

  Future<void> fetchProducts(String discoAlias) async {
    if (state.selectedDisco == null) return;
    state = state.copyWith(products: const AsyncLoading());

    final result = await _getProductsUseCase.execute(discoAlias);

    result.fold(
      ifLeft: (failure) => state = state.copyWith(
        products: AsyncError(failure.message, StackTrace.current),
      ),
      ifRight: (products) =>
          state = state.copyWith(products: AsyncData(products)),
    );
  }

  Future<void> buyToken() async {
    if (!state.isFormValid) return;

    state = state.copyWith(purchaseState: const AsyncLoading());

    final request = buildPurchaseRequest();
    final result = await _buyTokenUseCase.execute(request);

    result.fold(
      ifLeft: (failure) => state = state.copyWith(
        purchaseState: AsyncError(failure.message, StackTrace.current),
      ),
      ifRight: (_) =>
          state = state.copyWith(purchaseState: const AsyncData(null)),
    );
  }
}