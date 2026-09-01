import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import './widgets/mobile_input_widget.dart';
import './widgets/otp_input_widget.dart';

enum _AuthStep { landing, mobileInput, otpVerification }

class SignUpLoginScreen extends StatefulWidget {
  const SignUpLoginScreen({super.key});

  @override
  State<SignUpLoginScreen> createState() => _SignUpLoginScreenState();
}

class _SignUpLoginScreenState extends State<SignUpLoginScreen>
    with TickerProviderStateMixin {
  // TODO: Replace with Riverpod/Bloc for production
  _AuthStep _step = _AuthStep.landing;
  String _mobileNumber = '';
  bool _isLoading = false;

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _transitionTo(_AuthStep step) {
    setState(() => _step = step);
    _slideController.reset();
    _slideController.forward();
  }

  void _onSendOtp(String mobile) {
    setState(() {
      _mobileNumber = mobile;
      _isLoading = true;
    });
    // TODO: Replace with Supabase OTP auth
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isLoading = false);
        _transitionTo(_AuthStep.otpVerification);
      }
    });
  }

  void _onVerifyOtp(String otp) {
    setState(() => _isLoading = true);
    // TODO: Replace with Supabase OTP verification
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isLoading = false);
        context.go(AppRoutes.homeScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceLight,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: _buildCurrentStep(),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_step) {
      case _AuthStep.landing:
        return _LandingView(
          onLogin: () => _transitionTo(_AuthStep.mobileInput),
          onSignUp: () => _transitionTo(_AuthStep.mobileInput),
        );
      case _AuthStep.mobileInput:
        return MobileInputWidget(
          isLoading: _isLoading,
          onSendOtp: _onSendOtp,
          onBack: () => _transitionTo(_AuthStep.landing),
        );
      case _AuthStep.otpVerification:
        return OtpInputWidget(
          mobileNumber: _mobileNumber,
          isLoading: _isLoading,
          onVerify: _onVerifyOtp,
          onBack: () => _transitionTo(_AuthStep.mobileInput),
          onResend: () => _onSendOtp(_mobileNumber),
        );
    }
  }
}

class _LandingView extends StatelessWidget {
  final VoidCallback onLogin;
  final VoidCallback onSignUp;

  const _LandingView({required this.onLogin, required this.onSignUp});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Hero image 70% height (anatomy from Image 2.1)
        Expanded(
          flex: 7,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CustomImageWidget(
                imageUrl:
                    'https://images.pexels.com/photos/1092644/pexels-photo-1092644.jpeg?auto=compress&cs=tinysrgb&w=800',
                fit: BoxFit.cover,
                semanticLabel:
                    'Premium refurbished smartphones arranged artistically on white surface',
              ),
              // Watermark text behind
              Center(
                child: Text(
                  'CASMIK',
                  style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w900,
                    color: Colors.white.withAlpha(20),
                    letterSpacing: -2,
                  ),
                ),
              ),
              // Bottom gradient
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 120,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [AppTheme.surfaceLight, Colors.transparent],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Bottom content 30%
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Next Level\n',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                          height: 1.1,
                        ),
                      ),
                      TextSpan(
                        text: 'Device Experience',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.textPrimary,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sell, buy refurbished, exchange & repair\nwith India\'s most trusted platform.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                // Dual CTA: outlined Login + filled Sign Up (anatomy from Image 2.1)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onLogin,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          side: BorderSide(color: AppTheme.borderLight),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onSignUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.textPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
