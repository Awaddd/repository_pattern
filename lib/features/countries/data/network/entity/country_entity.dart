import 'package:json_annotation/json_annotation.dart';

part 'country_entity.g.dart';

@JsonSerializable()
class Countries {
  List<CountryEntity> data;

  Countries({
    required this.data,
  });

  factory Countries.fromJson(Map<String, dynamic> json) =>
      _$CountriesFromJson(json);
}

@JsonSerializable()
class CountryEntity {
  String code;
  String name;

  CountryEntity({
    required this.code,
    required this.name,
  });

  factory CountryEntity.fromJson(Map<String, dynamic> json) =>
      _$CountryEntityFromJson(json);
}
