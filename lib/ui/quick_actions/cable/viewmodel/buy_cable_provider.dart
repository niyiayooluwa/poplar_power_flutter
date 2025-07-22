import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../data/mock/mock_repository/mock_cable_repository.dart';
import 'buy_cable_state.dart';
import 'buy_cable_viewmodel.dart';

final cablePackageRepositoryProvider = Provider<CablePackagesRepository>((ref) {
  return CablePackagesRepository();
});

final buyCableViewModelProvider =
    StateNotifierProvider.autoDispose<BuyCableViewModel, BuyCableState>((ref) {
      final repository = ref.watch(cablePackageRepositoryProvider);
      return BuyCableViewModel(repository);
    });
