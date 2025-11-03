import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/domain/models/biller.dart';
import 'package:poplar_power/domain/models/biller_product.dart';
import 'package:poplar_power/domain/models/customer_verification.dart';
import 'package:poplar_power/domain/models/notification_preference.dart';
import 'package:poplar_power/domain/models/payment_provider.dart';
import 'package:poplar_power/ui/core/widgets/async_selectable_field.dart';

/// Represents the state of the Buy Data screen.
class BuyDataState {
  final AsyncValue<List<Biller>> isps;
  final AsyncValue<List<BillerProduct>> products;

  final AsyncValue<List<SelectableOption>> mappedIsps;
  final AsyncValue<List<SelectableOption>> mappedProducts;

  final Biller? selectedIsp;
  final BillerProduct? selectedProduct;

  final String phoneNumber;
  final String price;

  final String walletPin;
  final String email;

  final NotificationPreference notificationPreference;
  final PaymentProvider provider;

  final AsyncValue<void> purchaseState;
  final AsyncValue<CustomerVerification?> verificationState;

  const BuyDataState({
    this.isps = const AsyncData([]),
    this.products = const AsyncData([]),
    this.mappedIsps = const AsyncData([]),
    this.mappedProducts = const AsyncData([]),
    this.selectedIsp,
    this.selectedProduct,
    this.phoneNumber = '',
    this.price = '',
    this.walletPin = '',
    this.email = '',
    this.provider = PaymentProvider.paystack,
    this.notificationPreference = NotificationPreference.both,
    this.purchaseState = const AsyncData(null),
    this.verificationState = const AsyncData(null),
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
    String? walletPin,
    String? email,
    NotificationPreference? notificationPreference,
    PaymentProvider? provider,
    AsyncValue<void>? purchaseState,
    AsyncValue<CustomerVerification>? verificationState,
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
      walletPin: walletPin ?? this.walletPin,
      email: email ?? this.email,
      notificationPreference:
          notificationPreference ?? this.notificationPreference,
      provider: provider ?? this.provider,
      purchaseState: purchaseState ?? this.purchaseState,
      verificationState: verificationState ?? this.verificationState,
    );
  }

  bool get isFormValid =>
      selectedIsp != null &&
      selectedProduct != null &&
      phoneNumber.isNotEmpty &&
      phoneNumber.length == 11 &&
      price != '' &&
      price != '0';
}
