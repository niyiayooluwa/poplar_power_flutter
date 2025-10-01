import 'package:dart_either/dart_either.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/models/billers/payment_request_dto.dart';
import 'package:poplar_power/data/repositories/biller_repository_impl.dart';
import 'package:poplar_power/domain/failures/biller_failure.dart';
import 'package:poplar_power/domain/models/purchase_response.dart';
import 'package:poplar_power/domain/repositories/biller_repository.dart';

class BuyCableUseCase {
  final BillerRepository _repository;

  BuyCableUseCase(this._repository);

  Future<Either<BillerFailure, PurchaseResponse>> execute(
    PaymentRequestDto request,
  ) async {
    return await _repository.purchase(request);
  }
}

final buyCableUseCaseProvider = Provider<BuyCableUseCase>(
  (ref) {
    final repository = ref.watch(billerRepositoryProvider);
    return BuyCableUseCase(repository);
  },
);
