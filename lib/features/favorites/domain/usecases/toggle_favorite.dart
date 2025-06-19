import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../display_countries/domain/entities/countries_entitiy.dart';
import '../repositories/favorites_repository.dart';

class ToggleFavorite {
  final FavoritesRepository repository;

  ToggleFavorite(this.repository);

  Future<Either<Failure, bool>> call(CountryEntity country) async {
    final isFavoriteResult = await repository.isFavorite(country.name);

    return isFavoriteResult.fold((failure) => Left(failure), (
      isFavorite,
    ) async {
      if (isFavorite) {
        final removeResult = await repository.removeFromFavorites(country.name);
        return removeResult.fold(
          (failure) => Left(failure),
          (_) => const Right(false), // Removed from favorites
        );
      } else {
        final addResult = await repository.addToFavorites(country);
        return addResult.fold(
          (failure) => Left(failure),
          (_) => const Right(true), // Added to favorites
        );
      }
    });
  }
}
