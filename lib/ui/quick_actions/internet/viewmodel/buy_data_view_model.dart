import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:poplar_power/domain/models/biller.dart';
import 'package:poplar_power/domain/models/biller_product.dart';
import 'package:poplar_power/domain/use_cases/biller/get_billers_for_category_use_case.dart';
import 'package:poplar_power/domain/use_cases/biller/get_products_for_biller_use_case.dart';
import 'package:poplar_power/ui/core/widgets/async_selectable_field.dart';
import 'package:poplar_power/domain/models/notification_preference.dart';

import 'buy_data_state.dart';

class BuyDataViewModel extends StateNotifier<BuyDataState> {
  final GetBillersForCategoryUseCase _getIsps;
  final GetProductsForBillerUseCase _getProducts;

  BuyDataViewModel(this._getIsps, this._getProducts)
      : super(BuyDataState.initial());

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

  void reset() {
    state = state.copyWith(
      selectedIsp: null,
      selectedProduct: null,
      phoneNumber: '',
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
}

final buyDataViewModelProvider =
    StateNotifierProvider<BuyDataViewModel, BuyDataState>((ref) {
      final getISPs = ref.watch(getBillersForCategoryUseCaseProvider);
      final getProducts = ref.watch(getProductsForBillerUseCaseProvider);

      return BuyDataViewModel(getISPs, getProducts);
    });
