import 'package:dart_either/dart_either.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/models/billers/buy_token_request_dto.dart';
import 'package:poplar_power/data/repositories/biller_repository_impl.dart';
import 'package:poplar_power/domain/failures/biller_failure.dart';
import 'package:poplar_power/domain/repositories/biller_repository.dart';

class BuyElectricityTokenUseCase {
  final BillerRepository _repository;

  BuyElectricityTokenUseCase(this._repository);

  Future<Either<BillerFailure, void>> execute(
    BuyTokenRequestDto request,
  ) async {
    return await _repository.buyToken(request);
  }
}

final buyElectricityTokenUseCaseProvider = Provider<BuyElectricityTokenUseCase>(
  (ref) {
    final repository = ref.watch(billerRepositoryProvider);
    return BuyElectricityTokenUseCase(repository);
  },
);
