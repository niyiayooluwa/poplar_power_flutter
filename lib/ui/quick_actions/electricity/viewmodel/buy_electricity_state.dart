import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/domain/models/biller.dart';
import 'package:poplar_power/domain/models/biller_product.dart';
import 'package:poplar_power/ui/core/widgets/async_selectable_field.dart';
import 'package:poplar_power/domain/models/notification_preference.dart';
import 'package:poplar_power/domain/models/payment_provider.dart';

class BuyElectricityState {
  final AsyncValue<List<Biller>> discos;
  final AsyncValue<List<BillerProduct>> products;

  final AsyncValue<List<SelectableOption>> mappedDiscos;
  final AsyncValue<List<SelectableOption>> mappedProducts;

  final Biller? selectedDisco;
  final BillerProduct? selectedProduct;

  final String meterNumber;
  final String amount;

  final String walletPin;
  final NotificationPreference notificationPreference;

  final String email;
  final String phoneNumber;

  final PaymentProvider provider;
  final AsyncValue<void> purchaseState;

  const BuyElectricityState({
    this.discos = const AsyncData([]),
    this.products = const AsyncData([]),
    this.mappedDiscos = const AsyncData([]),
    this.mappedProducts = const AsyncData([]),

    this.selectedDisco,
    this.selectedProduct,
    this.meterNumber = '',
    this.amount = '',

    this.walletPin = '',
    this.notificationPreference = NotificationPreference.both,
    this.email = '',
    this.phoneNumber = '',

    this.provider = PaymentProvider.paystack,
    this.purchaseState = const AsyncData(null),
  });

  factory BuyElectricityState.initial() => const BuyElectricityState();

  BuyElectricityState copyWith({
    AsyncValue<List<Biller>>? discos,
    AsyncValue<List<BillerProduct>>? products,
    AsyncValue<List<SelectableOption>>? mappedDiscos,
    AsyncValue<List<SelectableOption>>? mappedProducts,
    Biller? selectedDisco,
    BillerProduct? selectedProduct,
    String? meterNumber,
    String? amount,
    String? walletPin,
    NotificationPreference? notificationPreference,
    String? email,
    String? phoneNumber,
    PaymentProvider? provider,
    AsyncValue<void>? purchaseState,
  }) {
    return BuyElectricityState(
      discos: discos ?? this.discos,
      products: products ?? this.products,
      mappedDiscos: mappedDiscos ?? this.mappedDiscos,
      mappedProducts: mappedProducts ?? this.mappedProducts,
      selectedDisco: selectedDisco ?? this.selectedDisco,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      meterNumber: meterNumber ?? this.meterNumber,
      amount: amount ?? this.amount,
      walletPin: walletPin ?? this.walletPin,
      notificationPreference:
          notificationPreference ?? this.notificationPreference,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      provider: provider ?? this.provider,
      purchaseState: purchaseState ?? this.purchaseState,
    );
  }

  bool get isFormValid =>
      selectedDisco != null &&
      selectedProduct != null &&
      meterNumber.length >= 6 &&
      meterNumber.length <= 15 &&
      amount.length >= 3 &&
      amount.length <= 6;
}
