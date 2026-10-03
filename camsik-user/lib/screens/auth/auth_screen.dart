import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../../services/api_service.dart';
import '../../widgets/auth_input_field.dart';

class CamsikAuthScreen extends StatefulWidget {
  final Function(UserProfile) onAuthSuccess;
  final UserProfile initialProfile;

  const CamsikAuthScreen({
    super.key,
    required this.onAuthSuccess,
    required this.initialProfile,
  });

  @override
  State<CamsikAuthScreen> createState() => _CamsikAuthScreenState();
}

class _CamsikAuthScreenState extends State<CamsikAuthScreen> {
  bool _isRegister = false;
  bool _obscureLoginPassword = true;
  bool _obscureRegPassword = true;
  bool _obscureRegConfirm = true;
  bool _isSubmitting = false;

  final TextEditingController _loginIdController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();

  final TextEditingController _regNameController = TextEditingController();
  final TextEditingController _regPhoneController = TextEditingController();
  final TextEditingController _regEmailController = TextEditingController();
  final TextEditingController _regPasswordController = TextEditingController();
  final TextEditingController _regConfirmController = TextEditingController();

  final FocusNode _regNameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.initialProfile.phone.isNotEmpty) {
      _loginIdController.text = widget.initialProfile.phone;
    }
  }

  @override
  void dispose() {
    _loginIdController.dispose();
    _loginPasswordController.dispose();
    _regNameController.dispose();
    _regPhoneController.dispose();
    _regEmailController.dispose();
    _regPasswordController.dispose();
    _regConfirmController.dispose();
    _regNameFocus.dispose();
    super.dispose();
  }

  void _switchMode(bool register) {
    FocusScope.of(context).unfocus();
    setState(() {
      _isRegister = register;
    });
    if (register) {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) _regNameFocus.requestFocus();
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleSubmit() async {
    FocusScope.of(context).unfocus();

    if (_isRegister) {
      final name = _regNameController.text.trim();
      final phone = _regPhoneController.text.trim().replaceAll(RegExp(r'\D'), '');
      final email = _regEmailController.text.trim().toLowerCase();
      final password = _regPasswordController.text.trim();
      final confirmPassword = _regConfirmController.text.trim();

      if (name.isEmpty) {
        _showError('Please enter your full name');
        return;
      }
      if (phone.length != 10) {
        _showError('Please enter a valid 10-digit mobile number');
        return;
      }
      if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
        _showError('Please enter a valid email address');
        return;
      }
      if (password.length < 6) {
        _showError('Password must be at least 6 characters long');
        return;
      }
      if (password != confirmPassword) {
        _showError('Passwords do not match');
        return;
      }

      setState(() => _isSubmitting = true);

      try {
        final res = await ApiService.signUp(
          name: name,
          phone: phone,
          email: email,
          password: password,
        );

        if (!mounted) return;
        setState(() => _isSubmitting = false);

        if (res['success'] == true) {
          Map<String, dynamic>? u;
          if (res['user'] != null && res['user'] is Map) {
            u = Map<String, dynamic>.from(res['user'] as Map);
          }
          final profile = UserProfile(
            name: u?['name']?.toString() ?? name,
            phone: u?['phone']?.toString() ?? phone,
            email: u?['email']?.toString() ?? email,
            avatarIndex: 0,
            upiId: '',
            bankAccount: '',
            address: '',
          );
          widget.onAuthSuccess(profile);
        } else {
          _showError(res['message']?.toString() ?? 'Registration failed. Mobile may already be registered.');
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isSubmitting = false);
          _showError('Registration error: ${e.toString()}');
        }
      }
    } else {
      // Login Mode
      final identifier = _loginIdController.text.trim();
      final password = _loginPasswordController.text.trim();

      if (identifier.isEmpty || identifier.length < 3) {
        _showError('Please enter your 10-digit mobile number or email address');
        return;
      }
      if (password.isEmpty) {
        _showError('Please enter your account password');
        return;
      }

      setState(() => _isSubmitting = true);

      try {
        final res = await ApiService.login(
          identifier: identifier,
          password: password,
        );

        if (!mounted) return;
        setState(() => _isSubmitting = false);

        if (res['success'] == true) {
          Map<String, dynamic>? u;
          if (res['user'] != null && res['user'] is Map) {
            u = Map<String, dynamic>.from(res['user'] as Map);
          }
          final cleanPhone = identifier.replaceAll(RegExp(r'\D'), '');
          final profile = UserProfile(
            name: u?['name']?.toString() ?? 'Camsik Customer',
            phone: u?['phone']?.toString() ?? (cleanPhone.length == 10 ? cleanPhone : identifier),
            email: u?['email']?.toString() ?? (identifier.contains('@') ? identifier : '$cleanPhone@camsik.in'),
            avatarIndex: 0,
            upiId: '',
            bankAccount: '',
            address: '',
          );
          widget.onAuthSuccess(profile);
        } else {
          _showError(res['message']?.toString() ?? 'Incorrect password or account not found.');
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isSubmitting = false);
          _showError('Login error: ${e.toString()}');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7C3AED), Color(0xFF4F46E5), Color(0xFF2563EB)],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7C3AED).withValues(alpha: 0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.camera_alt_rounded, color: Colors.white, size: 32),
                      ),
                    ),
                    const SizedBox(height: 12),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'CAM',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 28, letterSpacing: -0.5),
                          ),
                          TextSpan(
                            text: 'SIK',
                            style: TextStyle(
                              color: Color(0xFF818CF8),
                              fontWeight: FontWeight.w900,
                              fontSize: 28,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      "India's #1 Camera & Tech ReCommerce Platform",
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Segmented Mode Selector
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _switchMode(false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !_isRegister ? const Color(0xFF059669) : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                color: !_isRegister ? Colors.white : Colors.white60,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _switchMode(true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _isRegister ? const Color(0xFF059669) : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Create Account',
                              style: TextStyle(
                                color: _isRegister ? Colors.white : Colors.white60,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                _isRegister ? 'Create Camsik Account' : 'Welcome to Camsik',
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                _isRegister
                    ? 'Enter your details to start buying, selling & exchanging.'
                    : 'Sign in with your phone or email to access your orders.',
                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
              ),
              const SizedBox(height: 24),

              if (_isRegister) ...[
                // Registration Form
                AuthInputField(
                  label: 'Full Name',
                  controller: _regNameController,
                  focusNode: _regNameFocus,
                  icon: Icons.person_outline,
                  hint: 'Enter your full name',
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                AuthInputField(
                  label: 'Mobile Number',
                  controller: _regPhoneController,
                  icon: Icons.phone_android,
                  hint: '10-digit mobile number',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                AuthInputField(
                  label: 'Email Address',
                  controller: _regEmailController,
                  icon: Icons.email_outlined,
                  hint: 'Enter your email address',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                AuthInputField(
                  label: 'Password',
                  controller: _regPasswordController,
                  icon: Icons.lock_outline,
                  hint: 'Create password (min 6 characters)',
                  isPassword: true,
                  obscureText: _obscureRegPassword,
                  onToggleVisibility: () => setState(() => _obscureRegPassword = !_obscureRegPassword),
                ),
                const SizedBox(height: 16),
                AuthInputField(
                  label: 'Confirm Password',
                  controller: _regConfirmController,
                  icon: Icons.lock_clock_outlined,
                  hint: 'Re-enter your password',
                  isPassword: true,
                  obscureText: _obscureRegConfirm,
                  onToggleVisibility: () => setState(() => _obscureRegConfirm = !_obscureRegConfirm),
                ),
              ] else ...[
                // Login Form
                AuthInputField(
                  label: 'Mobile Number or Email',
                  controller: _loginIdController,
                  icon: Icons.person_outline,
                  hint: 'Enter 10-digit phone or email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                AuthInputField(
                  label: 'Password',
                  controller: _loginPasswordController,
                  icon: Icons.lock_outline,
                  hint: 'Enter your password',
                  isPassword: true,
                  obscureText: _obscureLoginPassword,
                  onToggleVisibility: () => setState(() => _obscureLoginPassword = !_obscureLoginPassword),
                ),
              ],

              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                  ),
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                        )
                      : Text(
                          _isRegister ? 'Create Account & Continue' : 'Sign In to Camsik',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () => _switchMode(!_isRegister),
                  child: RichText(
                    text: TextSpan(
                      text: _isRegister ? 'Already have an account? ' : "Don't have an account? ",
                      style: const TextStyle(color: Colors.white60, fontSize: 13),
                      children: [
                        TextSpan(
                          text: _isRegister ? 'Sign In' : 'Create One Now',
                          style: const TextStyle(color: Color(0xFF34D399), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
