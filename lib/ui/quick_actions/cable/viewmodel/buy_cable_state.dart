import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/domain/models/biller.dart';
import 'package:poplar_power/domain/models/biller_product.dart';
import 'package:poplar_power/ui/core/widgets/async_selectable_field.dart';

class BuyCableState {
  final AsyncValue<List<Biller>> cableProviders;
  final AsyncValue<List<BillerProduct>> products;
  final AsyncValue<List<SelectableOption>> mappedCableProviders;
  final AsyncValue<List<SelectableOption>> mappedProducts;
  final Biller? selectedProvider;
  final BillerProduct? selectedProduct;
  final String? accountNumber;
  final String? amount;

  const BuyCableState({
    this.cableProviders = const AsyncData([]),
    this.products = const AsyncData([]),
    this.mappedCableProviders = const AsyncData([]),
    this.mappedProducts = const AsyncData([]),
    this.selectedProvider,
    this.selectedProduct,
    this.accountNumber = '',
    this.amount = '',
  });

  factory BuyCableState.initial() => const BuyCableState();

  BuyCableState copyWith({
    AsyncValue<List<Biller>>? cableProviders,
    AsyncValue<List<BillerProduct>>? products,
    AsyncValue<List<SelectableOption>>? mappedCableProviders,
    AsyncValue<List<SelectableOption>>? mappedProducts,
    Biller? selectedProvider,
    BillerProduct? selectedProduct,
    String? accountNumber,
    String? amount,
  }) {
    return BuyCableState(
      cableProviders: cableProviders ?? this.cableProviders,
      products: products ?? this.products,
      mappedCableProviders: mappedCableProviders ?? this.mappedCableProviders,
      mappedProducts: mappedProducts ?? this.mappedProducts,
      selectedProvider: selectedProvider ?? this.selectedProvider,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      accountNumber: accountNumber ?? this.accountNumber,
      amount: amount ?? this.amount,
    );
  }

  bool get isFormValid =>
      selectedProvider != null &&
      selectedProduct != null &&
      accountNumber != null &&
      accountNumber!.length <= 15;
}
