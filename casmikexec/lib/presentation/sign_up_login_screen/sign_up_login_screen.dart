import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import './widgets/login_form_widget.dart';
import './widgets/pending_approval_widget.dart';
import './widgets/signup_stepper_widget.dart';

class SignUpLoginScreen extends StatefulWidget {
  const SignUpLoginScreen({super.key});

  @override
  State<SignUpLoginScreen> createState() => _SignUpLoginScreenState();
}

class _SignUpLoginScreenState extends State<SignUpLoginScreen>
    with SingleTickerProviderStateMixin {
  // TODO: Replace with [Riverpod/Bloc] for production
  bool _isLogin = true;
  bool _showPending = false;
  late AnimationController _bgController;
  late Animation<double> _bgAnimation;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _bgAnimation = CurvedAnimation(
      parent: _bgController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  void _onLoginSuccess() {
    context.go(AppRoutes.dashboard);
  }

  void _onSignupComplete() {
    setState(() => _showPending = true);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Stack(
        children: [
          // Animated background blob — Liquid Morph splash variant
          AnimatedBuilder(
            animation: _bgAnimation,
            builder: (context, _) {
              return Positioned(
                top: -60,
                right: -40,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  width: 260 + (_bgAnimation.value * 40),
                  height: 260 + (_bgAnimation.value * 40),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(
                      0.08 + _bgAnimation.value * 0.04,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(120 + _bgAnimation.value * 40),
                      bottomLeft: Radius.circular(
                        160 + _bgAnimation.value * 20,
                      ),
                      bottomRight: Radius.circular(
                        80 + _bgAnimation.value * 60,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _bgAnimation,
            builder: (context, _) {
              return Positioned(
                bottom: 80,
                left: -60,
                child: Container(
                  width: 200 + (_bgAnimation.value * 30),
                  height: 200 + (_bgAnimation.value * 30),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(
                      0.05 + _bgAnimation.value * 0.03,
                    ),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(100 + _bgAnimation.value * 50),
                      bottomRight: Radius.circular(
                        140 + _bgAnimation.value * 20,
                      ),
                      topLeft: Radius.circular(60 + _bgAnimation.value * 40),
                    ),
                  ),
                ),
              );
            },
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? (size.width - 480) / 2 : 24,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // Logo
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.delivery_dining_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'CASMIK',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Delivery Executive Portal',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 32),
                      if (_showPending)
                        PendingApprovalWidget(onContactSupport: () {})
                      else if (_isLogin)
                        LoginFormWidget(
                          onLoginSuccess: _onLoginSuccess,
                          onSwitchToSignup: () =>
                              setState(() => _isLogin = false),
                        )
                      else
                        SignupStepperWidget(
                          onSignupComplete: _onSignupComplete,
                          onSwitchToLogin: () =>
                              setState(() => _isLogin = true),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
