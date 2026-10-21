import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../models/partner_models.dart';

class OrderDetailSheet extends StatelessWidget {
  final PartnerOrder order;
  final Function(String newStatus)? onUpdateStatus;
  final Future<void> Function()? onOrderUpdated;

  const OrderDetailSheet({
    super.key,
    required this.order,
    this.onUpdateStatus,
    this.onOrderUpdated,
  });

  static void show({
    required BuildContext context,
    required PartnerOrder order,
    required Function(String newStatus) onUpdateStatus,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OrderDetailSheet(
        order: order,
        onUpdateStatus: onUpdateStatus,
      ),
    );
  }

  Future<void> _makeCall(String phone) async {
    final clean = phone.replaceAll(RegExp(r'\s+'), '');
    final uri = Uri.parse('tel:$clean');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(5.w, 1.5.h, 5.w, 2.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top drag handle
                Center(
                  child: Container(
                    width: 10.w > 45 ? 45 : 10.w,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),

                // Order Number & Status Pill
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.orderNumber,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16.sp,
                            color: AppColors.primary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 0.3.h),
                        Text(
                          'Intake: ${order.type.toUpperCase()}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF64748B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 0.6.h,
                      ),
                      decoration: BoxDecoration(
                        color: order.statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: order.statusColor.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Text(
                        order.statusDisplay,
                        style: TextStyle(
                          color: order.statusColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Device Card
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Icon(
                          Icons.devices_rounded,
                          color: order.typeColor,
                          size: 26,
                        ),
                      ),
                      SizedBox(width: 3.5.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.deviceName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            if (order.deviceStorage.isNotEmpty) ...[
                              SizedBox(height: 0.3.h),
                              Text(
                                'Variant: ${order.deviceStorage} • Brand: ${order.deviceBrand.isNotEmpty ? order.deviceBrand : "Certified"}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                            if (order.inspectionScore != null) ...[
                              SizedBox(height: 0.5.h),
                              Row(
                                children: [
                                  const Icon(Icons.verified_rounded,
                                      color: Color(0xFF059669), size: 14),
                                  SizedBox(width: 1.w),
                                  Text(
                                    'QA Score: ${order.inspectionScore}/100',
                                    style: TextStyle(
                                      color: const Color(0xFF059669),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 2.h),

                // Customer Details & Pickup Slot
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Customer & Delivery Address',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          if (order.customerPhone.isNotEmpty)
                            InkWell(
                              onTap: () => _makeCall(order.customerPhone),
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.phone_in_talk_rounded,
                                      size: 14,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      'Call Customer',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        '${order.customerName} (${order.customerPhone})',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(height: 0.4.h),
                      Text(
                        '${order.customerAddress}, ${order.city} - ${order.pinCode}',
                        style: TextStyle(
                          color: const Color(0xFF475569),
                          fontSize: 14.sp,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          const Icon(Icons.schedule_rounded,
                              size: 14, color: Color(0xFF64748B)),
                          SizedBox(width: 1.5.w),
                          Text(
                            'Slot: ${order.pickupDate} • ${order.pickupSlot}',
                            style: TextStyle(
                              color: const Color(0xFF64748B),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 2.h),

                // Pricing Summary Box
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Online Quoted Price',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          SizedBox(height: 0.3.h),
                          Text(
                            CurrencyFormatter.format(order.quotedPrice),
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF334155),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Final QA Valuation',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFF059669),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 0.3.h),
                          Text(
                            CurrencyFormatter.format(order.finalPrice),
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF059669),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                if (order.status != 'completed') ...[
                  SizedBox(height: 2.5.h),
                  Text(
                    'Order Lifecycle Action',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  SizedBox(height: 1.2.h),
                  Row(
                    children: [
                      if (order.status == 'assigned')
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 1.4.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              if (onUpdateStatus != null) {
                                onUpdateStatus!('accepted');
                              }
                            },
                            child: Text(
                              'Accept Store Task',
                              style: TextStyle(
                                fontSize: 14.5.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      if (order.status == 'accepted')
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD97706),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 1.4.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              if (onUpdateStatus != null) {
                                onUpdateStatus!('inspection');
                              }
                            },
                            child: Text(
                              'Start QA Inspection',
                              style: TextStyle(
                                fontSize: 14.5.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      if (order.status == 'inspection_completed' ||
                          order.status == 'final_price')
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF059669),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 1.4.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              if (onUpdateStatus != null) {
                                onUpdateStatus!('completed');
                              }
                            },
                            child: Text(
                              'Disburse & Complete',
                              style: TextStyle(
                                fontSize: 14.5.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
