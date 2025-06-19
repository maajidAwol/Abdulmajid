import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/countries_entitiy.dart';
import '../../domain/usecases/get_countries.dart';

part 'countries_event.dart';
part 'countries_state.dart';

class CountriesBloc extends Bloc<CountriesEvent, CountriesState> {
  final GetCountries getCountries;

  CountriesBloc({required this.getCountries}) : super(CountriesInitial()) {
    on<GetCountriesEvent>(_onGetCountries);
    on<SearchCountriesEvent>(_onSearchCountries);
  }

  Future<void> _onGetCountries(
    GetCountriesEvent event,
    Emitter<CountriesState> emit,
  ) async {
    emit(CountriesLoading());

    final result = await getCountries();

    result.fold(
      (failure) => emit(CountriesError(failure.message)),
      (countries) => emit(CountriesLoaded(countries: countries)),
    );
  }

  void _onSearchCountries(
    SearchCountriesEvent event,
    Emitter<CountriesState> emit,
  ) {
    final currentState = state;
    if (currentState is CountriesLoaded) {
      if (event.query.isEmpty) {
        emit(
          CountriesLoaded(
            countries: currentState.countries,
            filteredCountries: currentState.countries,
            searchQuery: '',
          ),
        );
      } else {
        final filteredCountries =
            currentState.countries
                .where(
                  (country) => country.name.toLowerCase().contains(
                    event.query.toLowerCase(),
                  ),
                )
                .toList();

        emit(
          CountriesLoaded(
            countries: currentState.countries,
            filteredCountries: filteredCountries,
            searchQuery: event.query,
          ),
        );
      }
    }
  }
}
