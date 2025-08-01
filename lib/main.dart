import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/injection/injection_container.dart' as di;
import 'core/theme/app_theme.dart';
import 'features/display_countries/presentation/bloc/countries_bloc.dart';
import 'features/display_countries/presentation/screens/display_countries_screen.dart';
import 'features/favorites/presentation/bloc/favorites_bloc.dart';
import 'features/favorites/presentation/screens/favorites_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const CountriesApp());
}

class CountriesApp extends StatelessWidget {
  const CountriesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Countries Explorer',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            home: MultiBlocProvider(
              providers: [
                BlocProvider<CountriesBloc>(
                  create:
                      (_) => di.sl<CountriesBloc>()..add(GetCountriesEvent()),
                ),
                BlocProvider<FavoritesBloc>(
                  create:
                      (_) => di.sl<FavoritesBloc>()..add(GetFavoritesEvent()),
                ),
              ],
              child: const MainScreen(),
            ),
          );
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const DisplayCountriesView(), // Use the view directly since BLoC is provided above
      const FavoritesView(), // Use the view directly since BLoC is provided above
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });

            // Refresh favorites when switching to favorites tab
            if (index == 1) {
              context.read<FavoritesBloc>().add(GetFavoritesEvent());
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
          ],
        ),
      ),
    );
  }
}
