import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/models/billers/customer_verification/customer_verification_request_dto.dart';
import 'package:poplar_power/data/models/billers/payment_request_dto.dart';
import 'package:poplar_power/domain/models/biller.dart';
import 'package:poplar_power/domain/models/biller_product.dart';
import 'package:poplar_power/domain/models/notification_preference.dart';
import 'package:poplar_power/domain/use_cases/biller/get_billers_for_category_use_case.dart';
import 'package:poplar_power/domain/use_cases/biller/get_products_for_biller_use_case.dart';
import 'package:poplar_power/domain/use_cases/biller/verify_customer_use_case.dart';
import 'package:poplar_power/domain/use_cases/electricity/buy_electricity_token_use_case.dart';
import 'package:poplar_power/ui/core/widgets/async_selectable_field.dart';
import 'package:uuid/uuid.dart';

import 'buy_electricity_state.dart';

class BuyElectricityViewModel extends StateNotifier<BuyElectricityState> {
  final GetBillersForCategoryUseCase _getDiscosUseCase;
  final GetProductsForBillerUseCase _getProductsUseCase;
  final BuyElectricityTokenUseCase _buyTokenUseCase;
  final VerifyCustomerUseCase _verifyCustomerUseCase;

  BuyElectricityViewModel(
    this._getDiscosUseCase,
    this._getProductsUseCase,
    this._buyTokenUseCase,
    this._verifyCustomerUseCase,
  ) : super(BuyElectricityState.initial());

  //==============================================================================
  // State Methods
  //==============================================================================

  void selectDiscoByOption(SelectableOption option) {
    final selected = state.discos.valueOrNull?.where(
      (d) => d.name == option.name,
    );
    if (selected != null && selected.isNotEmpty) {
      selectDisco(selected.first);
    }
  }

  void selectProductByOption(SelectableOption option) {
    final selected = state.products.valueOrNull?.where(
      (p) => p.name == option.name,
    );
    if (selected != null && selected.isNotEmpty) {
      selectProduct(selected.first);
    }
  }

  void selectDisco(Biller disco) {
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

  void setPreference(NotificationPreference pref) =>
      state = state.copyWith(notificationPreference: pref);

  void setEmail(String email) => state = state.copyWith(email: email);

  void setPhoneNumber(String phoneNumber) =>
      state = state.copyWith(phoneNumber: phoneNumber);

  PaymentRequestDto buildPurchaseRequest() {
    return PaymentRequestDto(
      customerIdentifier: state.meterNumber,
      amount: int.tryParse(state.amount) ?? 0,
      walletPin: state.walletPin,
      notificationPreference: state.notificationPreference!,
      email: state.email,
      phoneNumber: state.phoneNumber,
      provider: state.provider,
      categoryGroup: "ELECTRICITY",
      categoryOrBiller: state.selectedDisco!.alias,
      billerOrProductId: state.selectedProduct!.name,
    );
  }

  Future<void> fetchDiscos() async {
    state = state.copyWith(discos: const AsyncLoading());
    final result = await _getDiscosUseCase.execute('ELECTRIC_DISCO');

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

  Future verifyCustomer() async {
    if (!state.canVerify) return;

    state = state.copyWith(verificationState: const AsyncLoading());

    final uuid = Uuid().v1();

    final request = CustomerVerificationRequestDto(
      biller: state.selectedDisco!.alias,
      product: state.selectedProduct!.name.toUpperCase(),
      account: state.meterNumber,
      reference: uuid
    );

    final result = await _verifyCustomerUseCase.execute(request);

    result.fold(
      ifLeft: (failure) => state = state.copyWith(
        verificationState: AsyncError(failure.message, StackTrace.current),
      ),
      ifRight: (data) =>
          state = state.copyWith(verificationState: AsyncData(data)),
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

  void reset() {
    state = BuyElectricityState.initial();
  }
}

final buyElectricityViewModelProvider =
    StateNotifierProvider.autoDispose<BuyElectricityViewModel, BuyElectricityState>((ref) {
      final getDiscos = ref.watch(getBillersForCategoryUseCaseProvider);
      final getProducts = ref.watch(getProductsForBillerUseCaseProvider);
      final verifyCustomer = ref.watch(verifyCustomerUseCaseProvider);
      final buyToken = ref.watch(buyElectricityTokenUseCaseProvider);

      return BuyElectricityViewModel(
        getDiscos,
        getProducts,
        buyToken,
        verifyCustomer,
      );
    });
