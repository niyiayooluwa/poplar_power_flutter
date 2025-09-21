import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/domain/models/biller.dart';
import 'package:poplar_power/domain/models/biller_product.dart';
import 'package:poplar_power/ui/core/widgets/async_selectable_field.dart';

/// Represents the state of the Buy Data screen.
class BuyDataState {
  final AsyncValue<List<Biller>> isps;
  final AsyncValue<List<BillerProduct>> products;
  final AsyncValue<List<SelectableOption>> mappedIsps;
  final AsyncValue<List<SelectableOption>> mappedProducts;
  final Biller? selectedIsp;
  final BillerProduct? selectedProduct;
  final String? phoneNumber;
  final String? price;

  const BuyDataState({
    this.isps = const AsyncData([]),
    this.products = const AsyncData([]),
    this.mappedIsps = const AsyncData([]),
    this.mappedProducts = const AsyncData([]),
    this.selectedIsp,
    this.selectedProduct,
    this.phoneNumber,
    this.price,
  });

  factory BuyDataState.initial() => const BuyDataState();

  BuyDataState copyWith({
    AsyncValue<List<Biller>>? isps,
    AsyncValue<List<BillerProduct>>? products,
    AsyncValue<List<SelectableOption>>? mappedIsps,
    AsyncValue<List<SelectableOption>>? mappedProducts,
    Biller? selectedIsp,
    BillerProduct? selectedProduct,
    String? phoneNumber,
    String? price,
  }) {
    return BuyDataState(
      isps: isps ?? this.isps,
      products: products ?? this.products,
      mappedIsps: mappedIsps ?? this.mappedIsps,
      mappedProducts: mappedProducts ?? this.mappedProducts,
      selectedIsp: selectedIsp ?? this.selectedIsp,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      price: price ?? this.price,
    );
  }

  bool get isFormValid =>
      selectedIsp != null &&
      selectedProduct != null &&
      phoneNumber != null &&
      phoneNumber!.length == 11;
}
