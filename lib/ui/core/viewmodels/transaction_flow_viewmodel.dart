import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/domain/models/payment_config.dart';
import 'package:poplar_power/domain/models/transaction_field.dart';

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
    );
  }
}

/// Manages the transaction flow state and logic.
class TransactionFlowViewModel extends StateNotifier<TransactionFlowState> {
  /// Creates a [TransactionFlowViewModel] with the initial state.
  TransactionFlowViewModel() : super(TransactionFlowState.initial());

  /// Starts a new transaction flow.
  ///
  /// [title] is the transaction title.
  /// [amount] is the transaction amount.
  /// [fields] are the transaction fields.
  void startTransaction({
    required String title,
    required String? amount,
    required List<TransactionField> fields,
    // TODO(): Fetch payment methods from repository in future implementation.
  }) {
    final walletConfig = PaymentMethodConfig(
      name: 'Main Wallet',
      balance:
          'Fetching balance...', // TODO(): Replace with actual balance from userProvider.
      icon: Icons.account_balance_wallet,
      color: Colors.blue,
    );
    final cardConfig = const PaymentMethodConfig(
      name: 'Card',
      balance: '**** **** **** 1234',
      icon: Icons.credit_card,
      color: Colors.red,
    );
    final webPayConfig = const PaymentMethodConfig(
      name: 'Web Pay',
      balance: 'Pay with a web browser',
      icon: Icons.language,
      color: Colors.green,
    );
    final paymentMethods = [walletConfig, cardConfig, webPayConfig];

    state = state.copyWith(
      title: title,
      amount: amount,
      fields: fields,
      availablePaymentMethods: paymentMethods,
      selectedPaymentMethod: paymentMethods.first,
      step: TransactionFlowStep.showingConfirmation,
    );
  }

  /// Selects a payment method for the transaction.
  void selectPaymentMethod(PaymentMethodConfig paymentMethod) {
    state = state.copyWith(selectedPaymentMethod: paymentMethod);
  }

  /// Confirms the transaction and advances the flow.
  void confirmTransaction() {
    if (state.selectedPaymentMethod?.name == 'Main Wallet') {
      state = state.copyWith(step: TransactionFlowStep.awaitingPin);
    } else if (state.selectedPaymentMethod?.name == 'Web Pay') {
      // TODO(): Replace with API call to get actual payment URL.
      final fakeUrl = 'https://flutter.dev';
      state = state.copyWith(
        step: TransactionFlowStep.processingWebPayment,
        webPaymentUrl: fakeUrl,
      );
    }
  }

  /// Submits the PIN for wallet transactions.
  ///
  /// [pin] is the entered PIN.
  void submitPin(String pin) {
    // TODO(): Validate the PIN with backend.
    state = state.copyWith(step: TransactionFlowStep.processing);

    Future.delayed(const Duration(seconds: 2), () {
      state = state.copyWith(step: TransactionFlowStep.success);
    });
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
      (ref) => TransactionFlowViewModel(),
    );
