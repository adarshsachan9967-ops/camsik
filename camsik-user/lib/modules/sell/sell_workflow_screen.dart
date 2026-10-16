import 'package:flutter/material.dart';
import '../../models/user_order.dart';
import '../../models/user_profile.dart';
import '../../core/services/api_service.dart';
import 'steps/sell_category_step.dart';
import 'steps/sell_model_step.dart';
import 'steps/sell_pickup_step.dart';
import 'steps/sell_questions_step.dart';
import 'steps/sell_summary_step.dart';
import 'steps/sell_variant_step.dart';

class SellWorkflowWidget extends StatefulWidget {
  final List<Map<String, dynamic>> categories;
  final String? preselectedCategory;
  final UserProfile userProfile;
  final Function(UserProfile) onProfileUpdate;
  final Function(UserOrder) onOrderCreated;

  const SellWorkflowWidget({
    super.key,
    required this.categories,
    this.preselectedCategory,
    required this.userProfile,
    required this.onProfileUpdate,
    required this.onOrderCreated,
  });

  @override
  State<SellWorkflowWidget> createState() => _SellWorkflowWidgetState();
}

class _SellWorkflowWidgetState extends State<SellWorkflowWidget> {
  int _step = 0; // 0: Category, 1: Brand/Model, 2: Variant, 3: Questions, 4: Summary, 5: Pickup Slot
  late Map<String, dynamic> _selectedCategory;
  List<Map<String, dynamic>> _models = [];
  Map<String, dynamic>? _selectedModel;
  String _selectedStorage = 'Body Only';
  String _selectedColor = 'Black';
  List<Map<String, dynamic>> _selectedLenses = [];

  // Dynamic Questions from backend
  List<Map<String, dynamic>> _questions = [];
  final Map<int, int> _selectedAnswers = {}; // questionIndex -> optionIndex

