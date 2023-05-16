import 'package:dio/dio.dart';
import 'package:repository_pattern/features/countries/data/network/entity/country_entity.dart';
import 'package:repository_pattern/features/countries/domain/exception/network_exception.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient({
    required String baseUrl,
    required String apiKey,
    required String apiHost,
  }) {
    _dio = Dio()
      ..options.baseUrl = baseUrl
      ..options.headers = {
        'X-RapidAPI-Key': apiKey,
        'X-RapidAPI-Host': apiHost,
      }
      ..interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
  }

  Future<Countries> getCountries({String? namePrefix}) async {
    final response = await _dio.get(
      'countries',
      queryParameters: {'namePrefix': namePrefix},
    );

    if (response.statusCode != null && response.statusCode! >= 400) {
      throw NetworkException(
        statusCode: response.statusCode!,
        message: response.statusMessage,
      );
    } else if (response.statusCode != null) {
      return Countries.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Unknown error');
    }
  }
}
