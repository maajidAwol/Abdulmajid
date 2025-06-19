import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../databases/api/api_consumer.dart';
import '../databases/api/dio_consumer.dart';
import '../network/network_info.dart';
import '../../features/display_countries/data/datasources/countries_local_data_source.dart';
import '../../features/display_countries/data/datasources/countries_remote_data_source.dart';
import '../../features/display_countries/data/repositories/countries_repository_impl.dart';
import '../../features/display_countries/domain/repositories/countries_repository.dart';
import '../../features/display_countries/domain/usecases/get_countries.dart';
import '../../features/display_countries/presentation/bloc/countries_bloc.dart';

// Favorites imports
import '../../features/favorites/data/datasources/favorites_local_data_source.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/favorites/domain/repositories/favorites_repository.dart';
import '../../features/favorites/domain/usecases/check_favorite_status.dart';
import '../../features/favorites/domain/usecases/get_favorites.dart';
import '../../features/favorites/domain/usecases/toggle_favorite.dart';
import '../../features/favorites/presentation/bloc/favorites_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Countries
  // Bloc
  sl.registerFactory(() => CountriesBloc(getCountries: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetCountries(sl()));

  // Repository
  sl.registerLazySingleton<CountriesRepository>(
    () => CountriesRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<CountriesRemoteDataSource>(
    () => CountriesRemoteDataSourceImpl(apiConsumer: sl()),
  );

  sl.registerLazySingleton<CountriesLocalDataSource>(
    () => CountriesLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Features - Favorites
  // Bloc
  sl.registerFactory(
    () => FavoritesBloc(
      getFavorites: sl(),
      toggleFavorite: sl(),
      checkFavoriteStatus: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetFavorites(sl()));
  sl.registerLazySingleton(() => ToggleFavorite(sl()));
  sl.registerLazySingleton(() => CheckFavoriteStatus(sl()));

  // Repository
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(client: sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Connectivity());
}
