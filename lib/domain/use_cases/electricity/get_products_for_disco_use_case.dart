
import 'package:dart_either/dart_either.dart';
import 'package:poplar_power/domain/failures/biller_failure.dart';
import 'package:poplar_power/domain/models/biller_product.dart';
import 'package:poplar_power/domain/repositories/electricity_repository.dart';

class GetProductsForDiscoUseCase {
  final ElectricityRepository _repository;

  GetProductsForDiscoUseCase(this._repository);

  Future<Either<BillerFailure, List<BillerProduct>>> execute(String discoId) async {
    return await _repository.getProductsForDisco(discoId);
  }
}
