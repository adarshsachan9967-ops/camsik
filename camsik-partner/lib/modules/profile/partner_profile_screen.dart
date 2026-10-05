import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../models/partner_models.dart';
import 'bloc/profile_cubit.dart';
import 'bloc/profile_state.dart';

class PartnerProfileScreen extends StatelessWidget {
  final PartnerUser? user;

  const PartnerProfileScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit()..loadProfile(),
      child: _ProfileView(initialUser: user),
    );
  }
}

class _ProfileView extends StatelessWidget {
  final PartnerUser? initialUser;

  const _ProfileView({this.initialUser});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        PartnerUser? activeUser;
        if (state is ProfileLoaded) {
          activeUser = state.user ?? initialUser;
        } else {
          activeUser = initialUser;
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.storefront,
                      size: 36,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    activeUser?.storeName ?? 'Tech Store Hub',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    activeUser?.name ?? 'Partner Owner',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified, size: 14, color: Color(0xFF059669)),
                        SizedBox(width: 4),
                        Text(
                          'Verified Camsik Partner Hub',
                          style: TextStyle(
                            color: Color(0xFF059669),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildInfoCard('Contact & Location', [
              _buildInfoRow('Phone', activeUser?.phone ?? '+91 98765 43210'),
              _buildInfoRow('Email', activeUser?.email ?? 'partner@camsik.com'),
              _buildInfoRow(
                'City & State',
                '${activeUser?.city ?? "Mumbai"}, ${activeUser?.state ?? "Maharashtra"}',
              ),
            ]),

            const SizedBox(height: 14),

            _buildInfoCard('Operating Parameters', [
              _buildInfoRow(
                'Commission Rate',
                '${activeUser?.commission ?? 5.0}% per unit liquidated',
              ),
              _buildInfoRow(
                'Operating Pin Codes',
                activeUser?.pinCodes.isNotEmpty == true
                    ? activeUser!.pinCodes.join(', ')
                    : '400001, 400050, 401107',
              ),
            ]),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFEE2E2),
                foregroundColor: AppColors.error,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.logout, size: 18),
              label: const Text(
                'Sign Out from Partner App',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              onPressed: () async {
                await context.read<ProfileCubit>().logout();
                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.login,
                    (route) => false,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
