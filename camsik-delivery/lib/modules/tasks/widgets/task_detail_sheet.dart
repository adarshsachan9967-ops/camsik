import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../models/delivery_models.dart';
import '../bloc/tasks_cubit.dart';
import 'otp_verification_dialog.dart';

class TaskDetailSheet {
  static void show({
    required BuildContext context,
    required DeliveryTask task,
    required TasksCubit tasksCubit,
    VoidCallback? onRefresh,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (_, scrollController) {
            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      task.orderNumber,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: task.statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        task.statusDisplay,
                        style: TextStyle(
                          color: task.statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Customer & Doorstep Location',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  task.customerName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 2),
                InkWell(
                  onTap: () => openDialer(task.customerPhone),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.phone, size: 14, color: AppColors.info),
                      const SizedBox(width: 4),
                      Text(
                        task.customerPhone,
                        style: const TextStyle(
                          color: AppColors.info,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: () => openGoogleMapsNavigation(
                    '${task.customerAddress}, ${task.city}',
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.navigation, size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${task.customerAddress}, ${task.city} - ${task.pinCode} (Tap to Navigate)',
                          style: const TextStyle(color: Colors.black87, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Gadget Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  task.deviceName,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                ),
                Text(
                  'Scheduled Slot: ${task.pickupDate} • ${task.pickupSlot}',
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Payout / Deal Value',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(task.finalPrice),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (task.status != 'completed') ...[
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.pin, size: 18),
                    label: const Text(
                      'Verify Customer OTP & Complete Handover',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      OtpVerificationDialog.show(
                        context: context,
                        task: task,
                        tasksCubit: tasksCubit,
                        onVerified: onRefresh,
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.info,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.info),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.two_wheeler, size: 18),
                    label: const Text(
                      'Mark Out For Pickup / In Transit',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    onPressed: () async {
                      Navigator.pop(ctx);
                      await tasksCubit.updateTaskStatus(
                        orderId: task.id,
                        status: 'in_transit',
                      );
                      onRefresh?.call();
                      if (context.mounted) {
                        showCustomSnackBar(
                          context,
                          'Task updated to In Transit',
                          isError: false,
                        );
                      }
                    },
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }
}
