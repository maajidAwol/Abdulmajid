import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/injection/injection_container.dart' as di;
import '../screens/country_details_screen.dart';
import '../../../favorites/presentation/bloc/favorites_bloc.dart';
import '../../domain/entities/countries_entitiy.dart';

class CountryCard extends StatefulWidget {
  final CountryEntity country;
  final VoidCallback? onTap;

  const CountryCard({super.key, required this.country, this.onTap});

  @override
  State<CountryCard> createState() => _CountryCardState();
}

class _CountryCardState extends State<CountryCard> {
  late FavoritesBloc _favoritesBloc;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _favoritesBloc = di.sl<FavoritesBloc>();
    _checkFavoriteStatus();
  }

  @override
  void dispose() {
    _favoritesBloc.close();
    super.dispose();
  }

  void _checkFavoriteStatus() {
    _favoritesBloc.add(CheckFavoriteStatusEvent(widget.country.name));
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    _favoritesBloc.add(ToggleFavoriteEvent(widget.country));

    // Show snackbar feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite ? 'Added to favorites' : 'Removed from favorites',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _isFavorite ? Colors.green : Colors.grey[600],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoritesBloc, FavoritesState>(
      bloc: _favoritesBloc,
      listener: (context, state) {
        if (state is FavoriteStatusLoaded &&
            state.countryName == widget.country.name) {
          setState(() {
            _isFavorite = state.isFavorite;
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          child: InkWell(
            onTap:
                widget.onTap ??
                () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (_) => CountryDetailsScreen(country: widget.country),
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
                    tag: 'flag_${widget.country.name}',
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
                        child: _buildFlag(),
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
                          widget.country.name,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Population: ${_formatPopulation(widget.country.population)}',
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: _toggleFavorite,
                        child: Center(
                          child: Icon(
                            _isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                                _isFavorite
                                    ? const Color(0xFFE91E63)
                                    : const Color(0xFF9E9E9E),
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
      ),
    );
  }

  Widget _buildFlag() {
    // Create a gradient flag placeholder that looks more realistic
    return Container(
      width: 64,
      height: 44,
      decoration: BoxDecoration(
        gradient: _getFlagGradient(),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 0.5),
      ),
      child: Center(
        child: Text(
          widget.country.flag,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  LinearGradient _getFlagGradient() {
    // Create different gradients based on country name for variety
    final hash = widget.country.name.hashCode;
    final colors = [
      [const Color(0xFF4CAF50), const Color(0xFF81C784)], // Green
      [const Color(0xFF2196F3), const Color(0xFF64B5F6)], // Blue
      [const Color(0xFFF44336), const Color(0xFFE57373)], // Red
      [const Color(0xFFFF9800), const Color(0xFFFFB74D)], // Orange
      [const Color(0xFF9C27B0), const Color(0xFFBA68C8)], // Purple
      [const Color(0xFF607D8B), const Color(0xFF90A4AE)], // Blue Grey
    ];

    final colorPair = colors[hash.abs() % colors.length];
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colorPair,
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
}
