import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/countries_entitiy.dart';

abstract class CountriesRepository {
  Future<Either<Failure, List<CountryEntity>>> getAllCountries();
}
