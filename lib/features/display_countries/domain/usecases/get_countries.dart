import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/countries_entitiy.dart';
import '../repositories/countries_repository.dart';

class GetCountries {
  final CountriesRepository repository;

  GetCountries(this.repository);

  Future<Either<Failure, List<CountryEntity>>> call() async {
    return await repository.getAllCountries();
  }
}
