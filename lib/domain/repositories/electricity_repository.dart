import 'package:dart_either/dart_either.dart';
import 'package:poplar_power/data/models/electricity/buy_token_request_dto.dart';
import 'package:poplar_power/domain/failures/biller_failure.dart';
import 'package:poplar_power/domain/models/biller_product.dart';
import 'package:poplar_power/domain/models/electricity_disco.dart';

abstract class ElectricityRepository {
  Future<Either<BillerFailure, List<ElectricityDisco>>> getDiscosForCategory();

  Future<Either<BillerFailure, List<BillerProduct>>> getProductsForDisco(
    String discoId,
  );

  Future<Either<BillerFailure, void>> buyToken(BuyTokenRequestDto request);
}