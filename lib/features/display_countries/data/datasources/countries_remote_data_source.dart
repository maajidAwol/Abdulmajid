import '../../../../core/databases/api/api_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../models/countries_model.dart';

abstract class CountriesRemoteDataSource {
  Future<List<CountryModel>> getAllCountries();
}

class CountriesRemoteDataSourceImpl implements CountriesRemoteDataSource {
  final ApiConsumer apiConsumer;

  CountriesRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<List<CountryModel>> getAllCountries() async {
    final response = await apiConsumer.get(
      EndPoints.baseUrl + EndPoints.countriesUrl,
    );

    final List<CountryModel> countries = [];
    for (final countryJson in response) {
      countries.add(CountryModel.fromJson(countryJson));
    }

    return countries;
  }
}
