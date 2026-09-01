import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../routes/app_routes.dart';

class SellQuoteWidget extends StatefulWidget {
  final String deviceName;
  final String category;
  final double finalPrice;
  final double basePrice;
  final Map<String, int> conditionAnswers;

  const SellQuoteWidget({
    required this.deviceName,
    required this.category,
    required this.finalPrice,
    required this.basePrice,
    required this.conditionAnswers,
    super.key,
  });

  @override
  State<SellQuoteWidget> createState() => _SellQuoteWidgetState();
}

class _SellQuoteWidgetState extends State<SellQuoteWidget>
    with SingleTickerProviderStateMixin {
  // TODO: Replace with Riverpod/Bloc for production
  int _hoursLeft = 23;
  int _minutesLeft = 59;
  int _secondsLeft = 47;
  Timer? _countdownTimer;

  late AnimationController _successAnimCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _successAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _successAnimCtrl, curve: Curves.elasticOut),
    );
    _successAnimCtrl.forward();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_secondsLeft > 0) {
            _secondsLeft--;
          } else if (_minutesLeft > 0) {
            _minutesLeft--;
            _secondsLeft = 59;
          } else if (_hoursLeft > 0) {
            _hoursLeft--;
            _minutesLeft = 59;
            _secondsLeft = 59;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _successAnimCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final discount = widget.basePrice - widget.finalPrice;
    final discountPct = ((discount / widget.basePrice) * 100)
        .abs()
        .toStringAsFixed(0);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      child: Column(
        children: [
          // Success animation
          ScaleTransition(
            scale: _scaleAnim,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.primary,
                  size: 44,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your Quote is Ready!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.deviceName,
            style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 24),
          // Price card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF00C853), Color(0xFF009624)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text(
                  'We\'ll pay you',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '₹${widget.finalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Direct bank transfer within 24 hours',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withAlpha(204),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Countdown timer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'timer',
                  color: AppTheme.warning,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quote valid for',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      Text(
                        '${_hoursLeft.toString().padLeft(2, '0')}:${_minutesLeft.toString().padLeft(2, '0')}:${_secondsLeft.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.warning,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Price breakdown
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Price Breakdown',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                _PriceRow(
                  label: 'Base Price',
                  value: '₹${widget.basePrice.toStringAsFixed(0)}',
                  isPositive: true,
                ),
                const SizedBox(height: 8),
                _PriceRow(
                  label: 'Condition Adjustment',
                  value:
                      '${discount > 0 ? '-' : '+'}₹${discount.abs().toStringAsFixed(0)}',
                  isPositive: discount <= 0,
                ),
                const Divider(height: 20),
                _PriceRow(
                  label: 'Your Quote',
                  value: '₹${widget.finalPrice.toStringAsFixed(0)}',
                  isPositive: true,
                  isBold: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // CTA
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Navigate to schedule pickup screen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Scheduling pickup... Order confirmed!',
                    ),
                    backgroundColor: AppTheme.primary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
                context.go(AppRoutes.myOrdersScreen);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Schedule Free Pickup',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Share Quote'),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isPositive;
  final bool isBold;

  const _PriceRow({
    required this.label,
    required this.value,
    required this.isPositive,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 15 : 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            color: isBold ? AppTheme.textPrimary : AppTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 15 : 13,
            fontWeight: FontWeight.w700,
            color: isBold
                ? AppTheme.primary
                : isPositive
                ? AppTheme.textPrimary
                : AppTheme.error,
          ),
        ),
      ],
    );
  }
}
