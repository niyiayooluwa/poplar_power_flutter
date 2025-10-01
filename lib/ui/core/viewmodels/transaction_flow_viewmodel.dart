import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/core/application/user_provider.dart';
import 'package:poplar_power/data/models/billers/payment_request_dto.dart';
import 'package:poplar_power/domain/models/payment_config.dart';
import 'package:poplar_power/domain/models/payment_provider.dart';
import 'package:poplar_power/domain/models/transaction_field.dart';
import 'package:poplar_power/domain/use_cases/biller/purchase_product_use_case.dart';
import 'package:poplar_power/ui/core/models/transaction_payload.dart';

/// Represents the steps in the transaction flow.
enum TransactionFlowStep {
  none,
  showingConfirmation,
  awaitingPin,
  processing,
  processingWebPayment,
  success,
  error,
}

/// Holds all data for an active transaction.
class TransactionFlowState {
  /// Title for the transaction confirmation.
  final String title;

  /// Transaction amount.
  final String? amount;

  /// List of transaction fields.
  final List<TransactionField> fields;

  /// Current step in the transaction flow.
  final TransactionFlowStep step;

  /// Available payment methods for the transaction.
  final List<PaymentMethodConfig> availablePaymentMethods;

  /// Selected payment method.
  final PaymentMethodConfig? selectedPaymentMethod;

  /// Error message, if any.
  final String? errorMessage;

  /// Web payment URL, if applicable.
  final String? webPaymentUrl;

  /// The core data required for the API transaction.
  final TransactionPayload? payload;

  /// Creates a [TransactionFlowState] instance.
  const TransactionFlowState({
    this.title = '',
    this.amount,
    this.fields = const [],
    this.step = TransactionFlowStep.none,
    this.availablePaymentMethods = const [],
    this.selectedPaymentMethod,
    this.errorMessage,
    this.webPaymentUrl,
    this.payload,
  });

  /// Returns the initial state for the transaction flow.
  factory TransactionFlowState.initial() => const TransactionFlowState();

  /// Returns a copy of the current state with updated fields.
  TransactionFlowState copyWith({
    String? title,
    String? amount,
    List<TransactionField>? fields,
    TransactionFlowStep? step,
    List<PaymentMethodConfig>? availablePaymentMethods,
    PaymentMethodConfig? selectedPaymentMethod,
    String? errorMessage,
    String? webPaymentUrl,
    TransactionPayload? payload,
  }) {
    return TransactionFlowState(
      title: title ?? this.title,
      amount: amount ?? this.amount,
      fields: fields ?? this.fields,
      step: step ?? this.step,
      availablePaymentMethods:
          availablePaymentMethods ?? this.availablePaymentMethods,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      errorMessage: errorMessage ?? this.errorMessage,
      webPaymentUrl: webPaymentUrl ?? this.webPaymentUrl,
      payload: payload ?? this.payload,
    );
  }
}

/// Manages the transaction flow state and logic.
class TransactionFlowViewModel extends StateNotifier<TransactionFlowState> {
  final Ref _ref;

  /// Creates a [TransactionFlowViewModel] with the initial state.
  TransactionFlowViewModel(this._ref) : super(TransactionFlowState.initial());

  /// Starts a new transaction flow.
  void startTransaction({
    required String title,
    required String? amount,
    required List<TransactionField> fields,
    required TransactionPayload payload,
  }) {
    final walletConfig = PaymentMethodConfig(
      name: 'Nettpay',
      balance: '4,000.00', // TODO(): Replace with actual balance from userProvider.
      icon: Icons.account_balance_wallet,
      color: Colors.blue,
      provider: PaymentProvider.nettpay,
    );

    final paystackConfig = const PaymentMethodConfig(
      name: 'Paystack',
      balance: 'Pay with Paystack',
      icon: Icons.language,
      color: Colors.green,
      provider: PaymentProvider.paystack,
    );

    final stripeConfig = const PaymentMethodConfig(
      name: 'Stripe',
      balance: 'Pay with Stripe',
      icon: Icons.credit_card,
      color: Colors.purple,
      provider: PaymentProvider.stripe,
    );

    final flutterwaveConfig = const PaymentMethodConfig(
      name: 'Flutterwave',
      balance: 'Pay with Flutterwave',
      icon: Icons.waves,
      color: Colors.orange,
      provider: PaymentProvider.flutterwave,
    );

    final paymentMethods = [
      walletConfig,
      paystackConfig,
      stripeConfig,
      flutterwaveConfig
    ];

    state = state.copyWith(
      title: title,
      amount: amount,
      fields: fields,
      payload: payload,
      availablePaymentMethods: paymentMethods,
      selectedPaymentMethod:
          paymentMethods.isNotEmpty ? paymentMethods.first : null,
      step: TransactionFlowStep.showingConfirmation,
    );
  }

  /// Selects a payment method for the transaction.
  void selectPaymentMethod(PaymentMethodConfig paymentMethod) {
    state = state.copyWith(selectedPaymentMethod: paymentMethod);
  }

  /// Confirms the transaction and advances the flow.
  void confirmTransaction() {
    if (state.selectedPaymentMethod?.provider == PaymentProvider.nettpay) {
      state = state.copyWith(step: TransactionFlowStep.awaitingPin);
    } else {
      // For all other providers, we can directly call the purchase logic
      // without a PIN.
      _executePurchase();
    }
  }

  /// Submits the PIN for wallet transactions.
  void submitPin(String pin) {
    _executePurchase(pin: pin);
  }

  Future<void> _executePurchase({String? pin}) async {
    if (state.payload == null || state.selectedPaymentMethod == null) {
      state = state.copyWith(
          step: TransactionFlowStep.error,
          errorMessage: 'Transaction payload is missing.');
      return;
    }
    state = state.copyWith(step: TransactionFlowStep.processing);

    final user = _ref.read(userProvider).value;
    final payload = state.payload!;
    final paymentProvider = state.selectedPaymentMethod!.provider;

    final requestDto = PaymentRequestDto(
      customerIdentifier: payload.customerIdentifier,
      amount: payload.amount,
      categoryGroup: payload.categoryGroup,
      categoryOrBiller: payload.categoryOrBiller,
      billerOrProductId: payload.billerOrProductId,
      notificationPreference: payload.notificationPreference,
      provider: paymentProvider,
      walletPin: pin, // Will be null if not a NETTPAY transaction
      email: user?.email,
      phoneNumber: user?.phone,
    );

    final purchaseUseCase = _ref.read(purchaseProductUseCaseProvider);
    final result = await purchaseUseCase.execute(requestDto);

    result.fold(
      ifLeft: (failure) => state = state.copyWith(
        step: TransactionFlowStep.error,
        errorMessage: failure.message,
      ),
      ifRight: (response) {
        if (response.clientSecret != null) {
          state = state.copyWith(
            step: TransactionFlowStep.processingWebPayment,
            webPaymentUrl:
                response.clientSecret, // Or a constructed URL from this
          );
        } else {
          state = state.copyWith(step: TransactionFlowStep.success);
        }
      },
    );
  }

  /// Completes the web payment flow.
  void completeWebPayment() {
    state = state.copyWith(step: TransactionFlowStep.success);
  }

  /// Cancels the current transaction and resets the state.
  void cancelTransaction() {
    state = TransactionFlowState.initial();
  }

  /// Resets the transaction flow to its initial state.
  void reset() {
    state = TransactionFlowState.initial();
  }
}

/// Provider for the transaction flow view model.
final transactionFlowProvider =
    StateNotifierProvider<TransactionFlowViewModel, TransactionFlowState>(
  (ref) => TransactionFlowViewModel(ref),
);
