import 'package:dart_either/dart_either.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/models/billers/customer_verification/customer_verification_request_dto.dart';
import 'package:poplar_power/data/repositories/biller_repository_impl.dart';
import 'package:poplar_power/domain/failures/biller_failure.dart';
import 'package:poplar_power/domain/models/customer_verification.dart';
import 'package:poplar_power/domain/repositories/biller_repository.dart';

class VerifyCustomerUseCase {
  final BillerRepository _repository;

  VerifyCustomerUseCase(this._repository);

  Future<Either<BillerFailure, CustomerVerification>> execute(
    CustomerVerificationRequestDto request,
  ) async {
    return await _repository.verifyCustomer(request);
  }
}

final verifyCustomerUseCaseProvider = Provider<VerifyCustomerUseCase>((ref) {
  final repository = ref.watch(billerRepositoryProvider);
  return VerifyCustomerUseCase(repository);
});
