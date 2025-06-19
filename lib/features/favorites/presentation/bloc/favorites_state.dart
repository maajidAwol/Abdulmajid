part of 'favorites_bloc.dart';

@immutable
abstract class FavoritesState {}

final class FavoritesInitial extends FavoritesState {}

final class FavoritesLoading extends FavoritesState {}

final class FavoritesLoaded extends FavoritesState {
  final List<FavoriteCountry> favorites;

  FavoritesLoaded({required this.favorites});
}

final class FavoritesError extends FavoritesState {
  final String message;

  FavoritesError(this.message);
}

final class FavoriteStatusLoaded extends FavoritesState {
  final String countryName;
  final bool isFavorite;

  FavoriteStatusLoaded({required this.countryName, required this.isFavorite});
}
