import 'package:dart_either/dart_either.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/repositories/biller_repository_impl.dart';
import 'package:poplar_power/domain/failures/biller_failure.dart';
import 'package:poplar_power/domain/models/biller_product.dart';
import 'package:poplar_power/domain/repositories/biller_repository.dart';

class GetProductsForBillerUseCase {
  final BillerRepository _repository;

  GetProductsForBillerUseCase(this._repository);

  Future<Either<BillerFailure, List<BillerProduct>>> execute(
    String billerId,
  ) async {
    return await _repository.getProductsForBiller(billerId);
  }
}

final getProductsForBillerUseCaseProvider =
    Provider<GetProductsForBillerUseCase>((ref) {
      final repository = ref.watch(billerRepositoryProvider);
      return GetProductsForBillerUseCase(repository);
    });
