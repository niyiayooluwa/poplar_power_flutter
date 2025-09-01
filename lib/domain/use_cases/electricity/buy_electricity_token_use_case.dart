
import 'package:dart_either/dart_either.dart';
import 'package:poplar_power/data/models/electricity/buy_token_request_dto.dart';
import 'package:poplar_power/domain/failures/biller_failure.dart';
import 'package:poplar_power/domain/repositories/electricity_repository.dart';

class BuyElectricityTokenUseCase {
  final ElectricityRepository _repository;

  BuyElectricityTokenUseCase(this._repository);

  Future<Either<BillerFailure, void>> execute(BuyTokenRequestDto request) async {
    return await _repository.buyToken(request);
  }
}
