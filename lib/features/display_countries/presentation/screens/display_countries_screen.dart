import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/injection/injection_container.dart' as di;
import '../../../../core/theme/app_theme.dart';
import '../bloc/countries_bloc.dart';
import '../widgets/country_card.dart';
import '../widgets/search_widget.dart';

class DisplayCountriesScreen extends StatelessWidget {
  const DisplayCountriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<CountriesBloc>()..add(GetCountriesEvent()),
      child: const DisplayCountriesView(),
    );
  }
}

class DisplayCountriesView extends StatefulWidget {
  const DisplayCountriesView({super.key});

  @override
  State<DisplayCountriesView> createState() => _DisplayCountriesViewState();
}

class _DisplayCountriesViewState extends State<DisplayCountriesView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              color: theme.appBarTheme.backgroundColor,
              child: Column(
                children: [
                  // Title and Theme Toggle
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Countries',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                            height: 1.2,
                          ),
                        ),
                        // Theme Toggle Button
                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colorScheme.primary.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                context.read<ThemeCubit>().toggleTheme();
                              },
                              child: Center(
                                child: Icon(
                                  isDark ? Icons.light_mode : Icons.dark_mode,
                                  color: colorScheme.primary,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Search Widget
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    child: SearchWidget(
                      controller: _searchController,
                      onChanged: (query) {
                        context.read<CountriesBloc>().add(
                          SearchCountriesEvent(query),
                        );
                      },
                    ),
                  ),
                  // Bottom shadow
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          colorScheme.outline.withOpacity(0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Countries List
            Expanded(
              child: BlocBuilder<CountriesBloc, CountriesState>(
                builder: (context, state) {
                  if (state is CountriesLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.primary,
                        ),
                      ),
                    );
                  } else if (state is CountriesLoaded) {
                    final countries = state.filteredCountries;

                    if (countries.isEmpty) {
                      return _buildEmptyState(state.searchQuery, colorScheme);
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<CountriesBloc>().add(GetCountriesEvent());
                      },
                      color: colorScheme.primary,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                        itemCount: countries.length,
                        itemBuilder: (context, index) {
                          return CountryCard(country: countries[index]);
                        },
                      ),
                    );
                  } else if (state is CountriesError) {
                    return _buildErrorState(
                      state.message,
                      () => context.read<CountriesBloc>().add(
                        GetCountriesEvent(),
                      ),
                      colorScheme,
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String searchQuery, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.search_off,
                size: 40,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              searchQuery.isEmpty
                  ? 'No countries found'
                  : 'No countries found for "$searchQuery"',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching with a different term',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(
    String message,
    VoidCallback onRetry,
    ColorScheme colorScheme,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.error_outline,
                size: 40,
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
