import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/countries_model.dart';

abstract class CountriesLocalDataSource {
  Future<List<CountryModel>> getLastCountries();
  Future<void> cacheCountries(List<CountryModel> countries);
}

const cachedCountries = 'CACHED_COUNTRIES';

class CountriesLocalDataSourceImpl implements CountriesLocalDataSource {
  final SharedPreferences sharedPreferences;

  CountriesLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<CountryModel>> getLastCountries() {
    final jsonString = sharedPreferences.getString(cachedCountries);
    if (jsonString != null) {
      final jsonList = json.decode(jsonString) as List;
      return Future.value(
        jsonList.map((json) => CountryModel.fromJson(json)).toList(),
      );
    } else {
      throw const CacheException();
    }
  }

  @override
  Future<void> cacheCountries(List<CountryModel> countries) {
    final jsonString = json.encode(
      countries.map((country) => country.toJson()).toList(),
    );
    return sharedPreferences.setString(cachedCountries, jsonString);
  }
}
