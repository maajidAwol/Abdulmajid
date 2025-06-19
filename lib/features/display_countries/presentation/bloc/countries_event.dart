part of 'countries_bloc.dart';

@immutable
abstract class CountriesEvent {}

class GetCountriesEvent extends CountriesEvent {}

class SearchCountriesEvent extends CountriesEvent {
  final String query;

  SearchCountriesEvent(this.query);
}
