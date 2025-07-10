/// This file defines the providers used for managing data bundle purchases.
///
/// It includes providers for the data bundle repository and the view model
/// responsible for handling the business logic of buying data.
library;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../data/mock/mock_repository/mock_data_repository.dart';
import 'buy_data_view_model.dart';
import 'buy_data_state.dart';

/// Provider for accessing the [DataBundleRepository].
///
/// This provider creates an instance of [DataBundleRepository], which is responsible
/// for fetching and managing data bundle information.
final dataBundleRepositoryProvider = Provider<DataBundleRepository>((ref) {
  return DataBundleRepository();
});

/// Provider for the [BuyDataViewModel].
///
/// This provider creates an instance of [BuyDataViewModel] and injects
/// the [DataBundleRepository] into it. The [BuyDataViewModel] handles the
/// state and logic for the data purchase process.
final buyDataViewModelProvider =
    StateNotifierProvider.autoDispose<BuyDataViewModel, BuyDataState>((ref) {
  final repository = ref.watch(dataBundleRepositoryProvider);
  return BuyDataViewModel(repository);
});