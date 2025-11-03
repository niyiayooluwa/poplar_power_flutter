import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/models/billers/customer_verification/customer_verification_request_dto.dart';
import 'package:poplar_power/data/models/billers/payment_request_dto.dart';
import 'package:poplar_power/domain/models/biller.dart';
import 'package:poplar_power/domain/models/biller_product.dart';
import 'package:poplar_power/domain/models/notification_preference.dart';
import 'package:poplar_power/domain/models/payment_provider.dart';
import 'package:poplar_power/domain/use_cases/biller/get_billers_for_category_use_case.dart';
import 'package:poplar_power/domain/use_cases/biller/get_products_for_biller_use_case.dart';
import 'package:poplar_power/domain/use_cases/biller/verify_customer_use_case.dart';
import 'package:poplar_power/domain/use_cases/cable/buy_cable_use_case.dart';
import 'package:poplar_power/ui/core/widgets/async_selectable_field.dart';
import 'package:uuid/uuid.dart';

import 'buy_cable_state.dart';

class BuyCableViewModel extends StateNotifier<BuyCableState> {
  final GetBillersForCategoryUseCase _getProvidersUseCase;
  final GetProductsForBillerUseCase _getProductsUseCase;
  final VerifyCustomerUseCase _verifyCustomerUseCase;
  final BuyCableUseCase _buyCableUseCase;

  BuyCableViewModel(
    this._getProvidersUseCase,
    this._getProductsUseCase,
    this._verifyCustomerUseCase,
    this._buyCableUseCase,
  ) : super(BuyCableState.initial());

  //==============================================================================
  // State Methods
  //==============================================================================

  void selectCableProviderByOption(SelectableOption option) {
    final selected = state.cableProviders.valueOrNull?.where(
      (p) => p.name == option.name,
    );
    if (selected != null && selected.isNotEmpty) {
      selectCableProvider(selected.first);
    }
  }

  void selectPackageByOption(SelectableOption option) {
    final selected = state.products.valueOrNull?.where(
      (p) => p.name == option.name,
    );
    if (selected != null && selected.isNotEmpty) {
      selectPackage(selected.first);
    }
  }

  void selectCableProvider(Biller provider) {
    state = state.copyWith(
      selectedProvider: provider,
      selectedProduct: null,
      products: const AsyncData([]),
    );
  }

  void selectPackage(BillerProduct product) {
    state = state.copyWith(selectedProduct: product);
  }

  void setAccountNumber(String num) =>
      state = state.copyWith(accountNumber: num);

  void setAmount(String amount) => state = state.copyWith(amount: amount);

  void reset() => state = BuyCableState.initial();

  void setWalletPin(String pin) => state = state.copyWith(walletPin: pin);

  void setEmail(String email) => state = state.copyWith(email: email);

  void setPhoneNumber(String phone) =>
      state = state.copyWith(phoneNumber: phone);

  void setPreference(NotificationPreference pref) =>
      state = state.copyWith(notificationPreference: pref);

  void setProvider(PaymentProvider provider) =>
      state = state.copyWith(provider: provider);

  PaymentRequestDto buildPurchaseRequest() {
    return PaymentRequestDto(
      customerIdentifier: state.accountNumber,
      amount: int.tryParse(state.amount) ?? 0,
      walletPin: state.walletPin,
      notificationPreference: state.notificationPreference!,
      email: state.email,
      phoneNumber: state.phoneNumber,
      provider: state.provider,
      categoryGroup: "PAY_TV",
      categoryOrBiller: state.selectedProvider!.alias,
      billerOrProductId: state.selectedProduct!.name,
    );
  }

  //==============================================================================
  // Asynchronous Methods
  //==============================================================================
  Future<void> fetchProviders() async {
    state = state.copyWith(cableProviders: const AsyncLoading());
    final result = await _getProvidersUseCase.execute('PAY_TV');

    result.fold(
      ifLeft: (failure) => state = state.copyWith(
        cableProviders: AsyncError(failure.message, StackTrace.current),
      ),
      ifRight: (providers) =>
          state = state.copyWith(cableProviders: AsyncData(providers)),
    );
  }

  Future<void> fetchProducts(String providerAlias) async {
    if (state.selectedProvider == null) return;
    state = state.copyWith(products: const AsyncLoading());
    final result = await _getProductsUseCase.execute(providerAlias);

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
      biller: state.selectedProvider!.alias,
      product: state.selectedProduct!.name.toUpperCase(),
      account: state.accountNumber,
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
    final result = await _buyCableUseCase.execute(request);

    result.fold(
      ifLeft: (failure) => state = state.copyWith(
        purchaseState: AsyncError(failure.message, StackTrace.current),
      ),
      ifRight: (_) =>
          state = state.copyWith(purchaseState: const AsyncData(null)),
    );
  }
}

final buyCableViewModelProvider =
    StateNotifierProvider.autoDispose<BuyCableViewModel, BuyCableState>((ref) {
      final getProviders = ref.watch(getBillersForCategoryUseCaseProvider);
      final getProducts = ref.watch(getProductsForBillerUseCaseProvider);
      final verifyCustomer = ref.watch(verifyCustomerUseCaseProvider);
      final buyCable = ref.watch(buyCableUseCaseProvider);

      return BuyCableViewModel(
        getProviders,
        getProducts,
        verifyCustomer,
        buyCable,
      );
    });
