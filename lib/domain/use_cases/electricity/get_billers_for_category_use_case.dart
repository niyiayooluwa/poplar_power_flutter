import 'package:dart_either/dart_either.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/repositories/biller_repository_impl.dart';
import 'package:poplar_power/domain/failures/biller_failure.dart';
import 'package:poplar_power/domain/models/biller.dart';
import 'package:poplar_power/domain/repositories/biller_repository.dart';

class GetBillersForCategoryUseCase {
  final BillerRepository _repository;

  GetBillersForCategoryUseCase(this._repository);

  Future<Either<BillerFailure, List<Biller>>> execute(String categoryId) {
    return _repository.getBillersForCategory(categoryId);
  }
}

final getBillersForCategoryUseCaseProvider =
    Provider<GetBillersForCategoryUseCase>((ref) {
      final repository = ref.watch(billerRepositoryProvider);
      return GetBillersForCategoryUseCase(repository);
    });
