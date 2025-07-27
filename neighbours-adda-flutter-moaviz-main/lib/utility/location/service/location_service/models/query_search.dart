import 'package:snap_local/common/utils/location/model/location_helper_models/location_by_address.dart';

abstract class QuerySearch {
  /// Fetch Address By Query
  Future<List<LocationByAddressModel>> fetchAddressByQuery(String query);

}
