import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/injection/injection_container.dart' as di;
import '../../domain/entities/countries_entitiy.dart';
import '../../../favorites/presentation/bloc/favorites_bloc.dart';

class CountryDetailsScreen extends StatelessWidget {
  final CountryEntity country;

  const CountryDetailsScreen({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              di.sl<FavoritesBloc>()
                ..add(CheckFavoriteStatusEvent(country.name)),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: CustomScrollView(
          slivers: [
            // App Bar with Flag and Title
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
              title: Text(
                country.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        Theme.of(context).scaffoldBackgroundColor,
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60), // Space for app bar
                      // Large Flag
                      Hero(
                        tag: 'flag_${country.name}',
                        child: Container(
                          width: 200,
                          height: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).shadowColor.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: _buildDetailFlag(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Country Details
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Information Cards
                    _buildInfoSection(context, 'Basic Information', [
                      _buildInfoCard(
                        context,
                        icon: Icons.people,
                        title: 'Population',
                        value: _formatPopulation(country.population),
                        color: Colors.blue,
                      ),
                      _buildInfoCard(
                        context,
                        icon: Icons.square_foot,
                        title: 'Area',
                        value: '${_formatArea(country.area)} km²',
                        color: Colors.green,
                      ),
                    ]),

                    const SizedBox(height: 24),

                    _buildInfoSection(context, 'Location', [
                      _buildInfoCard(
                        context,
                        icon: Icons.public,
                        title: 'Region',
                        value: country.region,
                        color: Colors.orange,
                      ),
                      _buildInfoCard(
                        context,
                        icon: Icons.location_on,
                        title: 'Subregion',
                        value:
                            country.subregion.isNotEmpty
                                ? country.subregion
                                : 'Not specified',
                        color: Colors.purple,
                      ),
                    ]),

                    const SizedBox(height: 24),

                    // Time Zones
                    _buildTimeZonesSection(context),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Floating Action Button for Favorites
        floatingActionButton: BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, state) {
            bool isFavorite = false;

            if (state is FavoriteStatusLoaded &&
                state.countryName == country.name) {
              isFavorite = state.isFavorite;
            }

            return FloatingActionButton(
              onPressed: () {
                context.read<FavoritesBloc>().add(ToggleFavoriteEvent(country));

                // Show snackbar feedback
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isFavorite
                          ? 'Removed from favorites'
                          : 'Added to favorites',
                    ),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              backgroundColor: isFavorite ? Colors.red : Colors.red.shade400,
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    List<Widget> cards,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        ...cards,
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeZonesSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time Zones',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.access_time,
                      color: Colors.indigo,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${country.timezones.length} Time Zone${country.timezones.length > 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...country.timezones.map(
                (timezone) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    timezone,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatPopulation(int population) {
    if (population >= 1000000000) {
      return '${(population / 1000000000).toStringAsFixed(1)}B';
    } else if (population >= 1000000) {
      return '${(population / 1000000).toStringAsFixed(1)}M';
    } else if (population >= 1000) {
      return '${(population / 1000).toStringAsFixed(1)}K';
    }
    return population.toString();
  }

  String _formatArea(double area) {
    if (area >= 1000000) {
      return '${(area / 1000000).toStringAsFixed(1)}M';
    } else if (area >= 1000) {
      return '${(area / 1000).toStringAsFixed(1)}K';
    }
    return area.toStringAsFixed(0);
  }

  Widget _buildDetailFlag(BuildContext context) {
    // Use real flag image with emoji fallback for details screen
    if (country.flagUrl.isNotEmpty) {
      return Image.network(
        country.flagUrl,
        width: 200,
        height: 140,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to emoji if image fails to load
          return _buildDetailEmojiFlag(context);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 200,
            height: 140,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else {
      // Fallback to emoji flag
      return _buildDetailEmojiFlag(context);
    }
  }

  Widget _buildDetailEmojiFlag(BuildContext context) {
    return Container(
      width: 200,
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.2),
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(country.flagEmoji, style: const TextStyle(fontSize: 80)),
      ),
    );
  }
}
