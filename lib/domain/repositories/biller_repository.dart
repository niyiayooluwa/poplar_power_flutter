import 'package:dart_either/dart_either.dart';
import 'package:poplar_power/data/models/billers/buy_token_request_dto.dart';
import 'package:poplar_power/domain/failures/biller_failure.dart';
import 'package:poplar_power/domain/models/biller_product.dart';
import 'package:poplar_power/domain/models/biller.dart';

abstract class BillerRepository {
  Future<Either<BillerFailure, List<Biller>>> getBillersForCategory(String categoryId);

  Future<Either<BillerFailure, List<BillerProduct>>> getProductsForBiller(
    String billerId,
  );

  Future<Either<BillerFailure, void>> buyToken(BuyTokenRequestDto request);
}