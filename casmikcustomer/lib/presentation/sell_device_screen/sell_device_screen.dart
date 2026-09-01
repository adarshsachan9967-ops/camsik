import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/sell_brand_widget.dart';
import './widgets/sell_category_widget.dart';
import './widgets/sell_condition_widget.dart';
import './widgets/sell_model_widget.dart';
import './widgets/sell_quote_widget.dart';
import './widgets/sell_step_indicator_widget.dart';

enum SellStep { category, brand, model, condition, quote }

class SellDeviceScreen extends StatefulWidget {
  const SellDeviceScreen({super.key});

  @override
  State<SellDeviceScreen> createState() => _SellDeviceScreenState();
}

class _SellDeviceScreenState extends State<SellDeviceScreen>
    with SingleTickerProviderStateMixin {
  // TODO: Replace with Riverpod/Bloc for production
  SellStep _currentStep = SellStep.category;
  String? _selectedCategory;
  String? _selectedBrand;
  Map<String, dynamic>? _selectedModel;
  Map<String, int> _conditionAnswers = {};
  double _basePrice = 0;
  double _currentPrice = 0;

  late AnimationController _stepAnimController;
  late Animation<Offset> _slideIn;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _stepAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideIn = Tween<Offset>(begin: const Offset(0.06, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _stepAnimController,
            curve: Curves.easeOutCubic,
          ),
        );
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _stepAnimController, curve: Curves.easeOutCubic),
    );
    _stepAnimController.forward();
  }

  @override
  void dispose() {
    _stepAnimController.dispose();
    super.dispose();
  }

  void _goToStep(SellStep step) {
    setState(() => _currentStep = step);
    _stepAnimController.reset();
    _stepAnimController.forward();
  }

  void _onCategorySelected(String category) {
    setState(() => _selectedCategory = category);
    _goToStep(SellStep.brand);
  }

  void _onBrandSelected(String brand) {
    setState(() => _selectedBrand = brand);
    _goToStep(SellStep.model);
  }

  void _onModelSelected(Map<String, dynamic> model) {
    setState(() {
      _selectedModel = model;
      _basePrice = (model['basePrice'] as num).toDouble();
      _currentPrice = _basePrice;
    });
    _goToStep(SellStep.condition);
  }

  void _onConditionComplete(Map<String, int> answers, double finalPrice) {
    setState(() {
      _conditionAnswers = answers;
      _currentPrice = finalPrice;
    });
    _goToStep(SellStep.quote);
  }

  void _onPriceUpdate(double price) {
    setState(() => _currentPrice = price);
  }

  void _goBack() {
    switch (_currentStep) {
      case SellStep.category:
        break;
      case SellStep.brand:
        _goToStep(SellStep.category);
        break;
      case SellStep.model:
        _goToStep(SellStep.brand);
        break;
      case SellStep.condition:
        _goToStep(SellStep.model);
        break;
      case SellStep.quote:
        _goToStep(SellStep.condition);
        break;
    }
  }

  int get _stepIndex => SellStep.values.indexOf(_currentStep);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // App bar
            _buildAppBar(context),
            // Step indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SellStepIndicatorWidget(
                currentStep: _stepIndex,
                totalSteps: SellStep.values.length,
                labels: const [
                  'Category',
                  'Brand',
                  'Model',
                  'Condition',
                  'Quote',
                ],
              ),
            ),
            // Step content
            Expanded(
              child: FadeTransition(
                opacity: _fadeIn,
                child: SlideTransition(
                  position: _slideIn,
                  child: _buildCurrentStep(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final stepTitles = [
      'Select Category',
      'Select Brand',
      'Select Model',
      'Device Condition',
      'Your Quote',
    ];
    return Container(
      color: AppTheme.surfaceLight,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          if (_currentStep != SellStep.category)
            InkWell(
              onTap: _goBack,
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.borderLight),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'arrow_back',
                    color: AppTheme.textPrimary,
                    size: 18,
                  ),
                ),
              ),
            )
          else
            const SizedBox(width: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              stepTitles[_stepIndex],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          // Live price pill
          if (_currentStep == SellStep.condition ||
              _currentStep == SellStep.quote)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.primary.withAlpha(77)),
              ),
              child: Text(
                '₹${_currentPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case SellStep.category:
        return SellCategoryWidget(onSelected: _onCategorySelected);
      case SellStep.brand:
        return SellBrandWidget(
          category: _selectedCategory ?? '',
          onSelected: _onBrandSelected,
        );
      case SellStep.model:
        return SellModelWidget(
          brand: _selectedBrand ?? '',
          onSelected: _onModelSelected,
        );
      case SellStep.condition:
        return SellConditionWidget(
          deviceName:
              '${_selectedBrand ?? ''} ${_selectedModel?['name'] ?? ''}',
          basePrice: _basePrice,
          onComplete: _onConditionComplete,
          onPriceUpdate: _onPriceUpdate,
        );
      case SellStep.quote:
        return SellQuoteWidget(
          deviceName:
              '${_selectedBrand ?? ''} ${_selectedModel?['name'] ?? ''}',
          category: _selectedCategory ?? '',
          finalPrice: _currentPrice,
          basePrice: _basePrice,
          conditionAnswers: _conditionAnswers,
        );
    }
  }
}
