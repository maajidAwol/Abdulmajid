part of 'favorites_bloc.dart';

@immutable
abstract class FavoritesEvent {}

class GetFavoritesEvent extends FavoritesEvent {}

class ToggleFavoriteEvent extends FavoritesEvent {
  final CountryEntity country;

  ToggleFavoriteEvent(this.country);
}

class CheckFavoriteStatusEvent extends FavoritesEvent {
  final String countryName;

  CheckFavoriteStatusEvent(this.countryName);
}
