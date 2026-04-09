import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  late final Dio dio;

  static String? token;

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: "http://store2.runasp.net/api/",
        connectTimeout: const Duration(seconds: 20), // ⬅️ زودناها
        receiveTimeout: const Duration(seconds: 60), // ⬅️ مهم جدًا
        sendTimeout: const Duration(seconds: 60), // ⬅️ مهم جدًا
        headers: {"Accept": "application/json"},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint("================= API REQUEST =================");
          debugPrint("Method: ${options.method}");
          debugPrint("URL: ${options.uri}");
          debugPrint("Headers: ${options.headers}");
          if (options.queryParameters.isNotEmpty) {
            debugPrint("QueryParameters: ${options.queryParameters}");
          }
          if (options.data != null) {
            try {
              if (options.data is FormData) {
                 final fd = options.data as FormData;
                 debugPrint("Body (FormData): Fields: ${fd.fields}, Files lengths: ${fd.files.length}");
              } else {
                 debugPrint("Body: ${options.data}");
              }
            } catch (_) {
              debugPrint("Body: ${options.data}");
            }
          }
          debugPrint("===============================================");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint("================= API RESPONSE =================");
          debugPrint("URL: ${response.requestOptions.uri}");
          debugPrint("StatusCode: ${response.statusCode}");
          debugPrint("Response data: ${response.data}");
          debugPrint("================================================");
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          debugPrint("================= API ERROR ===================");
          debugPrint("URL: ${e.requestOptions.uri}");
          debugPrint("StatusCode: ${e.response?.statusCode}");
          debugPrint("Type: ${e.type}");
          debugPrint("Message: ${e.message}");
          debugPrint("Response Data: ${e.response?.data}");
          debugPrint("===============================================");
          return handler.next(e);
        },
      ),
    );
  }

  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    return await dio.get(
      endpoint,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
  }

  Future<Response> post(
    String endpoint,
    dynamic data, {
    Map<String, dynamic>? headers,
    bool isFormData = false,
  }) async {
    final contentType = isFormData
        ? Headers.multipartFormDataContentType
        : Headers.jsonContentType;

    return await dio.post(
      endpoint,
      data: data,
      options: Options(headers: headers, contentType: contentType),
    );
  }

  Future<Response> patch(
    String endpoint,
    dynamic data, {
    Map<String, dynamic>? headers,
  }) async {
    return await dio.patch(
      endpoint,
      data: data,
      options: Options(headers: headers),
    );
  }

  Future<Response> delete(
    String endpoint, {
    Map<String, dynamic>? headers,
  }) async {
    return await dio.delete(endpoint, options: Options(headers: headers));
  }

  Future<Response> createOrder({
    required String address,
    required String phone,
    required int deliveryMethodId,
    required String paymentMethod,
  }) async {
    return await post(
      "Orders/CreateOrder",
      {
        "address": address,
        "phone": phone,
        "deliveryMethodId": deliveryMethodId,
        "paymentMethod": paymentMethod,
      },
    );
  }

  Map<String, String> handleError(DioException e) {
    Map<String, String> errors = {};

    if (e.response != null) {
      final data = e.response?.data;

      if (data is List) {
        for (var item in data) {
          if (item is Map) {
            final code = item['code']?.toString().toLowerCase();
            final description = item['description']?.toString();

            if (code != null && description != null) {
              if (code.contains("password")) {
                errors["password"] = description;
              } else if (code.contains("email")) {
                errors["email"] = description;
              } else if (code.contains("name")) {
                errors["fullname"] = description;
              } else {
                errors["general"] = description;
              }
            }
          }
        }
        if (errors.isNotEmpty) return errors;
      }

      if (data is Map && data['message'] != null) {
        return {"general": data['message'].toString()};
      }

      if (data is Map && data['title'] != null) {
        return {"general": data['title'].toString()};
      }

      return {"general": "Server error"};
    }

    if (e.type == DioExceptionType.connectionTimeout) {
      return {"general": "Connection timeout"};
    }

    if (e.type == DioExceptionType.receiveTimeout) {
      return {"general": "Server not responding"};
    }

    return {"general": "No internet connection"};
  }
}
