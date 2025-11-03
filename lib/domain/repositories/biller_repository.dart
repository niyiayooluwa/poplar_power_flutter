import 'package:dart_either/dart_either.dart';
import 'package:poplar_power/data/models/billers/customer_verification/customer_verification_request_dto.dart';
import 'package:poplar_power/data/models/billers/payment_request_dto.dart';
import 'package:poplar_power/domain/failures/biller_failure.dart';
import 'package:poplar_power/domain/models/biller.dart';
import 'package:poplar_power/domain/models/biller_product.dart';
import 'package:poplar_power/domain/models/customer_verification.dart';
import 'package:poplar_power/domain/models/purchase_response.dart';

abstract class BillerRepository {
  Future<Either<BillerFailure, List<Biller>>> getBillersForCategory(
    String categoryId,
  );

  Future<Either<BillerFailure, List<BillerProduct>>> getProductsForBiller(
    String billerId,
  );

  Future<Either<BillerFailure, PurchaseResponse>> purchase(
    PaymentRequestDto request,
  );

  Future<Either<BillerFailure, CustomerVerification>> verifyCustomer(
    CustomerVerificationRequestDto request,
  );
}
