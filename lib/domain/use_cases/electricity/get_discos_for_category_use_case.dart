import 'package:dart_either/dart_either.dart';
import 'package:poplar_power/domain/failures/biller_failure.dart';
import 'package:poplar_power/domain/models/electricity_disco.dart';
import 'package:poplar_power/domain/repositories/electricity_repository.dart';

class GetDiscosForCategoryUseCase {
  final ElectricityRepository _repository;

  GetDiscosForCategoryUseCase(this._repository);

  Future<Either<BillerFailure, List<ElectricityDisco>>> execute() {
    return _repository.getDiscosForCategory();
  }
}
