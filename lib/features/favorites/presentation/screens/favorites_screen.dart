import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/injection/injection_container.dart' as di;
import '../../../display_countries/presentation/screens/country_details_screen.dart';
import '../bloc/favorites_bloc.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<FavoritesBloc>()..add(GetFavoritesEvent()),
      child: const FavoritesView(),
    );
  }
}

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              color: Theme.of(context).appBarTheme.backgroundColor,
              child: Column(
                children: [
                  // Title
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Favorites',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                            height: 1.2,
                          ),
                        ),
                        const Spacer(),
                        BlocBuilder<FavoritesBloc, FavoritesState>(
                          builder: (context, state) {
                            if (state is FavoritesLoaded) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFE91E63,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${state.favorites.length}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFE91E63),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
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
                          Colors.black.withOpacity(0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Favorites List
            Expanded(
              child: BlocConsumer<FavoritesBloc, FavoritesState>(
                listener: (context, state) {
                  if (state is FavoriteStatusLoaded) {
                    // Reload favorites when a favorite status changes
                    context.read<FavoritesBloc>().add(GetFavoritesEvent());
                  }
                },
                buildWhen: (previous, current) {
                  // Only rebuild for states that affect the UI list
                  return current is FavoritesLoading ||
                      current is FavoritesLoaded ||
                      current is FavoritesError ||
                      current is FavoritesInitial;
                },
                builder: (context, state) {
                  if (state is FavoritesLoading || state is FavoritesInitial) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFFE91E63),
                        ),
                      ),
                    );
                  } else if (state is FavoritesLoaded) {
                    if (state.favorites.isEmpty) {
                      return _buildEmptyState();
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<FavoritesBloc>().add(GetFavoritesEvent());
                      },
                      color: const Color(0xFFE91E63),
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                        itemCount: state.favorites.length,
                        itemBuilder: (context, index) {
                          final favorite = state.favorites[index];
                          return _buildFavoriteCard(context, favorite);
                        },
                      ),
                    );
                  } else if (state is FavoritesError) {
                    return _buildErrorState(context, state.message);
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

  Widget _buildFavoriteCard(BuildContext context, favorite) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CountryDetailsScreen(country: favorite.country),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Flag Container
                Hero(
                  tag: 'flag_${favorite.country.name}',
                  child: Container(
                    width: 64,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _buildFlag(favorite.country),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Country Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        favorite.country.name,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.titleLarge?.color,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Capital: ${_getCapitalCity(favorite.country.name)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF666666),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),

                // Favorite Heart Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        _showRemoveDialog(context, favorite);
                      },
                      child: const Center(
                        child: Icon(
                          Icons.favorite,
                          color: Color(0xFFE91E63),
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlag(country) {
    // Use real flag image with emoji fallback
    if (country.flagUrl.isNotEmpty) {
      return Image.network(
        country.flagUrl,
        width: 64,
        height: 44,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to emoji if image fails to load
          return _buildEmojiFlag(country);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 64,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
                ),
              ),
            ),
          );
        },
      );
    } else {
      // Fallback to emoji flag
      return _buildEmojiFlag(country);
    }
  }

  Widget _buildEmojiFlag(country) {
    // Create a gradient flag placeholder that looks more realistic
    final hash = country.name.hashCode;
    final colors = [
      [const Color(0xFF4CAF50), const Color(0xFF81C784)], // Green
      [const Color(0xFF2196F3), const Color(0xFF64B5F6)], // Blue
      [const Color(0xFFF44336), const Color(0xFFE57373)], // Red
      [const Color(0xFFFF9800), const Color(0xFFFFB74D)], // Orange
      [const Color(0xFF9C27B0), const Color(0xFFBA68C8)], // Purple
      [const Color(0xFF607D8B), const Color(0xFF90A4AE)], // Blue Grey
    ];

    final colorPair = colors[hash.abs() % colors.length];

    return Container(
      width: 64,
      height: 44,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colorPair,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 0.5),
      ),
      child: Center(
        child: Text(
          country.flagEmoji,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  String _getCapitalCity(String countryName) {
    // Map of countries to their capitals
    final capitals = {
      'France': 'Paris',
      'Japan': 'Tokyo',
      'Germany': 'Berlin',
      'Italy': 'Rome',
      'Spain': 'Madrid',
      'United Kingdom': 'London',
      'United States': 'Washington, D.C.',
      'Canada': 'Ottawa',
      'Brazil': 'Brasília',
      'India': 'New Delhi',
      'China': 'Beijing',
      'Australia': 'Canberra',
      'Russia': 'Moscow',
      'Mexico': 'Mexico City',
      'Argentina': 'Buenos Aires',
      'South Africa': 'Cape Town',
      'Egypt': 'Cairo',
      'Nigeria': 'Abuja',
      'Kenya': 'Nairobi',
      'Thailand': 'Bangkok',
      'South Korea': 'Seoul',
      'Indonesia': 'Jakarta',
      'Turkey': 'Ankara',
      'Greece': 'Athens',
      'Portugal': 'Lisbon',
      'Netherlands': 'Amsterdam',
      'Belgium': 'Brussels',
      'Switzerland': 'Bern',
      'Austria': 'Vienna',
      'Poland': 'Warsaw',
      'Czech Republic': 'Prague',
      'Hungary': 'Budapest',
      'Romania': 'Bucharest',
      'Bulgaria': 'Sofia',
      'Croatia': 'Zagreb',
      'Serbia': 'Belgrade',
      'Ukraine': 'Kyiv',
      'Norway': 'Oslo',
      'Sweden': 'Stockholm',
      'Denmark': 'Copenhagen',
      'Finland': 'Helsinki',
      'Iceland': 'Reykjavik',
      'Ireland': 'Dublin',
      'New Zealand': 'Wellington',
      'Chile': 'Santiago',
      'Peru': 'Lima',
      'Colombia': 'Bogotá',
      'Venezuela': 'Caracas',
      'Ecuador': 'Quito',
      'Bolivia': 'Sucre',
      'Paraguay': 'Asunción',
      'Uruguay': 'Montevideo',
      'Morocco': 'Rabat',
      'Algeria': 'Algiers',
      'Tunisia': 'Tunis',
      'Libya': 'Tripoli',
      'Sudan': 'Khartoum',
      'Ethiopia': 'Addis Ababa',
      'Ghana': 'Accra',
      'Ivory Coast': 'Yamoussoukro',
      'Senegal': 'Dakar',
      'Mali': 'Bamako',
      'Burkina Faso': 'Ouagadougou',
      'Niger': 'Niamey',
      'Chad': 'N\'Djamena',
      'Cameroon': 'Yaoundé',
      'Central African Republic': 'Bangui',
      'Democratic Republic of the Congo': 'Kinshasa',
      'Republic of the Congo': 'Brazzaville',
      'Gabon': 'Libreville',
      'Equatorial Guinea': 'Malabo',
      'São Tomé and Príncipe': 'São Tomé',
      'Angola': 'Luanda',
      'Zambia': 'Lusaka',
      'Zimbabwe': 'Harare',
      'Botswana': 'Gaborone',
      'Namibia': 'Windhoek',
      'Lesotho': 'Maseru',
      'Eswatini': 'Mbabane',
      'Mozambique': 'Maputo',
      'Madagascar': 'Antananarivo',
      'Mauritius': 'Port Louis',
      'Seychelles': 'Victoria',
      'Comoros': 'Moroni',
      'Djibouti': 'Djibouti',
      'Eritrea': 'Asmara',
      'Somalia': 'Mogadishu',
      'Uganda': 'Kampala',
      'Tanzania': 'Dodoma',
      'Rwanda': 'Kigali',
      'Burundi': 'Gitega',
      'Malawi': 'Lilongwe',
    };

    return capitals[countryName] ?? 'Unknown';
  }

  Widget _buildEmptyState() {
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
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.favorite_border,
                size: 40,
                color: Color(0xFF9E9E9E),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Favorites Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Start exploring countries and add\nthem to your favorites!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
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
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.error_outline,
                size: 40,
                color: Color(0xFFE53935),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF666666),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                context.read<FavoritesBloc>().add(GetFavoritesEvent());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63),
                foregroundColor: Colors.white,
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

  void _showRemoveDialog(BuildContext context, favorite) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Remove from Favorites',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          content: Text(
            'Are you sure you want to remove ${favorite.country.name} from your favorites?',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF666666),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF666666),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<FavoritesBloc>().add(
                  ToggleFavoriteEvent(favorite.country),
                );

                // Show feedback
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${favorite.country.name} removed from favorites',
                    ),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.grey[600],
                  ),
                );
              },
              child: const Text(
                'Remove',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE91E63),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
