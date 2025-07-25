import 'package:poplar_power/domain/models/bank.dart';

enum AccountValidationStatus { initial, loading, success, error }

class SendState {
  final List<Bank> bank;
  final Bank? selectedBank;
  final String? accountNUmber;
  final String? amount; // Changed from int? to String?
  final List<int> quickAmounts; // New: Quick amount suggestions
  final AccountValidationStatus validationStatus;
  final String? accountName;
  final String? errorMessage;

  const SendState({
    required this.bank,
    this.selectedBank,
    this.accountNUmber,
    this.amount = '0', // Default to '0' as a string
    this.quickAmounts = const [1000, 2000, 5000, 10000],
    this.validationStatus = AccountValidationStatus.initial,
    this.accountName,
    this.errorMessage,
  });

  factory SendState.initial() {
    return const SendState(
      bank: [],
      amount: '0', // Initialize as '0' string
    );
  }

  SendState copyWith({
    List<Bank>? bank,
    Bank? selectedBank,
    String? accountNUmber,
    String? amount, // Changed from int? to String?
    List<int>? quickAmounts,
    AccountValidationStatus? validationStatus,
    String? accountName,
    String? errorMessage,
  }) {
    return SendState(
      bank: bank ?? this.bank,
      selectedBank: selectedBank ?? this.selectedBank,
      accountNUmber: accountNUmber ?? this.accountNUmber,
      amount: amount ?? this.amount,
      quickAmounts: quickAmounts ?? this.quickAmounts,
      validationStatus: validationStatus ?? this.validationStatus,
      accountName: accountName ?? this.accountName,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
