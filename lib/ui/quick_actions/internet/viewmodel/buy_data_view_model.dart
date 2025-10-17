import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/models/billers/payment_request_dto.dart';

import 'package:poplar_power/domain/models/biller.dart';
import 'package:poplar_power/domain/models/biller_product.dart';
import 'package:poplar_power/domain/use_cases/biller/get_billers_for_category_use_case.dart';
import 'package:poplar_power/domain/use_cases/biller/get_products_for_biller_use_case.dart';
import 'package:poplar_power/domain/use_cases/internet/buy_data_use_case.dart';
import 'package:poplar_power/ui/core/widgets/async_selectable_field.dart';
import 'package:poplar_power/domain/models/notification_preference.dart';

import 'buy_data_state.dart';

class BuyDataViewModel extends StateNotifier<BuyDataState> {
  final GetBillersForCategoryUseCase _getIsps;
  final GetProductsForBillerUseCase _getProducts;
  final BuyDataUseCase _buyData;


  BuyDataViewModel(this._getIsps, this._getProducts, this._buyData)
      : super(BuyDataState.initial());

  //==============================================================================
  // State Methods
  //==============================================================================

  void selectISPByOption(SelectableOption option) {
    final selected = state.isps.valueOrNull?.where(
      (p) => p.name == option.name,
    );
    if (selected != null && selected.isNotEmpty) {
      selectISP(selected.first);
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

  void reset() => BuyDataState.initial();

  void selectISP(Biller isp) {
    state = state.copyWith(
      selectedIsp: isp,
      selectedProduct: null,
      products: const AsyncData([]),
    );
  }

  void selectProduct(BillerProduct product) {
    if (state.selectedIsp != null) {
      state = state.copyWith(selectedProduct: product);
    }
  }

  void setPhoneNumber(String phoneNumber) =>
      state = state.copyWith(phoneNumber: phoneNumber);

  void setPrice(String price) => state = state.copyWith(price: price);

  void setWalletPin(String pin) => state = state.copyWith(walletPin: pin);

  void setPreference(NotificationPreference pref) =>
      state = state.copyWith(notificationPreference: pref);

  void setEmail(String email) => state = state.copyWith(email: email);

  PaymentRequestDto buildPurchaseRequest() {
    return PaymentRequestDto(
      customerIdentifier: state.phoneNumber,
      amount: int.tryParse(state.price) ?? 0,
      walletPin: state.walletPin,
      notificationPreference: state.notificationPreference,
      email: state.email,
      phoneNumber: state.phoneNumber,
      provider: state.provider,
      categoryGroup: "AIRTIME_AND_DATA",
      categoryOrBiller: state.selectedIsp!.alias,
      billerOrProductId: state.selectedProduct!.name,
    );
  }

  Future<void> fetchISPs() async {
    state = state.copyWith(isps: const AsyncLoading());
    final result = await _getIsps.execute('AIRTIME_AND_DATA');

    result.fold(
      ifLeft: (failure) => state = state.copyWith(
        isps: AsyncError(failure.message, StackTrace.current),
      ),
      ifRight: (isps) => state = state.copyWith(isps: AsyncData(isps)),
    );
  }

  Future<void> fetchProducts(String ispAlias) async {
    if (state.selectedIsp == null) return;
    state = state.copyWith(products: const AsyncLoading());

    final result = await _getProducts.execute(ispAlias);

    result.fold(
      ifLeft: (failure) => state = state.copyWith(
        products: AsyncError(failure.message, StackTrace.current),
      ),
      ifRight: (products) =>
          state = state.copyWith(products: AsyncData(products)),
    );
  }

  Future<void> purchase() async {
    if (!state.isFormValid) return;

    state = state.copyWith(purchaseState: const AsyncLoading());

    final request = buildPurchaseRequest();
    final result = await _buyData.execute(request);

    result.fold(
      ifLeft: (failure) => state = state.copyWith(
        purchaseState: AsyncError(failure.message, StackTrace.current),
      ),
      ifRight: (_) =>
      state = state.copyWith(purchaseState: const AsyncData(null)),
    );
  }
}

final buyDataViewModelProvider =
    StateNotifierProvider<BuyDataViewModel, BuyDataState>((ref) {
      final getISPs = ref.watch(getBillersForCategoryUseCaseProvider);
      final getProducts = ref.watch(getProductsForBillerUseCaseProvider);
      final buyData = ref.watch(buyDataUseCaseProvider);

      return BuyDataViewModel(getISPs, getProducts, buyData);
    });
