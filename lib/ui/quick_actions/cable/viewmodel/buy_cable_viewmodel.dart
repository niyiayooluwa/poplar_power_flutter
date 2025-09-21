import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/domain/models/biller.dart';
import 'package:poplar_power/domain/models/biller_product.dart';
import 'package:poplar_power/domain/use_cases/electricity/get_billers_for_category_use_case.dart';
import 'package:poplar_power/domain/use_cases/electricity/get_products_for_biller_use_case.dart';
import 'package:poplar_power/ui/core/widgets/async_selectable_field.dart';

import 'buy_cable_state.dart';

class BuyCableViewModel extends StateNotifier<BuyCableState> {
  final GetBillersForCategoryUseCase _getProvidersUseCase;
  final GetProductsForBillerUseCase _getProductsUseCase;

  BuyCableViewModel(this._getProvidersUseCase, this._getProductsUseCase)
      : super(BuyCableState.initial());

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
        products: const AsyncData([])
    );
  }

  void selectPackage(BillerProduct product) {
    state = state.copyWith(selectedProduct: product);
  }

  void setAccountNumber(String num) =>
      state = state.copyWith(accountNumber: num);

  void setAmount(String amount) => state = state.copyWith(amount: amount);
  
  void reset() => state = BuyCableState.initial();


  Future<void> fetchProviders() async {
    state = state.copyWith(cableProviders: const AsyncLoading());
    final result = await _getProvidersUseCase.execute('PAY_TV');

    result.fold(
      ifLeft: (failure) =>
      state = state.copyWith(
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
      ifLeft: (failure) =>
      state = state.copyWith(
        products: AsyncError(failure.message, StackTrace.current),
      ),
      ifRight: (products) =>
      state = state.copyWith(products: AsyncData(products)),
    );
  }
}

final buyCableViewModelProvider =
StateNotifierProvider<BuyCableViewModel, BuyCableState>((ref) {
  final getProviders = ref.watch(getBillersForCategoryUseCaseProvider);
  final getProducts = ref.watch(getProductsForBillerUseCaseProvider);

  return BuyCableViewModel(getProviders, getProducts);
});
