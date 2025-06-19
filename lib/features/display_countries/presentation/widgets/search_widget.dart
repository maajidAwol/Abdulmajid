import 'dart:async';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String hintText;

  const SearchWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hintText = 'Search for a country',
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  Timer? _debounceTimer;
  bool _hasFocus = false;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      widget.onChanged(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color:
            isDark
                ? colorScheme.surface
                : colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _hasFocus ? colorScheme.primary : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() {
            _hasFocus = hasFocus;
          });
        },
        child: TextField(
          controller: widget.controller,
          onChanged: _onSearchChanged,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.6),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16, right: 12),
              child: Icon(
                Icons.search,
                color:
                    _hasFocus
                        ? colorScheme.primary
                        : colorScheme.onSurface.withOpacity(0.6),
                size: 20,
              ),
            ),
            suffixIcon:
                widget.controller.text.isNotEmpty
                    ? Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () {
                          widget.controller.clear();
                          widget.onChanged('');
                          setState(() {});
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: colorScheme.onSurface.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: colorScheme.surface,
                            size: 14,
                          ),
                        ),
                      ),
                    )
                    : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 48,
              minHeight: 48,
            ),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 48,
              minHeight: 48,
            ),
          ),
        ),
      ),
    );
  }
}
