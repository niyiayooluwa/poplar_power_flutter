import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/mock/mock_repository/mock_bank_repository.dart';
import 'package:poplar_power/ui/send/viewmodel/send_state.dart';
import 'package:poplar_power/ui/send/viewmodel/send_viewmodel.dart';

final bankRepositoryProvider = Provider<BankRepository>((ref) {
  return BankRepository();
});

final sendViewModelProvider =
    StateNotifierProvider.autoDispose<SendViewModel, SendState>((ref) {
      final repository = ref.watch(bankRepositoryProvider);
      return SendViewModel(repository);
    });
