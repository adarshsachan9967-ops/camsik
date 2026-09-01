import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_widget.dart';

class OnboardingSlideWidget extends StatelessWidget {
  final String imageUrl;
  final String semanticLabel;
  final String headline;
  final String subtitle;

  const OnboardingSlideWidget({
    required this.imageUrl,
    required this.semanticLabel,
    required this.headline,
    required this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CustomImageWidget(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          semanticLabel: semanticLabel,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withAlpha(179), Colors.transparent],
              stops: const [0.0, 0.5],
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          left: 24,
          right: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                headline,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withAlpha(204),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
