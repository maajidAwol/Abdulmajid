import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../display_countries/domain/entities/countries_entitiy.dart';
import '../../domain/entities/favorite_country.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_data_source.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;

  FavoritesRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<FavoriteCountry>>> getFavoriteCountries() async {
    try {
      final favoriteModels = await localDataSource.getFavoriteCountries();
      final favorites =
          favoriteModels.map((model) => model.toEntity()).toList();
      return Right(favorites);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.toString()));
    } on Exception catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToFavorites(CountryEntity country) async {
    try {
      await localDataSource.addToFavorites(country);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.toString()));
    } on Exception catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromFavorites(String countryName) async {
    try {
      await localDataSource.removeFromFavorites(countryName);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.toString()));
    } on Exception catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(String countryName) async {
    try {
      final isFavorite = await localDataSource.isFavorite(countryName);
      return Right(isFavorite);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.toString()));
    } on Exception catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
