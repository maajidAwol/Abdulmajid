import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/favorite_country.dart';
import '../repositories/favorites_repository.dart';

class GetFavorites {
  final FavoritesRepository repository;

  GetFavorites(this.repository);

  Future<Either<Failure, List<FavoriteCountry>>> call() async {
    return await repository.getFavoriteCountries();
  }
}
