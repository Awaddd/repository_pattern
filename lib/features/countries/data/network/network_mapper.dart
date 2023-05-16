import 'package:logger/logger.dart';
import 'package:repository_pattern/features/countries/data/network/entity/country_entity.dart';
import 'package:repository_pattern/features/countries/domain/exception/mapper_exception.dart';
import 'package:repository_pattern/features/countries/domain/model/country.dart';

class NetworkMapper {
  final Logger log;

  NetworkMapper({required this.log});

  Country toCountry(CountryEntity entity) {
    try {
      return Country(code: entity.code, name: entity.name);
    } catch (e) {
      throw MapperException<CountryEntity, Country>(e.toString());
    }
  }

  List<Country> toCountries(List<CountryEntity> entities) {
    final List<Country> countries = [];

    for (final entity in entities) {
      try {
        countries.add(toCountry(entity));
      } catch (e) {
        log.w('Could not map entity ${entity.name}', e);
      }
    }

    return countries;
  }
}
