import '../../domain/entities/countries_entitiy.dart';

class CountryModel extends CountryEntity {
  const CountryModel({
    required super.name,
    required super.population,
    required super.flagUrl,
    required super.flagEmoji,
    required super.area,
    required super.region,
    required super.subregion,
    required super.timezones,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    final flags = json['flags'] as Map<String, dynamic>?;
    final name = (json['name'] as Map<String, dynamic>)['common'] as String;

    return CountryModel(
      name: name,
      population: json['population'] as int,
      flagUrl: flags?['png'] as String? ?? '',
      flagEmoji: json['flag'] as String? ?? _getDefaultFlag(name),
      area: (json['area'] as num).toDouble(),
      region: json['region'] as String? ?? '',
      subregion: json['subregion'] as String? ?? '',
      timezones: List<String>.from(json['timezones'] as List),
    );
  }

  static String _getDefaultFlag(String countryName) {
    // Fallback flags for countries that might not have emoji flags
    final flagMap = {
      'Afghanistan': '🇦🇫',
      'Albania': '🇦🇱',
      'Algeria': '🇩🇿',
      'Argentina': '🇦🇷',
      'Australia': '🇦🇺',
      'Austria': '🇦🇹',
      'Bangladesh': '🇧🇩',
      'Belgium': '🇧🇪',
      'Brazil': '🇧🇷',
      'Canada': '🇨🇦',
      'China': '🇨🇳',
      'France': '🇫🇷',
      'Germany': '🇩🇪',
      'India': '🇮🇳',
      'Italy': '🇮🇹',
      'Japan': '🇯🇵',
      'Kenya': '🇰🇪',
      'Mexico': '🇲🇽',
      'Nigeria': '🇳🇬',
      'Russia': '🇷🇺',
      'South Africa': '🇿🇦',
      'Spain': '🇪🇸',
      'United Kingdom': '🇬🇧',
      'United States': '🇺🇸',
    };

    return flagMap[countryName] ?? '🏳️';
  }

  Map<String, dynamic> toJson() {
    return {
      'name': {'common': name},
      'population': population,
      'flags': {'png': flagUrl},
      'flag': flagEmoji,
      'area': area,
      'region': region,
      'subregion': subregion,
      'timezones': timezones,
    };
  }

  CountryEntity toEntity() {
    return CountryEntity(
      name: name,
      population: population,
      flagUrl: flagUrl,
      flagEmoji: flagEmoji,
      area: area,
      region: region,
      subregion: subregion,
      timezones: timezones,
    );
  }
}
