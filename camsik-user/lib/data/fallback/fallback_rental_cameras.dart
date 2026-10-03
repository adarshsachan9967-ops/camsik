import 'fallback_rental_cameras_part1.dart';
import 'fallback_rental_cameras_part2.dart';

class FallbackRentalCameras {
  static final List<Map<String, dynamic>> data = [
    ...fallbackRentalCamerasPart1,
    ...fallbackRentalCamerasPart2,
  ];
}
