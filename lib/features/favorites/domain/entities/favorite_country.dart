import 'package:equatable/equatable.dart';

import '../../../display_countries/domain/entities/countries_entitiy.dart';

class FavoriteCountry extends Equatable {
  final CountryEntity country;
  final DateTime dateAdded;

  const FavoriteCountry({required this.country, required this.dateAdded});

  @override
  List<Object> get props => [country, dateAdded];
}
