import 'package:flutter/material.dart';

class SellPickupStep extends StatelessWidget {
  final String selectedDate;
  final String selectedSlot;
  final TextEditingController addressController;
  final TextEditingController upiController;
  final Function(String date) onDateChanged;
  final Function(String slot) onSlotChanged;
  final VoidCallback onConfirmOrder;

  const SellPickupStep({
    super.key,
    required this.selectedDate,
    required this.selectedSlot,
    required this.addressController,
    required this.upiController,
    required this.onDateChanged,
    required this.onSlotChanged,
    required this.onConfirmOrder,
  });

  @override
  Widget build(BuildContext context) {
    final dates = ['Today', 'Tomorrow', 'Day After Tomorrow'];
    final slots = [
      '9:00 AM – 11:00 AM',
      '11:00 AM – 1:00 PM',
      '1:00 PM – 3:00 PM',
      '3:00 PM – 5:00 PM',
      '5:00 PM – 7:00 PM',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pickup Date:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: dates.map((d) {
              final isSel = selectedDate == d;
              return ChoiceChip(
                label: Text(d),
                selected: isSel,
                onSelected: (v) => onDateChanged(d),
                selectedColor: const Color(0xFF059669),
                labelStyle: TextStyle(color: isSel ? Colors.white : const Color(0xFF0F172A), fontSize: 11, fontWeight: FontWeight.bold),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Preferred Time Slot:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: slots.map((s) {
              final isSel = selectedSlot == s;
              return ChoiceChip(
                label: Text(s),
                selected: isSel,
                onSelected: (v) => onSlotChanged(s),
                selectedColor: const Color(0xFF059669),
                labelStyle: TextStyle(color: isSel ? Colors.white : const Color(0xFF0F172A), fontSize: 11, fontWeight: FontWeight.bold),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text('Pickup Address:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          TextField(
            controller: addressController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Enter complete flat, street and pincode',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Payment UPI ID:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          TextField(
            controller: upiController,
            decoration: InputDecoration(
              hintText: 'e.g. mobile@upi or gpay',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
              ),
              onPressed: onConfirmOrder,
              child: const Text('Confirm Doorstep Pickup Booking', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}
