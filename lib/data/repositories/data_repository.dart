import '../../domain/models/data_bundle.dart';

abstract class DataRepository {
  Future<List<DataBundle>> getBundlesForProvider(String provider);
}
