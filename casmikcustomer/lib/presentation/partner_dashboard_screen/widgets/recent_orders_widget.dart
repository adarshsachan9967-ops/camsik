import 'package:flutter/material.dart';

class RecentOrdersWidget extends StatelessWidget {
  const RecentOrdersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = [
      _OrderItem(
        id: '#CSM-4821',
        customer: 'Rahul Sharma',
        device: 'iPhone 13 Pro',
        amount: '₹42,000',
        status: 'Inspection',
        statusColor: const Color(0xFF3B82F6),
        statusBg: const Color(0xFFEFF6FF),
        time: '12 min ago',
      ),
      _OrderItem(
        id: '#CSM-4820',
        customer: 'Priya Nair',
        device: 'Samsung S22',
        amount: '₹28,500',
        status: 'Pickup',
        statusColor: const Color(0xFFF59E0B),
        statusBg: const Color(0xFFFFFBEB),
        time: '38 min ago',
      ),
      _OrderItem(
        id: '#CSM-4819',
        customer: 'Arjun Mehta',
        device: 'OnePlus 11',
        amount: '₹19,200',
        status: 'Completed',
        statusColor: const Color(0xFF00C853),
        statusBg: const Color(0xFFE8FFF0),
        time: '1h ago',
      ),
      _OrderItem(
        id: '#CSM-4818',
        customer: 'Sneha Patel',
        device: 'Pixel 7 Pro',
        amount: '₹35,000',
        status: 'Accepted',
        statusColor: const Color(0xFF8B5CF6),
        statusBg: const Color(0xFFF5F3FF),
        time: '2h ago',
      ),
      _OrderItem(
        id: '#CSM-4817',
        customer: 'Vikram Singh',
        device: 'iPhone 12',
        amount: '₹31,500',
        status: 'Completed',
        statusColor: const Color(0xFF00C853),
        statusBg: const Color(0xFFE8FFF0),
        time: '3h ago',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Orders',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'View all',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF00C853),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(8),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const Divider(
              height: 1,
              color: Color(0xFFF3F4F6),
              indent: 16,
              endIndent: 16,
            ),
            itemBuilder: (context, i) => _OrderRow(order: orders[i]),
          ),
        ),
      ],
    );
  }
}

class _OrderItem {
  final String id;
  final String customer;
  final String device;
  final String amount;
  final String status;
  final Color statusColor;
  final Color statusBg;
  final String time;

  const _OrderItem({
    required this.id,
    required this.customer,
    required this.device,
    required this.amount,
    required this.status,
    required this.statusColor,
    required this.statusBg,
    required this.time,
  });
}

class _OrderRow extends StatelessWidget {
  final _OrderItem order;
  const _OrderRow({required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.smartphone,
              size: 18,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      order.customer,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      order.id,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      order.device,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '· ${order.time}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                order.amount,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: order.statusBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: order.statusColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
