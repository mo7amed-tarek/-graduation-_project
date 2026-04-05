import 'package:dio/dio.dart';

class ApiService {
  late final Dio dio;

  static String? token;

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: "http://store2.runasp.net/api/",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
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
      LogInterceptor(requestBody: true, responseBody: true, error: true),
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
