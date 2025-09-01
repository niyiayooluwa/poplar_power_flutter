import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/data_sources/remote/electricity_remote_data_source.dart';
import 'package:poplar_power/data/repositories/electricity_repository_impl.dart';
import 'package:poplar_power/data/services/profile_providers.dart';
import 'package:poplar_power/domain/repositories/electricity_repository.dart';
import 'package:poplar_power/domain/use_cases/electricity/buy_electricity_token_use_case.dart';
import 'package:poplar_power/domain/use_cases/electricity/get_discos_for_category_use_case.dart';
import 'package:poplar_power/domain/use_cases/electricity/get_products_for_disco_use_case.dart';
import 'package:poplar_power/ui/quick_actions/electricity/viewmodel/buy_electricity_state.dart';
import 'package:poplar_power/ui/quick_actions/electricity/viewmodel/buy_electricity_viewmodel.dart';

// Data Source Provider
final electricityRemoteDataSourceProvider =
    Provider<ElectricityRemoteDataSource>((ref) {
  return ElectricityRemoteDataSourceImpl();
});

// Repository Provider
final electricityRepositoryProvider = Provider<ElectricityRepository>((ref) {
  final remoteDataSource = ref.watch(electricityRemoteDataSourceProvider);
  return ElectricityRepositoryImpl(remoteDataSource);
});

// Use Case Providers
final getDiscosForCategoryUseCaseProvider =
    Provider<GetDiscosForCategoryUseCase>((ref) {
  final repository = ref.watch(electricityRepositoryProvider);
  return GetDiscosForCategoryUseCase(repository);
});

final getProductsForDiscoUseCaseProvider =
    Provider<GetProductsForDiscoUseCase>((ref) {
  final repository = ref.watch(electricityRepositoryProvider);
  return GetProductsForDiscoUseCase(repository);
});

final buyElectricityTokenUseCaseProvider =
    Provider<BuyElectricityTokenUseCase>((ref) {
  final repository = ref.watch(electricityRepositoryProvider);
  return BuyElectricityTokenUseCase(repository);
});

final buyElectricityViewModelProvider = StateNotifierProvider.autoDispose<
    BuyElectricityViewModel, BuyElectricityState>((ref) {
  final getDiscosForCategoryUseCase =
      ref.watch(getDiscosForCategoryUseCaseProvider);
  final getProductsForDiscoUseCase = ref.watch(getProductsForDiscoUseCaseProvider);
  final buyElectricityTokenUseCase = ref.watch(buyElectricityTokenUseCaseProvider);
  final getProfileUseCase = ref.watch(getProfileUseCaseProvider);

  return BuyElectricityViewModel(
    getDiscosForCategoryUseCase,
    getProductsForDiscoUseCase,
    buyElectricityTokenUseCase,
    getProfileUseCase
  );
});
