import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/favorites_repository.dart';

class CheckFavoriteStatus {
  final FavoritesRepository repository;

  CheckFavoriteStatus(this.repository);

  Future<Either<Failure, bool>> call(String countryName) async {
    return await repository.isFavorite(countryName);
  }
}
