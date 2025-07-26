import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/mock/mock_repository/mock_bank_repository.dart';
import 'package:poplar_power/ui/primary/send/viewmodel/send_state.dart';

class SendViewModel extends StateNotifier<SendState> {
  final BankRepository _repository;

  SendViewModel(this._repository) : super(SendState.initial()) {
    _loadBanks();
  }

  // Loads the list of banks from the repository and updates the state.
  void _loadBanks() async {
    final banks = await _repository.fetchBanks();
    state = state.copyWith(bank: banks);
  }

  // Sets the account number in the state.
  void setAccountNumber(String number) {
    state = state.copyWith(accountNUmber: number);
  }

  // Sets the selected bank in the state and resets the account number.
  void setSelectedBank(String name) {
    final selected = state.bank.firstWhere((bank) => bank.name == name);
    state = state.copyWith(selectedBank: selected, accountNUmber: null);
  }

  // Sets the transaction amount in the state.
  void setAmount(String amount) {
    state = state.copyWith(amount: amount);
  }

  // Handles the press of a number button on the keypad.
  // Appends the pressed number to the current amount.
  void handleNumberPress(String num) {
    final currentAmount = state.amount;
    if (currentAmount == '0') {
      setAmount(num);
    } else {
      setAmount(currentAmount + num);
    }
  }

  // Handles the press of the backspace button on the keypad.
  // Removes the last digit from the current amount.
  void handleBackspace() {
    final currentAmount = state.amount;
    if (currentAmount.length == 1) {
      setAmount('0');
    } else {
      setAmount(currentAmount.substring(0, currentAmount.length - 1));
    }
  }

  // Sets a predefined quick amount.
  void setQuickAmount(int quickAmount) {
    setAmount(quickAmount.toString());
  }

  // Verifies the account number. This is a mock implementation.
  Future<void> verifyAccountNumber(String accountNumber) async {
    state = state.copyWith(
        validationStatus: AccountValidationStatus.loading, accountName: null, errorMessage: null);

    await Future.delayed(const Duration(seconds: 1));

    if (accountNumber == '1234567890') {
      state = state.copyWith(
        validationStatus: AccountValidationStatus.success,
        accountName: 'John Efemini Doe',
      );
    } else {
      state = state.copyWith(
        validationStatus: AccountValidationStatus.error,
        errorMessage: 'Invalid account number.',
      );
    }
  }

  // Resets the state to its initial values.
  void reset() {
    state = state.copyWith(
      selectedBank: null,
      accountNUmber: '',
      amount: null,
      validationStatus: AccountValidationStatus.initial,
      accountName: null,
      errorMessage: null,
    );
  }
}
