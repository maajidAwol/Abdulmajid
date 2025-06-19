import '../../../display_countries/data/models/countries_model.dart';
import '../../../display_countries/domain/entities/countries_entitiy.dart';
import '../../domain/entities/favorite_country.dart';

class FavoriteCountryModel extends FavoriteCountry {
  const FavoriteCountryModel({
    required super.country,
    required super.dateAdded,
  });

  factory FavoriteCountryModel.fromJson(Map<String, dynamic> json) {
    return FavoriteCountryModel(
      country: CountryModel.fromJson(json['country']),
      dateAdded: DateTime.parse(json['dateAdded']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country':
          CountryModel(
            name: country.name,
            population: country.population,
            flagUrl: country.flagUrl,
            flagEmoji: country.flagEmoji,
            area: country.area,
            region: country.region,
            subregion: country.subregion,
            timezones: country.timezones,
          ).toJson(),
      'dateAdded': dateAdded.toIso8601String(),
    };
  }

  factory FavoriteCountryModel.fromEntity(FavoriteCountry favoriteCountry) {
    return FavoriteCountryModel(
      country: favoriteCountry.country,
      dateAdded: favoriteCountry.dateAdded,
    );
  }

  FavoriteCountry toEntity() {
    return FavoriteCountry(country: country, dateAdded: dateAdded);
  }

  factory FavoriteCountryModel.fromCountry(CountryEntity country) {
    return FavoriteCountryModel(country: country, dateAdded: DateTime.now());
  }
}
