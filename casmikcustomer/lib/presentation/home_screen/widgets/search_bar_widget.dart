import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class HomeSearchBarWidget extends StatefulWidget {
  const HomeSearchBarWidget({super.key});

  @override
  State<HomeSearchBarWidget> createState() => _HomeSearchBarWidgetState();
}

class _HomeSearchBarWidgetState extends State<HomeSearchBarWidget> {
  // TODO: Replace with Riverpod/Bloc for production
  final TextEditingController _controller = TextEditingController();
  bool _showSuggestions = false;

  final List<String> _suggestions = [
    'iPhone 15 Pro Max',
    'iPhone 14',
    'Samsung Galaxy S24',
    'OnePlus 12',
    'Redmi Note 13 Pro',
    'Realme GT 5',
    'Google Pixel 8',
    'Vivo V29 Pro',
    'OPPO Reno 11',
    'Motorola Edge 40',
  ];

  List<String> _filtered = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String val) {
    setState(() {
      if (val.isEmpty) {
        _showSuggestions = false;
        _filtered = [];
      } else {
        _filtered = _suggestions
            .where((s) => s.toLowerCase().contains(val.toLowerCase()))
            .toList();
        _showSuggestions = _filtered.isNotEmpty;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderLight),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _controller,
            onChanged: _onChanged,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppTheme.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'Search devices, brands, models...',
              hintStyle: TextStyle(fontSize: 14, color: AppTheme.textMuted),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12),
                child: CustomIconWidget(
                  iconName: 'search',
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
        if (_showSuggestions)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderLight),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: AppTheme.borderLight),
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    _controller.text = _filtered[i];
                    setState(() => _showSuggestions = false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'search',
                          color: AppTheme.textMuted,
                          size: 16,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _filtered[i],
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
