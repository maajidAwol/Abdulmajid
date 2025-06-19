import '../../domain/entities/countries_entitiy.dart';

class CountryModel extends CountryEntity {
  const CountryModel({
    required super.name,
    required super.population,
    required super.flag,
    required super.area,
    required super.region,
    required super.subregion,
    required super.timezones,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      name: (json['name'] as Map<String, dynamic>)['common'] as String,
      population: json['population'] as int,
      flag: json['flag'] as String,
      area: (json['area'] as num).toDouble(),
      region: json['region'] as String? ?? '',
      subregion: json['subregion'] as String? ?? '',
      timezones: List<String>.from(json['timezones'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': {'common': name},
      'population': population,
      'flag': flag,
      'area': area,
      'region': region,
      'subregion': subregion,
      'timezones': timezones,
    };
  }

  CountryEntity toEntity() {
    return CountryEntity(
      name: name,
      population: population,
      flag: flag,
      area: area,
      region: region,
      subregion: subregion,
      timezones: timezones,
    );
  }
}
