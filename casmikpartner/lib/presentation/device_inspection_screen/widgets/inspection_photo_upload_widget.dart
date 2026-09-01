import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class InspectionPhotoUploadWidget extends StatelessWidget {
  final List<String?> photos;
  final Function(int index) onPhotoAdded;

  const InspectionPhotoUploadWidget({
    required this.photos,
    required this.onPhotoAdded,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final uploadedCount = photos.where((p) => p != null).length;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 6,
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
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6A1B9A).withAlpha(26),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.photo_camera_outlined,
                      size: 15,
                      color: Color(0xFF6A1B9A),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Device Photos',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                '$uploadedCount / 6 uploaded',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: 6,
            itemBuilder: (_, i) {
              final hasPhoto = photos[i] != null;
              return GestureDetector(
                onTap: () => onPhotoAdded(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: hasPhoto
                        ? AppTheme.primary.withAlpha(20)
                        : AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: hasPhoto
                          ? AppTheme.primary.withAlpha(77)
                          : const Color(0xFFE0E0E0),
                      style: hasPhoto ? BorderStyle.solid : BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        hasPhoto
                            ? Icons.check_circle_rounded
                            : Icons.add_a_photo_outlined,
                        size: 22,
                        color: hasPhoto
                            ? AppTheme.primary
                            : AppTheme.textSecondary,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        hasPhoto ? 'Photo ${i + 1}' : 'Add Photo',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: hasPhoto
                              ? AppTheme.primary
                              : AppTheme.textSecondary,
                          fontWeight: hasPhoto
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Upload clear photos of front, back, screen, and any damage areas',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
