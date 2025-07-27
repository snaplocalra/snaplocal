import 'package:dio/dio.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';

import '../../../../utility/constant/errors.dart';

class ValueCompressorRepository extends BaseApi {
//Compresses the value
  Future<String> compressValue(String value) async {
    try {
      FormData data = FormData.fromMap({'value': value});
      final dio = dioClient();
      return await dio.post("compress_link_value", data: data).then((response) {
        if (response.data['status'] == "valid") {
          return response.data['uuid'];
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw (ErrorConstants.serverError);
        }
      }
      rethrow;
    }
  }

  //Decompresses the value
  Future<String?> decompressValue(String key) async {
    try {
      FormData data = FormData.fromMap({'key': key});
      final dio = dioClient();
      return await dio
          .post("decompress_link_value", data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return response.data['value'];
        }
        return null;
      });
    } catch (e) {
      return null;
    }
  }
}
