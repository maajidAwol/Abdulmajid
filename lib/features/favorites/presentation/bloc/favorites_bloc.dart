import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../display_countries/domain/entities/countries_entitiy.dart';
import '../../domain/entities/favorite_country.dart';
import '../../domain/usecases/check_favorite_status.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/toggle_favorite.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavorites getFavorites;
  final ToggleFavorite toggleFavorite;
  final CheckFavoriteStatus checkFavoriteStatus;

  FavoritesBloc({
    required this.getFavorites,
    required this.toggleFavorite,
    required this.checkFavoriteStatus,
  }) : super(FavoritesInitial()) {
    on<GetFavoritesEvent>(_onGetFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<CheckFavoriteStatusEvent>(_onCheckFavoriteStatus);
  }

  Future<void> _onGetFavorites(
    GetFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());

    final result = await getFavorites();

    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (favorites) => emit(FavoritesLoaded(favorites: favorites)),
    );
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await toggleFavorite(event.country);

    result.fold((failure) => emit(FavoritesError(failure.message)), (
      isFavorite,
    ) {
      // Emit status immediately for UI updates
      emit(
        FavoriteStatusLoaded(
          countryName: event.country.name,
          isFavorite: isFavorite,
        ),
      );
    });
  }

  Future<void> _onCheckFavoriteStatus(
    CheckFavoriteStatusEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await checkFavoriteStatus(event.countryName);

    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (isFavorite) => emit(
        FavoriteStatusLoaded(
          countryName: event.countryName,
          isFavorite: isFavorite,
        ),
      ),
    );
  }
}
