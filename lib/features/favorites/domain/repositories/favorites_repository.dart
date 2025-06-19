import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../display_countries/domain/entities/countries_entitiy.dart';
import '../entities/favorite_country.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<FavoriteCountry>>> getFavoriteCountries();
  Future<Either<Failure, void>> addToFavorites(CountryEntity country);
  Future<Either<Failure, void>> removeFromFavorites(String countryName);
  Future<Either<Failure, bool>> isFavorite(String countryName);
}
