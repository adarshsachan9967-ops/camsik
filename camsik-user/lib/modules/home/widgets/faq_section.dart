import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class CamsikFaqSectionWidget extends StatefulWidget {
  const CamsikFaqSectionWidget({super.key});

  @override
  State<CamsikFaqSectionWidget> createState() => _CamsikFaqSectionWidgetState();
}

class _CamsikFaqSectionWidgetState extends State<CamsikFaqSectionWidget> {
  String _selectedCategory = 'All Questions';

  final List<String> _categories = [
    'All Questions',
    'Selling & Valuation',
    'Buying Refurbished',
    'Exchange & Upgrade',
    'Doorstep & Privacy',
  ];

  final List<Map<String, String>> _allFaqs = [
    {
      'id': 'faq-1',
      'category': 'Selling & Valuation',
      'badge': 'AI Valuation Engine',
      'q': 'How is the resale price of my phone, laptop, or camera calculated on Camsik?',
      'a': 'Our proprietary pricing algorithm analyzes live secondary market demand across India, processor/sensor generation, physical cosmetics, battery cycle health, display condition (OLED burn-in, scratches), camera sensor health, and included original accessories to calculate the highest guaranteed payout.',
    },
    {
      'id': 'faq-2',
      'category': 'Selling & Valuation',
      'badge': 'KYC & Paperwork',
      'q': 'Do I need the original box and bill to sell my device on Camsik?',
      'a': 'No! An original bill and retail packaging are not mandatory. Having them adds a small value bonus, but you can sell your smartphone, MacBook, tablet, or camera with just a valid government photo ID (Aadhaar Card, Driving License, or Passport) for legal KYC compliance.',
    },
    {
      'id': 'faq-3',
      'category': 'Buying Refurbished',
      'badge': '45-Point Inspection',
      'q': 'What quality checks do certified refurbished devices go through?',
      'a': 'Every device undergoes a 45-point hardware inspection conducted by certified diagnostic technicians. We test touchscreen responsiveness, battery health (guaranteed 85%+), motherboard thermals, camera optics, biometric sensors (Face ID/Touch ID/Shutter), and speaker audio clarity. Defective units are rejected.',
    },
    {
      'id': 'faq-4',
      'category': 'Buying Refurbished',
      'badge': 'Warranty & Returns',
      'q': 'What warranty and return policy do I get when buying refurbished tech?',
      'a': 'All certified refurbished devices purchased from Camsik come with a 6 to 12 months comprehensive warranty covering manufacturing and hardware defects, along with a 7-day hassle-free replacement guarantee if the device fails to meet expectations.',
    },
    {
      'id': 'faq-5',
      'category': 'Exchange & Upgrade',
      'badge': '1-Step Doorstep Swap',
      'q': 'How does the 1-step device exchange process work?',
      'a': 'Select the upgraded device you want and enter the details of your old phone, laptop, or camera. We add an exclusive exchange bonus (up to $kRupee 5,000) directly to your trade-in credit. Our specialist arrives at your doorstep with your upgraded device, inspects your old gadget, and you pay only the remaining balance on the spot.',
    },
    {
      'id': 'faq-6',
      'category': 'Exchange & Upgrade',
      'badge': 'Cashback Balance',
      'q': 'What happens if my old gadget is worth more than the device I want to buy?',
      'a': 'If your trade-in valuation exceeds the cost of your selected upgrade, Camsik pays YOU the remaining balance! The technician immediately transfers the surplus cash to your UPI or bank account right at your doorstep.',
    },
    {
      'id': 'faq-7',
      'category': 'Doorstep & Privacy',
      'badge': 'DoD 5220.22-M Wipe',
      'q': 'How is my private data and photos protected before device resale?',
      'a': 'Data security is our highest priority. Before any device leaves your hands, our technician performs a certified DoD 5220.22-M military-grade data sanitization wiping all internal SSDs, storage buffers, and user accounts. You receive a digitally signed legal bill of sale and liability indemnity certificate.',
    },
    {
      'id': 'faq-8',
      'category': 'Doorstep & Privacy',
      'badge': '100% Free Doorstep',
      'q': 'Are there any pickup or cancellation fees if I decline the doorstep quote?',
      'a': 'Zero hidden fees and zero travel charges! Doorstep evaluation is 100% free across 200+ cities in India. If the final on-site quote does not meet your expectations for any reason, you can decline with zero penalty.',
    },
    {
      'id': 'faq-9',
      'category': 'Selling & Valuation',
      'badge': '7-Day Price Lock',
      'q': 'How long is my online price quote valid?',
      'a': 'Once you generate a quote on Camsik, your price is locked for 7 days. You have complete flexibility to schedule your free doorstep pickup at any convenient slot within that period without worrying about market price fluctuations.',
    },
    {
      'id': 'faq-10',
      'category': 'Doorstep & Privacy',
      'badge': 'Instant Spot Transfer',
      'q': 'When and how will I receive payment for my device?',
      'a': 'Payment is initiated immediately before the technician packs the equipment. You can choose Instant UPI (Google Pay, PhonePe, Paytm) or direct IMPS bank transfer. The technician waits until you receive the bank confirmation SMS.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedCategory == 'All Questions'
        ? _allFaqs
        : _allFaqs.where((f) => f['category'] == _selectedCategory).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF059669).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.help_outline_rounded, color: Color(0xFF059669), size: 18),
              ),
              const SizedBox(width: 8),
              const Text(
                'Frequently Asked Questions',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) setState(() => _selectedCategory = cat);
                    },
                    selectedColor: const Color(0xFF059669),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF475569),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: isSelected ? const Color(0xFF059669) : const Color(0xFFE2E8F0)),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          ...filtered.map((f) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: Color(0xFFE2E8F0))),
                child: ExpansionTile(
                  leading: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      f['badge']!,
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                    ),
                  ),
                  title: Text(f['q']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A))),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 14),
                      child: Text(f['a']!, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, height: 1.5)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
