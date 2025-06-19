import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/countries_entitiy.dart';
import '../../domain/repositories/countries_repository.dart';
import '../datasources/countries_local_data_source.dart';
import '../datasources/countries_remote_data_source.dart';

class CountriesRepositoryImpl implements CountriesRepository {
  final CountriesRemoteDataSource remoteDataSource;
  final CountriesLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CountriesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CountryEntity>>> getAllCountries() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCountries = await remoteDataSource.getAllCountries();
        localDataSource.cacheCountries(remoteCountries);
        return Right(
          remoteCountries.map((country) => country.toEntity()).toList(),
        );
      } on ServerException catch (e) {
        return Left(ServerFailure(e.toString()));
      } on FetchDataException catch (e) {
        return Left(NetworkFailure(e.toString()));
      } on Exception catch (e) {
        return Left(UnexpectedFailure(e.toString()));
      }
    } else {
      try {
        final localCountries = await localDataSource.getLastCountries();
        return Right(
          localCountries.map((country) => country.toEntity()).toList(),
        );
      } on CacheException catch (e) {
        return Left(CacheFailure(e.toString()));
      }
    }
  }
}
