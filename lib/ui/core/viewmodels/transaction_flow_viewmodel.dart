import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/core/application/user_provider.dart';
import 'package:poplar_power/data/models/billers/payment_request_dto.dart';
import 'package:poplar_power/domain/models/payment_config.dart';
import 'package:poplar_power/domain/models/payment_provider.dart';
import 'package:poplar_power/domain/models/transaction_field.dart';
import 'package:poplar_power/domain/models/transaction_status.dart';
import 'package:poplar_power/domain/use_cases/biller/purchase_product_use_case.dart';
import 'package:poplar_power/domain/use_cases/transaction/get_transaction_status_use_case.dart';
import 'package:poplar_power/domain/use_cases/transaction/verify_transaction_use_case.dart';
import 'package:poplar_power/ui/core/models/transaction_payload.dart';

/// Represents the steps in the transaction flow.
enum TransactionFlowStep {
  none,
  showingConfirmation,
  awaitingPin,
  processing,
  processingWebPayment,
  verifying,
  verificationSuccess,
  success,
  error,
}

/// Holds all data for an active transaction.
class TransactionFlowState {
  final String title;
  final String? amount;
  final List<TransactionField> fields;
  final TransactionFlowStep step;
  final List<PaymentMethodConfig> availablePaymentMethods;
  final PaymentMethodConfig? selectedPaymentMethod;
  final String? errorMessage;
  final String? webPaymentUrl;
  final TransactionPayload? payload;
  final String? transactionRef;
  final TransactionStatus? verifiedTransaction;

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
    this.transactionRef,
    this.verifiedTransaction,
  });

  factory TransactionFlowState.initial() => const TransactionFlowState();

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
    String? transactionRef,
    TransactionStatus? verifiedTransaction,
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
      transactionRef: transactionRef ?? this.transactionRef,
      verifiedTransaction: verifiedTransaction ?? this.verifiedTransaction,
    );
  }
}

class TransactionFlowViewModel extends StateNotifier<TransactionFlowState> {
  final Ref _ref;

  TransactionFlowViewModel(this._ref) : super(TransactionFlowState.initial());

  void startTransaction({
    required String title,
    required String? amount,
    required List<TransactionField> fields,
    required TransactionPayload payload,
  }) {
    final userBalance = _ref.read(userProvider).balance;

    final walletConfig = PaymentMethodConfig(
      name: 'Nettpay',
      balance: userBalance.when(
        data: (balance) => balance.toString(),
        loading: () => 'Loading...',
        error: (error, stackTrace) => 'Error',
      ),
      icon: Icons.account_balance_wallet,
      color: Colors.blue,
      provider: PaymentProvider.nettpay,
    );

    final paystackConfig = const PaymentMethodConfig(
      name: 'Paystack',
      desc: 'Pay with Paystack',
      icon: Icons.language,
      color: Colors.green,
      provider: PaymentProvider.paystack,
    );

    /*final stripeConfig = const PaymentMethodConfig(
      name: 'Stripe',
      desc: 'Pay with Stripe',
      icon: Icons.credit_card,
      color: Colors.purple,
      provider: PaymentProvider.stripe,
    );

    final flutterwaveConfig = const PaymentMethodConfig(
      name: 'Flutterwave',
      desc: 'Pay with Flutterwave',
      icon: Icons.waves,
      color: Colors.orange,
      provider: PaymentProvider.flutterwave,
    );*/

    final paymentMethods = [
      walletConfig,
      paystackConfig,
      //stripeConfig,
      //flutterwaveConfig
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

  void selectPaymentMethod(PaymentMethodConfig paymentMethod) {
    state = state.copyWith(selectedPaymentMethod: paymentMethod);
  }

  void confirmTransaction() {
    if (state.selectedPaymentMethod?.provider == PaymentProvider.nettpay) {
      state = state.copyWith(step: TransactionFlowStep.awaitingPin);
    } else {
      _executePurchase();
    }
  }

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

    final userState = _ref.read(userProvider);
    final user = userState.user.value;
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
      walletPin: pin,
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
      ifRight: (response) async {
        if (response.paymentLink != null) {
          state = state.copyWith(
            step: TransactionFlowStep.processingWebPayment,
            webPaymentUrl: response.paymentLink,
            transactionRef: response.transactionRef,
          );
        } else {
          final ref = response.transactionRef;

          final getStatusUseCase = _ref.read(getTransactionStatusUseCaseProvider);
          final statusResult = await getStatusUseCase.execute(ref);

          statusResult.fold(
            ifLeft: (failure) {
              state = state.copyWith(
                step: TransactionFlowStep.error,
                errorMessage: failure.message,
              );
            },
            ifRight: (transactionStatus) {
              state = state.copyWith(
                step: TransactionFlowStep.verificationSuccess,
                verifiedTransaction: transactionStatus,
              );
            },
          );
        }
      },
    );
  }

  Future<void> completeWebPayment() async {
    final ref = state.transactionRef;
    if (ref == null) {
      state = state.copyWith(
          step: TransactionFlowStep.error,
          errorMessage: 'Transaction reference not found.');
      return;
    }

    state = state.copyWith(step: TransactionFlowStep.verifying);

    final verifyUseCase = _ref.read(verifyTransactionUseCaseProvider);
    final verifyResult = await verifyUseCase.execute(ref);

    await verifyResult.fold(
      ifLeft: (failure) async {
        state = state.copyWith(
          step: TransactionFlowStep.error,
          errorMessage: failure.message,
        );
      },
      ifRight: (verificationResponse) async {
        if (verificationResponse.success) {
          final getStatusUseCase = _ref.read(getTransactionStatusUseCaseProvider);
          final statusResult = await getStatusUseCase.execute(ref);

          statusResult.fold(
            ifLeft: (failure) {
              state = state.copyWith(
                step: TransactionFlowStep.error,
                errorMessage: failure.message,
              );
            },
            ifRight: (transactionStatus) {
              state = state.copyWith(
                step: TransactionFlowStep.verificationSuccess,
                verifiedTransaction: transactionStatus,
              );
            },
          );
        } else {
          state = state.copyWith(
            step: TransactionFlowStep.error,
            errorMessage: verificationResponse.message,
          );
        }
      },
    );
  }

  void cancelTransaction() {
    state = TransactionFlowState.initial();
  }

  void reset() {
    state = TransactionFlowState.initial();
  }

  void setError(String message) {
    state = state.copyWith(
      step: TransactionFlowStep.error,
      errorMessage: message,
    );
  }
}

final transactionFlowProvider =
    StateNotifierProvider<TransactionFlowViewModel, TransactionFlowState>(
  (ref) => TransactionFlowViewModel(ref),
);
