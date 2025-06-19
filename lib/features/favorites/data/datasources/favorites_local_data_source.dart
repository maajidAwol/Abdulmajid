import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../display_countries/domain/entities/countries_entitiy.dart';
import '../models/favorite_country_model.dart';

abstract class FavoritesLocalDataSource {
  Future<List<FavoriteCountryModel>> getFavoriteCountries();
  Future<void> addToFavorites(CountryEntity country);
  Future<void> removeFromFavorites(String countryName);
  Future<bool> isFavorite(String countryName);
}

const cachedFavorites = 'CACHED_FAVORITES';

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final SharedPreferences sharedPreferences;

  FavoritesLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<FavoriteCountryModel>> getFavoriteCountries() async {
    final jsonString = sharedPreferences.getString(cachedFavorites);
    if (jsonString != null) {
      final jsonList = json.decode(jsonString) as List;
      return jsonList
          .map((json) => FavoriteCountryModel.fromJson(json))
          .toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> addToFavorites(CountryEntity country) async {
    try {
      final favorites = await getFavoriteCountries();

      // Check if already exists
      final exists = favorites.any((fav) => fav.country.name == country.name);
      if (exists) return;

      final newFavorite = FavoriteCountryModel.fromCountry(country);
      favorites.add(newFavorite);

      await _saveFavorites(favorites);
    } catch (e) {
      throw const CacheException('Failed to add favorite');
    }
  }

  @override
  Future<void> removeFromFavorites(String countryName) async {
    try {
      final favorites = await getFavoriteCountries();
      favorites.removeWhere((fav) => fav.country.name == countryName);
      await _saveFavorites(favorites);
    } catch (e) {
      throw const CacheException('Failed to remove favorite');
    }
  }

  @override
  Future<bool> isFavorite(String countryName) async {
    try {
      final favorites = await getFavoriteCountries();
      return favorites.any((fav) => fav.country.name == countryName);
    } catch (e) {
      return false;
    }
  }

  Future<void> _saveFavorites(List<FavoriteCountryModel> favorites) async {
    final jsonString = json.encode(
      favorites.map((favorite) => favorite.toJson()).toList(),
    );
    await sharedPreferences.setString(cachedFavorites, jsonString);
  }
}
