import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/currency_formatter.dart';

class ExchangeCheckoutStep extends StatelessWidget {
  final int adjustedPrice;
  final String selectedCondition;
  final int calculatedOldValue;
  final int exchangeBonus;
  final String? appliedCouponCode;
  final int couponDiscount;
  final TextEditingController couponController;
  final ValueChanged<String> onApplyCoupon;
  final String selectedDate;
  final String selectedSlot;
  final ValueChanged<String> onDateSelected;
  final ValueChanged<String> onSlotSelected;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController pincodeController;
  final bool isPlacingOrder;
  final VoidCallback onConfirmExchange;

  const ExchangeCheckoutStep({
    super.key,
    required this.adjustedPrice,
    required this.selectedCondition,
    required this.calculatedOldValue,
    required this.exchangeBonus,
    required this.appliedCouponCode,
    required this.couponDiscount,
    required this.couponController,
    required this.onApplyCoupon,
    required this.selectedDate,
    required this.selectedSlot,
    required this.onDateSelected,
    required this.onSlotSelected,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.cityController,
    required this.pincodeController,
    required this.isPlacingOrder,
    required this.onConfirmExchange,
  });

  @override
  Widget build(BuildContext context) {
    final totalTradeIn = calculatedOldValue + exchangeBonus;
    final netDiff = adjustedPrice - totalTradeIn - couponDiscount;
    final netPayable = netDiff > 0 ? netDiff : 0;
    final cashback = netDiff < 0 ? netDiff.abs() : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exchange Overview Cards
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                _buildSummaryLine(
                  'Upgraded Device ($selectedCondition)',
                  formatCurrency(adjustedPrice),
                ),
                _buildSummaryLine(
                  'Old Device Trade-In Valuation',
                  formatCurrency(calculatedOldValue),
                ),
                _buildSummaryLine(
                  'Guaranteed Camsik Exchange Bonus',
                  '+$kRupee 5,000',
                  isBonus: true,
                ),
                if (couponDiscount > 0)
                  _buildSummaryLine(
                    'Coupon ($appliedCouponCode)',
                    '-${formatCurrency(couponDiscount)}',
                    isBonus: true,
                  ),
                const Divider(height: 16),
                _buildSummaryLine(
                  cashback > 0
                      ? 'Cashback Paid to You on Handover'
                      : 'Net Doorstep Payable Balance',
                  cashback > 0
                      ? '+$kRupee${formatCurrency(cashback)}'
                      : formatCurrency(netPayable),
                  isBold: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Coupon Code Section
          const Text(
            'Apply Upgrade Coupon:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: couponController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: 'Enter coupon code',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF059669),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                ),
                onPressed: () => onApplyCoupon(couponController.text),
                child: const Text('Apply',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ActionChip(
                  label: const Text('CAMSIK500 (-$kRupee 500)'),
                  onPressed: () {
                    couponController.text = 'CAMSIK500';
                    onApplyCoupon('CAMSIK500');
                  },
                ),
                const SizedBox(width: 6),
                ActionChip(
                  label: const Text('UPGRADE1000 (-$kRupee 1,000)'),
                  onPressed: () {
                    couponController.text = 'UPGRADE1000';
                    onApplyCoupon('UPGRADE1000');
                  },
                ),
                const SizedBox(width: 6),
                ActionChip(
                  label: const Text('FESTIVE1500 (-$kRupee 1,500)'),
                  onPressed: () {
                    couponController.text = 'FESTIVE1500';
                    onApplyCoupon('FESTIVE1500');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Doorstep Handover Slot
          const Text(
            'Select Handover Date & Time Slot:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Row(
            children: ['Tomorrow', 'Day After'].map((d) {
              final isSel = selectedDate == d;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(d),
                  selected: isSel,
                  onSelected: (v) => onDateSelected(d),
                  selectedColor: const Color(0xFF7C3AED),
                  labelStyle: TextStyle(
                    color: isSel ? Colors.white : const Color(0xFF0F172A),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              '10:00 AM – 1:00 PM',
              '2:00 PM – 5:00 PM',
              '5:00 PM – 8:00 PM',
            ].map((s) {
              final isSel = selectedSlot == s;
              return ChoiceChip(
                label: Text(s),
                selected: isSel,
                onSelected: (v) => onSlotSelected(s),
                selectedColor: const Color(0xFF7C3AED),
                labelStyle: TextStyle(
                  color: isSel ? Colors.white : const Color(0xFF0F172A),
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Handover Address Form
          const Text(
            'Doorstep Handover Details:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Mobile Phone',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: addressController,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Delivery & Handover Address',
              hintText: 'Flat, Wing, Building, Road name',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: cityController,
                  decoration: InputDecoration(
                    labelText: 'City',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: pincodeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Pincode',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Payment Preference
          const Text(
            'Payment Settlement Preference:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                const Icon(Icons.handshake, color: Color(0xFF059669)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    cashback > 0
                        ? 'Technician pays cash / UPI to you on doorstep'
                        : 'Pay balance to technician at doorstep via Cash / UPI',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Confirm Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
              onPressed: isPlacingOrder ? null : onConfirmExchange,
              child: isPlacingOrder
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      'Confirm 1-Step Doorstep Swap Booking',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryLine(String label, String value,
      {bool isBonus = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: const Color(0xFF475569),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 14 : 12,
              fontWeight: isBold ? FontWeight.w900 : FontWeight.bold,
              color: isBonus
                  ? const Color(0xFF059669)
                  : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
