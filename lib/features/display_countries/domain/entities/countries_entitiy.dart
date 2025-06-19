import 'package:equatable/equatable.dart';

class CountryEntity extends Equatable {
  final String name;
  final int population;
  final String flag;
  final double area;
  final String region;
  final String subregion;
  final List<String> timezones;

  const CountryEntity({
    required this.name,
    required this.population,
    required this.flag,
    required this.area,
    required this.region,
    required this.subregion,
    required this.timezones,
  });

  @override
  List<Object> get props => [
    name,
    population,
    flag,
    area,
    region,
    subregion,
    timezones,
  ];
}
