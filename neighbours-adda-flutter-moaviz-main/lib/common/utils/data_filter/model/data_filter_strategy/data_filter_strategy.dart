import 'package:snap_local/common/utils/data_filter/model/data_filter/data_filter.dart';

abstract class DataFilterStrategy {
  DataFilter applyFilter(DataFilter existingFilter);
}
