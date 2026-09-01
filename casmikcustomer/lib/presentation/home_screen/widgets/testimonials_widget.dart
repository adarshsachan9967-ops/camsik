import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class TestimonialsWidget extends StatefulWidget {
  const TestimonialsWidget({super.key});

  @override
  State<TestimonialsWidget> createState() => _TestimonialsWidgetState();
}

class _TestimonialsWidgetState extends State<TestimonialsWidget> {
  int _current = 0;
  final PageController _ctrl = PageController();

  final List<Map<String, dynamic>> _testimonials = [
    {
      'name': 'Priya Sharma',
      'city': 'Mumbai',
      'rating': 5,
      'text':
          'Sold my iPhone 12 and got ₹28,500 in my account the same evening! The pickup agent was professional and the whole process took just 20 minutes.',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_11b76e36b-1772204761788.png',
      'semanticLabel':
          'Young Indian woman with dark hair smiling, customer testimonial photo',
      'service': 'Sold iPhone 12',
    },
    {
      'name': 'Arjun Mehta',
      'city': 'Bangalore',
      'rating': 5,
      'text':
          'Bought a refurbished Samsung S22 in Superb condition. It looks and works like new! The 6-month warranty gives real peace of mind.',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1133e9c52-1772892740916.png',
      'semanticLabel':
          'Indian man in blue shirt smiling, customer testimonial photo',
      'service': 'Bought Samsung S22',
    },
    {
      'name': 'Kavitha Nair',
      'city': 'Chennai',
      'rating': 4,
      'text':
          'The exchange process was super smooth. Got ₹18,000 for my old OnePlus 9 and paid only ₹12,000 extra for the OnePlus 11. Highly recommend!',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1eec2d417-1773055111310.png',
      'semanticLabel':
          'South Indian woman with traditional jewelry smiling, customer testimonial',
      'service': 'Exchanged OnePlus 9',
    },
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'What Customers Say',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _ctrl,
            onPageChanged: (i) => setState(() => _current = i),
            itemCount: _testimonials.length,
            itemBuilder: (context, index) {
              final t = _testimonials[index];
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 16 : 8,
                  right: index == _testimonials.length - 1 ? 16 : 8,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.borderLight),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(13),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: CustomImageWidget(
                              imageUrl: t['imageUrl'] as String,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              semanticLabel: t['semanticLabel'] as String,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t['name'] as String,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                Text(
                                  '${t['city']} • ${t['service']}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: List.generate(
                              5,
                              (i) => CustomIconWidget(
                                iconName: i < (t['rating'] as int)
                                    ? 'star'
                                    : 'star_outline',
                                color: AppTheme.warning,
                                size: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        t['text'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                          height: 1.5,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _testimonials.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == _current ? 16 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: i == _current ? AppTheme.primary : AppTheme.borderLight,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