  int _basePrice = 58000;
  int _calculatedPrice = 58000;

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _upiController = TextEditingController();
  String _selectedSlot = '11:00 AM – 1:00 PM';
  String _selectedDate = 'Tomorrow';

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.categories.firstWhere(
      (c) => c['id'] == widget.preselectedCategory,
      orElse: () => widget.categories.isNotEmpty ? widget.categories.first : {'id': 'cat-dslr', 'name': 'DSLR & Mirrorless'},
    );
    _addressController.text = widget.userProfile.address;
    _upiController.text = widget.userProfile.upiId;
    _loadModelsForCategory(_selectedCategory['id'] as String);
  }

  @override
  void dispose() {
    _addressController.dispose();
    _upiController.dispose();
    super.dispose();
  }

  void _loadModelsForCategory(String catId) {
    // Static sync fallback data commented out as requested - live API models & questions loaded directly
    /*
    final syncModels = ApiService.getFallbackModelsSync(categoryId: catId);
    final syncQuestions = ApiService.getQuestionsSync(categoryId: catId);
    */
    setState(() {
      _models = [];
      _questions = [];
      _selectedAnswers.clear();
    });
    _recalculatePrice();

    ApiService.fetchModels(categoryId: catId).then((models) {
      if (mounted && models.isNotEmpty) {
        setState(() => _models = models);
      }
    });
    ApiService.fetchQuestions(categoryId: catId).then((questions) {
      if (mounted && questions.isNotEmpty) {
        setState(() {
          _questions = questions;
          _selectedAnswers.clear();
          for (int i = 0; i < _questions.length; i++) {
            _selectedAnswers[i] = 0;
          }
        });
        _recalculatePrice();
      }
    });
  }

  void _recalculatePrice() {
    int price = _basePrice;
    for (int qIdx = 0; qIdx < _questions.length; qIdx++) {
      final optIdx = _selectedAnswers[qIdx] ?? 0;
      final options = _questions[qIdx]['options'] as List?;
      if (options != null && optIdx < options.length) {
        final adj = (options[optIdx]['adj'] as num?)?.toInt() ?? 0;
        price += adj;
      }
    }
    final lensBonus = _selectedLenses.fold<int>(
      0,
      (sum, l) => sum + ((l['price'] as num?)?.toInt() ?? 0),
    );
    price += lensBonus;
    setState(() {
      _calculatedPrice = price > 3000 ? price : 3000;
    });
  }

  void _handleConfirmSellOrder() async {
    final lensSummary = _selectedLenses.isNotEmpty
        ? ' + ${_selectedLenses.length} Lens (${_selectedLenses.map((l) => l['name']).join(', ')})'
        : '';
    final orderData = {
      'type': 'sell',
      'customerName': widget.userProfile.name,
      'customerPhone': widget.userProfile.phone,
      'customerAddress': _addressController.text.trim(),
      'pickupDate': _selectedDate,
      'pickupSlot': _selectedSlot,
      'paymentMethod': 'Instant UPI (${_upiController.text.trim()})',
      'amount': _calculatedPrice,
      'deviceName': '${_selectedModel?['name'] ?? 'Device'} ($_selectedStorage)$lensSummary',
      'status': 'Order Placed',
    };

    final created = await ApiService.createOrder(orderData);
    if (created != null && mounted) {
      final userOrder = UserOrder.fromJson(created);
      widget.onOrderCreated(userOrder);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: _step > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                onPressed: () => setState(() => _step--),
              )
            : null,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getStepTitle(),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
            ),
            Text(
              _step > 0
                  ? '${_selectedCategory['name']}${_selectedModel != null ? ' > ${_selectedModel!['name']}' : ''}'
                  : 'Instant AI Valuation • Free Doorstep Pickup',
              style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: Row(
              children: List.generate(6, (idx) {
                final isPassedOrCurrent = idx <= _step;
                return Expanded(
                  child: Container(
                    height: 3.5,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: isPassedOrCurrent ? const Color(0xFF059669) : const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
      body: _buildStepContent(),
    );
  }

  String _getStepTitle() {
    switch (_step) {
      case 0:
        return 'Step 1 of 6: Select Category';
      case 1:
        return 'Step 2 of 6: Select Device Model';
      case 2:
        return 'Step 3 of 6: Storage & Variant';
      case 3:
        return 'Step 4 of 6: Device Condition';
      case 4:
        return 'Step 5 of 6: Valuation Summary';
      case 5:
        return 'Step 6 of 6: Schedule Pickup';
      default:
        return 'Sell Device';
    }
  }

  Widget _buildStepContent() {
    switch (_step) {
      case 0:
        return SellCategoryStep(
          categories: widget.categories,
          onSelectCategory: (cat) {
            setState(() {
              _selectedCategory = cat;
              _step = 1;
            });
            _loadModelsForCategory(cat['id'] as String);
          },
        );
      case 1:
        return SellModelStep(
          models: _models,
          onSelectModel: (m) {
            setState(() {
              _selectedModel = m;
              _basePrice = (m['basePrice'] as num?)?.toInt() ?? 50000;
              final storages = m['storages'] as List?;
              if (storages != null && storages.isNotEmpty) {
                _selectedStorage = storages.first as String;
              }
              final colors = m['colors'] as List?;
              if (colors != null && colors.isNotEmpty) {
                _selectedColor = colors.first as String;
              }
              _step = 2;
            });
            _recalculatePrice();
          },
        );
      case 2:
        return SellVariantStep(
          selectedModel: _selectedModel,
          categoryId: _selectedCategory['id'] as String?,
          basePrice: _basePrice,
          selectedStorage: _selectedStorage,
          selectedColor: _selectedColor,
          selectedLenses: _selectedLenses,
          onStorageChanged: (s) => setState(() => _selectedStorage = s),
          onColorChanged: (c) => setState(() => _selectedColor = c),
          onLensesChanged: (lenses) {
            setState(() => _selectedLenses = lenses);
            _recalculatePrice();
          },
          onProceed: () => setState(() => _step = 3),
        );
      case 3:
        return SellQuestionsStep(
          selectedModel: _selectedModel,
          selectedStorage: _selectedStorage,
          selectedColor: _selectedColor,
          basePrice: _basePrice,
          calculatedPrice: _calculatedPrice,
          questions: _questions,
          selectedAnswers: _selectedAnswers,
          onAnswerSelected: (qIdx, optIdx) {
            setState(() {
              _selectedAnswers[qIdx] = optIdx;
            });
            _recalculatePrice();
          },
          onProceed: () => setState(() => _step = 4),
        );
      case 4:
        return SellSummaryStep(
          selectedModel: _selectedModel,
          selectedStorage: _selectedStorage,
          selectedColor: _selectedColor,
          selectedLenses: _selectedLenses,
          basePrice: _basePrice,
          calculatedPrice: _calculatedPrice,
          questions: _questions,
          selectedAnswers: _selectedAnswers,
          onProceed: () => setState(() => _step = 5),
        );
      case 5:
        return SellPickupStep(
          selectedModel: _selectedModel,
          selectedStorage: _selectedStorage,
          selectedColor: _selectedColor,
          calculatedPrice: _calculatedPrice,
          userProfile: widget.userProfile,
          selectedDate: _selectedDate,
          selectedSlot: _selectedSlot,
          addressController: _addressController,
          upiController: _upiController,
          onDateChanged: (d) => setState(() => _selectedDate = d),
          onSlotChanged: (s) => setState(() => _selectedSlot = s),
          onConfirmOrder: _handleConfirmSellOrder,
          onProfileUpdate: widget.onProfileUpdate,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
