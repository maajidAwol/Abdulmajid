part of 'countries_bloc.dart';

@immutable
abstract class CountriesState {}

final class CountriesInitial extends CountriesState {}

final class CountriesLoading extends CountriesState {}

final class CountriesLoaded extends CountriesState {
  final List<CountryEntity> countries;
  final List<CountryEntity> filteredCountries;
  final String searchQuery;

  CountriesLoaded({
    required this.countries,
    List<CountryEntity>? filteredCountries,
    this.searchQuery = '',
  }) : filteredCountries = filteredCountries ?? countries;
}

final class CountriesError extends CountriesState {
  final String message;

  CountriesError(this.message);
}
