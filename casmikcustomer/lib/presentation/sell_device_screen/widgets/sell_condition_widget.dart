import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class SellConditionWidget extends StatefulWidget {
  final String deviceName;
  final double basePrice;
  final void Function(Map<String, int> answers, double finalPrice) onComplete;
  final void Function(double price) onPriceUpdate;

  const SellConditionWidget({
    required this.deviceName,
    required this.basePrice,
    required this.onComplete,
    required this.onPriceUpdate,
    super.key,
  });

  @override
  State<SellConditionWidget> createState() => _SellConditionWidgetState();
}

class _SellConditionWidgetState extends State<SellConditionWidget>
    with SingleTickerProviderStateMixin {
  // TODO: Replace with Riverpod/Bloc for production
  int _currentQuestion = 0;
  final Map<String, int> _answers = {};
  double _currentPrice = 0;
  double _lastAdjustment = 0;
  String _adjustmentReason = '';

  late AnimationController _priceAnimCtrl;
  late Animation<double> _priceAnim;

  final List<Map<String, dynamic>> _questions = [
    {
      'id': 'screen',
      'question': 'What is the screen condition?',
      'icon': 'screen',
      'options': [
        {
          'label': 'Flawless',
          'desc': 'No scratches or cracks',
          'adjustment': 0.05,
          'icon': 'check_circle',
          'color': Color(0xFF00C853),
        },
        {
          'label': 'Minor Scratches',
          'desc': 'Small scratches, no cracks',
          'adjustment': 0.0,
          'icon': 'star_outline',
          'color': Color(0xFF3B82F6),
        },
        {
          'label': 'Cracked',
          'desc': 'Visible cracks on screen',
          'adjustment': -0.15,
          'icon': 'close',
          'color': Color(0xFFEF4444),
        },
      ],
    },
    {
      'id': 'body',
      'question': 'How is the body/frame?',
      'icon': 'body',
      'options': [
        {
          'label': 'Like New',
          'desc': 'No dents or scratches',
          'adjustment': 0.03,
          'icon': 'check_circle',
          'color': Color(0xFF00C853),
        },
        {
          'label': 'Minor Dents',
          'desc': 'Small dents/scratches',
          'adjustment': -0.05,
          'icon': 'star_outline',
          'color': Color(0xFFF59E0B),
        },
        {
          'label': 'Damaged',
          'desc': 'Major dents or bends',
          'adjustment': -0.20,
          'icon': 'close',
          'color': Color(0xFFEF4444),
        },
      ],
    },
    {
      'id': 'battery',
      'question': 'What is the battery health?',
      'icon': 'battery',
      'options': [
        {
          'label': 'Above 90%',
          'desc': 'Excellent battery life',
          'adjustment': 0.05,
          'icon': 'check_circle',
          'color': Color(0xFF00C853),
        },
        {
          'label': '80% - 90%',
          'desc': 'Good battery life',
          'adjustment': 0.0,
          'icon': 'star_outline',
          'color': Color(0xFF3B82F6),
        },
        {
          'label': 'Below 80%',
          'desc': 'Battery needs replacement',
          'adjustment': -0.10,
          'icon': 'close',
          'color': Color(0xFFEF4444),
        },
      ],
    },
    {
      'id': 'accessories',
      'question': 'Accessories included?',
      'icon': 'accessories',
      'options': [
        {
          'label': 'All Included',
          'desc': 'Box, charger, earphones',
          'adjustment': 0.05,
          'icon': 'check_circle',
          'color': Color(0xFF00C853),
        },
        {
          'label': 'Charger Only',
          'desc': 'Only charger available',
          'adjustment': 0.0,
          'icon': 'star_outline',
          'color': Color(0xFF3B82F6),
        },
        {
          'label': 'None',
          'desc': 'No accessories',
          'adjustment': -0.05,
          'icon': 'close',
          'color': Color(0xFFEF4444),
        },
      ],
    },
    {
      'id': 'functional',
      'question': 'Any functional issues?',
      'icon': 'smartphone',
      'options': [
        {
          'label': 'Fully Functional',
          'desc': 'Everything works perfectly',
          'adjustment': 0.05,
          'icon': 'check_circle',
          'color': Color(0xFF00C853),
        },
        {
          'label': 'Minor Issues',
          'desc': 'Speaker/mic issues',
          'adjustment': -0.08,
          'icon': 'star_outline',
          'color': Color(0xFFF59E0B),
        },
        {
          'label': 'Major Issues',
          'desc': 'Camera, charging port broken',
          'adjustment': -0.20,
          'icon': 'close',
          'color': Color(0xFFEF4444),
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentPrice = widget.basePrice;
    _priceAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _priceAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _priceAnimCtrl, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _priceAnimCtrl.dispose();
    super.dispose();
  }

  void _onOptionSelected(int optionIndex) {
    final question = _questions[_currentQuestion];
    final option = question['options'][optionIndex];
    final adjustment = (option['adjustment'] as double) * widget.basePrice;
    final newPrice = (_currentPrice + adjustment).clamp(
      widget.basePrice * 0.3,
      widget.basePrice * 1.15,
    );

    setState(() {
      _answers[question['id'] as String] = optionIndex;
      _lastAdjustment = adjustment;
      _adjustmentReason = option['label'] as String;
      _currentPrice = newPrice;
    });

    widget.onPriceUpdate(_currentPrice);
    _priceAnimCtrl.reset();
    _priceAnimCtrl.forward();

    // Auto-advance after brief delay
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        if (_currentQuestion < _questions.length - 1) {
          setState(() => _currentQuestion++);
        } else {
          widget.onComplete(_answers, _currentPrice);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestion];
    final options = question['options'] as List<Map<String, dynamic>>;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Device name
          Text(
            widget.deviceName,
            style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 4),
          // Question
          Text(
            question['question'] as String,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          // Progress
          Text(
            'Question ${_currentQuestion + 1} of ${_questions.length}',
            style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 20),
          // Animated Price Bar
          _AnimatedPriceBar(
            currentPrice: _currentPrice,
            basePrice: widget.basePrice,
            lastAdjustment: _lastAdjustment,
            adjustmentReason: _adjustmentReason,
            animation: _priceAnim,
          ),
          const SizedBox(height: 24),
          // Options
          ...options.asMap().entries.map((entry) {
            final i = entry.key;
            final opt = entry.value;
            final isSelected = _answers[question['id']] == i;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ConditionOptionCard(
                label: opt['label'] as String,
                desc: opt['desc'] as String,
                iconName: opt['icon'] as String,
                color: opt['color'] as Color,
                adjustment: opt['adjustment'] as double,
                basePrice: widget.basePrice,
                isSelected: isSelected,
                onTap: () => _onOptionSelected(i),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _AnimatedPriceBar extends StatelessWidget {
  final double currentPrice;
  final double basePrice;
  final double lastAdjustment;
  final String adjustmentReason;
  final Animation<double> animation;

  const _AnimatedPriceBar({
    required this.currentPrice,
    required this.basePrice,
    required this.lastAdjustment,
    required this.adjustmentReason,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (currentPrice / basePrice).clamp(0.3, 1.15);
    final isPositive = lastAdjustment >= 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Current Quote',
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
              if (lastAdjustment != 0)
                AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: animation.value,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: isPositive
                              ? AppTheme.primary.withAlpha(31)
                              : AppTheme.error.withAlpha(31),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${isPositive ? '+' : ''}₹${lastAdjustment.abs().toStringAsFixed(0)} ($adjustmentReason)',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isPositive
                                ? AppTheme.primary
                                : AppTheme.error,
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: basePrice, end: currentPrice),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                builder: (context, val, _) {
                  return Text(
                    '₹${val.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primary,
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.5, end: percentage.toDouble()),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              builder: (context, val, _) {
                return LinearProgressIndicator(
                  value: val.clamp(0.0, 1.0),
                  backgroundColor: AppTheme.borderLight,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    val > 0.85
                        ? AppTheme.primary
                        : val > 0.6
                        ? AppTheme.warning
                        : AppTheme.error,
                  ),
                  minHeight: 8,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ConditionOptionCard extends StatelessWidget {
  final String label;
  final String desc;
  final String iconName;
  final Color color;
  final double adjustment;
  final double basePrice;
  final bool isSelected;
  final VoidCallback onTap;

  const _ConditionOptionCard({
    required this.label,
    required this.desc,
    required this.iconName,
    required this.color,
    required this.adjustment,
    required this.basePrice,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final adjValue = (adjustment * basePrice).round();
    final isPositive = adjustment >= 0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? color.withAlpha(20) : AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : AppTheme.borderLight,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 8,
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
                color: color.withAlpha(31),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: color,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? color : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (adjValue != 0)
              Text(
                '${isPositive ? '+' : ''}₹${adjValue.abs()}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isPositive ? AppTheme.primary : AppTheme.error,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
