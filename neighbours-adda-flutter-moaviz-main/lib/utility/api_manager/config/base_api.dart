import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'env/env.dart';

class BaseApi {
  static BaseOptions _options() {
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$apiusername:$apipassword'))}';
    return BaseOptions(
      baseUrl: "$baseUrl/",
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Authorization': basicAuth,
      },
      responseType: ResponseType.json,
      contentType: Headers.jsonContentType,
    );
  }

  Dio dioClient() {
    final dio = Dio(_options());
    if (!isProduction) {
      // print the api call log data
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ));
    }
    return dio;
  }
}
