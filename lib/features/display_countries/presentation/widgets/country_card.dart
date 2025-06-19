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
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  void _checkFavoriteStatus() {
    context.read<FavoritesBloc>().add(
      CheckFavoriteStatusEvent(widget.country.name),
    );
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    context.read<FavoritesBloc>().add(ToggleFavoriteEvent(widget.country));

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
          color: Theme.of(context).cardTheme.color,
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
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).textTheme.titleLarge?.color,
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
    // Use real flag image with emoji fallback
    if (widget.country.flagUrl.isNotEmpty) {
      return Image.network(
        widget.country.flagUrl,
        width: 64,
        height: 44,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to emoji if image fails to load
          return _buildEmojiFlag();
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
      return _buildEmojiFlag();
    }
  }

  Widget _buildEmojiFlag() {
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
          widget.country.flagEmoji,
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
