import 'package:equatable/equatable.dart';

class CountryEntity extends Equatable {
  final String name;
  final int population;
  final String flagUrl;
  final String flagEmoji;
  final double area;
  final String region;
  final String subregion;
  final List<String> timezones;

  const CountryEntity({
    required this.name,
    required this.population,
    required this.flagUrl,
    required this.flagEmoji,
    required this.area,
    required this.region,
    required this.subregion,
    required this.timezones,
  });

  @override
  List<Object> get props => [
    name,
    population,
    flagUrl,
    flagEmoji,
    area,
    region,
    subregion,
    timezones,
  ];
}
