import 'package:repository_pattern/features/countries/data/network/client/api_client.dart';
import 'package:repository_pattern/features/countries/data/network/network_mapper.dart';
import 'package:repository_pattern/features/countries/domain/model/country.dart';

class CountriesRepository {
  final ApiClient apiClient;
  final NetworkMapper networkMapper;

  CountriesRepository({
    required this.apiClient,
    required this.networkMapper,
  });

  Future<List<Country>> getCountries({
    String? namePrefix,
  }) async {
    final countries = await apiClient.getCountries(namePrefix: namePrefix);
    return networkMapper.toCountries(countries.data);
  }
}
