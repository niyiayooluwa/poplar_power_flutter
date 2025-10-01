/*
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/domain/models/biller.dart';
import 'package:poplar_power/domain/models/biller_product.dart';
import 'package:poplar_power/domain/models/notification_preference.dart';
import 'package:poplar_power/domain/models/payment_provider.dart';
import 'package:poplar_power/ui/core/widgets/async_selectable_field.dart';

class BuyAirtimeState {
  final AsyncValue<List<Biller>> airtimeProviders;
  final AsyncValue<List<BillerProduct>> products;

  final AsyncValue<List<SelectableOption>> mappedairtimeProviders;
  final AsyncValue<List<SelectableOption>> mappedProducts;

  final Biller? selectedProvider;
  final BillerProduct? selectedProduct;

  final String accountNumber;
  final String amount;

  final String walletPin;
  final String email;

  final String phoneNumber;
  final NotificationPreference notificationPreference;

  final PaymentProvider provider;
  final AsyncValue<void> purchaseState;

  const BuyAirtimeState({
    this.airtimeProviders = const AsyncData([]),
    this.products = const AsyncData([]),
    this.mappedairtimeProviders = const AsyncData([]),
    this.mappedProducts = const AsyncData([]),

    this.selectedProvider,
    this.selectedProduct,
    this.accountNumber = '',
    this.amount = '',

    this.phoneNumber = '',
    this.email = '',
    this.notificationPreference = NotificationPreference.both,
    this.walletPin = '',

    this.provider = PaymentProvider.paystack,
    this.purchaseState = const AsyncData(null),
  });

  factory BuyAirtimeState.initial() => const BuyAirtimeState();

  BuyAirtimeState copyWith({
    AsyncValue<List<Biller>>? airtimeProviders,
    AsyncValue<List<BillerProduct>>? products,
    AsyncValue<List<SelectableOption>>? mappedairtimeProviders,
    AsyncValue<List<SelectableOption>>? mappedProducts,
    Biller? selectedProvider,
    BillerProduct? selectedProduct,
    String? accountNumber,
    String? amount,
    String? walletPin,
    String? email,
    String? phoneNumber,
    NotificationPreference? notificationPreference,
    PaymentProvider? provider,
    AsyncValue<void>? purchaseState,
  }) {
    return BuyAirtimeState(
      airtimeProviders: airtimeProviders ?? this.airtimeProviders,
      products: products ?? this.products,
      mappedairtimeProviders: mappedairtimeProviders ?? this.mappedairtimeProviders,
      mappedProducts: mappedProducts ?? this.mappedProducts,
      selectedProvider: selectedProvider ?? this.selectedProvider,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      accountNumber: accountNumber ?? this.accountNumber,
      amount: amount ?? this.amount,
      walletPin: walletPin ?? this.walletPin,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      notificationPreference:
          notificationPreference ?? this.notificationPreference,
      provider: provider ?? this.provider,
      purchaseState: purchaseState ?? this.purchaseState,
    );
  }

  bool get isFormValid =>
      selectedProvider != null &&
      selectedProduct != null &&
      accountNumber.isNotEmpty &&
      accountNumber.length <= (selectedProvider?.accountNumberSize ?? 15);
}
*/