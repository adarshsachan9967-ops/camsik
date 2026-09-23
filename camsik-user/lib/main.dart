import 'dart:async';
import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'services/notification_service.dart';
import 'services/session_service.dart';

// Unicode Escape Constants to permanently eliminate encoding glitches
const String kRupee = '\u20B9';
const String kBullet = '\u2022';

String formatCurrency(num amount) {
  final str = amount.toStringAsFixed(0);
  if (str.length <= 3) return '$kRupee$str';
  final lastThree = str.substring(str.length - 3);
  final remaining = str.substring(0, str.length - 3);
  final formattedRemaining = remaining.replaceAllMapped(
    RegExp(r'(\d)(?=(\d\d)+$)'),
    (Match m) => '${m[1]},',
  );
  return '$kRupee$formattedRemaining,$lastThree';
}

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SessionService.init();
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('CamsikUser Error: ${details.exception}');
    };
    runApp(const CamsikUserApp());
  }, (error, stack) {
    debugPrint('CamsikUser Uncaught: $error\n$stack');
  });
}

// ── ROOT APPLICATION ──

class CamsikUserApp extends StatefulWidget {
  const CamsikUserApp({super.key});

  @override
  State<CamsikUserApp> createState() => _CamsikUserAppState();
}

class _CamsikUserAppState extends State<CamsikUserApp> {
  bool _isFirstLaunch = false;
  bool _isLoggedIn = false;

  // Active User Profile - Starts clean and empty by default (no static dummy values)
  UserProfile _userProfile = UserProfile(
    name: 'Camsik Customer',
    phone: '',
    email: '',
    avatarIndex: 0,
    upiId: '',
    bankAccount: '',
    address: '',
  );

  @override
  void initState() {
    super.initState();
    _initSession();
  }

  void _initSession() {
    final loggedIn = SessionService.isLoggedIn();
    final onboarded = SessionService.hasCompletedOnboarding();
    final savedProfile = SessionService.getSavedProfile();

    setState(() {
      _isLoggedIn = loggedIn;
      _isFirstLaunch = !onboarded && !loggedIn;
      if (savedProfile != null) {
        _userProfile = UserProfile(
          name: savedProfile['name']?.toString().isNotEmpty == true ? savedProfile['name'] : 'Camsik Customer',
          phone: savedProfile['phone']?.toString() ?? '',
          email: savedProfile['email']?.toString() ?? '',
          avatarIndex: savedProfile['avatarIndex'] is int ? savedProfile['avatarIndex'] : 0,
          upiId: savedProfile['upiId']?.toString() ?? '',
          bankAccount: savedProfile['bankAccount']?.toString() ?? '',
          address: savedProfile['address']?.toString() ?? '',
        );
      }
    });
  }

  void _completeOnboarding() {
    SessionService.setOnboardingCompleted();
    setState(() {
      _isFirstLaunch = false;
    });
  }

  void _loginUser(UserProfile profile) {
    SessionService.saveUserSession(
      name: profile.name,
      phone: profile.phone,
      email: profile.email,
      upiId: profile.upiId,
      bankAccount: profile.bankAccount,
      address: profile.address,
      avatarIndex: profile.avatarIndex,
    );
    setState(() {
      _userProfile = profile;
      _isFirstLaunch = false;
      _isLoggedIn = true;
    });
  }

  void _logoutUser() {
    SessionService.clearSession();
    setState(() {
      _isLoggedIn = false;
    });
  }

  void _updateProfile(UserProfile updated) {
    SessionService.saveUserSession(
      name: updated.name,
      phone: updated.phone,
      email: updated.email,
      upiId: updated.upiId,
      bankAccount: updated.bankAccount,
      address: updated.address,
      avatarIndex: updated.avatarIndex,
    );
    setState(() {
      _userProfile = updated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camsik User',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF059669), // Camsik Emerald
          primary: const Color(0xFF059669),
          secondary: const Color(0xFF4F46E5), // Electric Indigo
          surface: const Color(0xFFF8FAFC),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        cardTheme: const CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          color: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F172A),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: _isLoggedIn
          ? UserMainNavigationScreen(
              userProfile: _userProfile,
              onProfileUpdate: _updateProfile,
              onLogout: _logoutUser,
            )
          : _isFirstLaunch
              ? CamsikOnboardingScreen(onFinish: _completeOnboarding)
              : CamsikAuthScreen(
                  onAuthSuccess: _loginUser,
                  initialProfile: _userProfile,
                ),
    );
  }
}

// ── DATA MODELS ──

class UserProfile {
  String name;
  String phone;
  String email;
  int avatarIndex;
  String upiId;
  String bankAccount;
  String address;

  UserProfile({
    required this.name,
    required this.phone,
    required this.email,
    required this.avatarIndex,
    required this.upiId,
    required this.bankAccount,
    required this.address,
  });
}

class UserOrder {
  final String id;
  final String orderNumber;
  final String type; // 'sell' | 'buy' | 'exchange'
  final String device;
  final int amount;
  final String status;
  final String otp;
  final String date;
  final String address;
  final String paymentMethod;
  final List<String> timelineSteps;
  final int currentStep;

  UserOrder({
    required this.id,
    required this.orderNumber,
    required this.type,
    required this.device,
    required this.amount,
    required this.status,
    required this.otp,
    required this.date,
    required this.address,
    required this.paymentMethod,
    required this.timelineSteps,
    required this.currentStep,
  });

  factory UserOrder.fromJson(Map<String, dynamic> json) {
    return UserOrder(
      id: json['id'] ?? 'ord-${DateTime.now().millisecondsSinceEpoch}',
      orderNumber: json['orderNumber'] ?? 'CSM-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      type: json['type'] ?? 'sell',
      device: json['deviceName'] ?? json['device'] ?? 'Tech Device',
      amount: (json['amount'] is num) ? (json['amount'] as num).toInt() : 0,
      status: json['status'] ?? 'Order Placed',
      otp: json['otp'] ?? '1234',
      date: json['pickupDate'] ?? json['createdAt'] ?? 'Today',
      address: json['customerAddress'] ?? json['address'] ?? 'Registered Address',
      paymentMethod: json['paymentMethod'] ?? 'Instant UPI',
      timelineSteps: [
        'Order Placed & Confirmed',
        'Camsik Executive Assigned',
        'Doorstep Verification',
        'Inspection & Data Wipe',
        'Payment Disbursed / Complete',
      ],
      currentStep: 1,
    );
  }
}

// ── 1. ONBOARDING / SPLASH SCREENS (3 SLIDES) ──

class CamsikOnboardingScreen extends StatefulWidget {
  final VoidCallback onFinish;
  const CamsikOnboardingScreen({super.key, required this.onFinish});

  @override
  State<CamsikOnboardingScreen> createState() => _CamsikOnboardingScreenState();
}

class _CamsikOnboardingScreenState extends State<CamsikOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentSlide = 0;

  final List<Map<String, dynamic>> _slides = [
    {
      'badge': 'INSTANT CASH PAYOUT $kBullet 60-SEC AI QUOTE',
      'title': 'Sell Old Tech & Cameras for Peak Cash',
      'subtitle':
          'Guaranteed highest resale payout for iPhones, MacBooks, DSLRs, Lenses & Tablets. 60-second AI valuation, free doorstep pickup & spot UPI transfer.',
      'gradient': [const Color(0xFF064E3B), const Color(0xFF059669)],
      'accent': const Color(0xFF34D399),
      'icon': Icons.bolt_rounded,
      'pills': ['Zero Hidden Deductions', 'Spot UPI Payout', 'DoD Military Wipe'],
    },
    {
      'badge': 'CERTIFIED REFURBISHED $kBullet 45-POINT CHECK',
      'title': 'Buy Verified Tech at up to 70% Off',
      'subtitle':
          'Explore 45-point rigorously tested pre-owned flagships with 6 to 12 months comprehensive warranty, 7-day replacement guarantee, and 90%+ healthy batteries.',
      'gradient': [const Color(0xFF1E1B4B), const Color(0xFF4F46E5)],
      'accent': const Color(0xFF818CF8),
      'icon': Icons.shopping_bag_rounded,
      'pills': ['6-12 Months Warranty', 'Battery 90%+', '100% Genuine Parts'],
    },
    {
      'badge': '1-STEP EXCHANGE $kBullet +$kRupee 5,000 BONUS',
      'title': 'Doorstep 1-Step Exchange & Upgrade',
      'subtitle':
          'Upgrade your gadget seamlessly with zero downtime. Hand your old device to our verified executive and receive your certified upgrade on the spot!',
      'gradient': [const Color(0xFF3B0764), const Color(0xFF7C3AED)],
      'accent': const Color(0xFFC084FC),
      'icon': Icons.swap_horizontal_circle_rounded,
      'pills': ['Extra $kRupee 5,000 Bonus', '1-Step Doorstep Swap', 'Pay Difference Only'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_currentSlide];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: widget.onFinish,
                  child: const Text(
                    'Skip',
                    style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (idx) => setState(() => _currentSlide = idx),
                itemBuilder: (ctx, idx) {
                  final item = _slides[idx];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: item['gradient'] as List<Color>,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (item['accent'] as Color).withValues(alpha: 0.35),
                                blurRadius: 28,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(item['icon'] as IconData, size: 60, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 36),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: (item['accent'] as Color).withValues(alpha: 0.5)),
                          ),
                          child: Text(
                            item['badge'] as String,
                            style: TextStyle(
                              color: item['accent'] as Color,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          item['title'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item['subtitle'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: (item['pills'] as List<String>).map((pill) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle_rounded, size: 13, color: item['accent'] as Color),
                                  const SizedBox(width: 5),
                                  Text(
                                    pill,
                                    style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      _slides.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.only(right: 6),
                        width: _currentSlide == i ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentSlide == i ? (slide['accent'] as Color) : Colors.white24,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: slide['accent'] as Color,
                      foregroundColor: const Color(0xFF0F172A),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                    ),
                    onPressed: () {
                      if (_currentSlide < _slides.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        widget.onFinish();
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          _currentSlide == _slides.length - 1 ? 'Get Started' : 'Next',
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward_rounded, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 2. LOGIN & SIGN UP SCREEN ──

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

  // Separate controllers to prevent input contamination
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
                _buildInputField(
                  label: 'Full Name',
                  controller: _regNameController,
                  focusNode: _regNameFocus,
                  icon: Icons.person_outline,
                  hint: 'Enter your full name',
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  label: 'Mobile Number',
                  controller: _regPhoneController,
                  icon: Icons.phone_android,
                  hint: '10-digit mobile number',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  label: 'Email Address',
                  controller: _regEmailController,
                  icon: Icons.email_outlined,
                  hint: 'Enter your email address',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  label: 'Password',
                  controller: _regPasswordController,
                  icon: Icons.lock_outline,
                  hint: 'Create password (min 6 characters)',
                  isPassword: true,
                  obscureText: _obscureRegPassword,
                  onToggleVisibility: () => setState(() => _obscureRegPassword = !_obscureRegPassword),
                ),
                const SizedBox(height: 16),
                _buildInputField(
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
                _buildInputField(
                  label: 'Mobile Number or Email',
                  controller: _loginIdController,
                  icon: Icons.person_outline,
                  hint: 'Enter 10-digit phone or email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _buildInputField(
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

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    FocusNode? focusNode,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          obscureText: isPassword ? obscureText : false,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
            prefixIcon: Icon(icon, color: const Color(0xFF34D399), size: 20),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white54,
                      size: 20,
                    ),
                    onPressed: onToggleVisibility,
                  )
                : null,
            filled: true,
            fillColor: const Color(0xFF1E293B),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF34D399), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

// ── 3. MAIN NAVIGATION CONTAINER (5 TABS) ──

class UserMainNavigationScreen extends StatefulWidget {
  final UserProfile userProfile;
  final Function(UserProfile) onProfileUpdate;
  final VoidCallback onLogout;

  const UserMainNavigationScreen({
    super.key,
    required this.userProfile,
    required this.onProfileUpdate,
    required this.onLogout,
  });

  @override
  State<UserMainNavigationScreen> createState() => _UserMainNavigationScreenState();
}

class _UserMainNavigationScreenState extends State<UserMainNavigationScreen> {
  int _currentIndex = 0;
  String _selectedCity = 'Mumbai';
  String _selectedArea = 'Mira Road';

  // Dynamic state loaded from eager cache for instant 0ms UI rendering
  List<Map<String, dynamic>> _banners = ApiService.cachedBanners;
  List<Map<String, dynamic>> _categories = ApiService.cachedCategories;
  List<Map<String, dynamic>> _refurbishedProducts = ApiService.cachedRefurbished;
  final List<UserOrder> _orders = [];

  // Selected category for Sell workflow
  String? _preselectedSellCategory;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    // 1. Silent background sync to get any admin updates without showing any progress spinner
    ApiService.syncDataInBackground().then((_) {
      if (mounted) {
        setState(() {
          _banners = ApiService.cachedBanners;
          _categories = ApiService.cachedCategories;
          _refurbishedProducts = ApiService.cachedRefurbished;
        });
      }
    });

    // 2. Fetch user orders if logged in
    if (widget.userProfile.phone.isNotEmpty) {
      ApiService.fetchOrders(phone: widget.userProfile.phone).then((fetchedOrders) {
        if (mounted && fetchedOrders.isNotEmpty) {
          setState(() {
            _orders.clear();
            for (final o in fetchedOrders) {
              _orders.add(UserOrder.fromJson(o));
            }
          });
        }
      });
    }
  }

  void _navigateToSellWithCategory(String catId) {
    setState(() {
      _preselectedSellCategory = catId;
      _currentIndex = 1;
    });
  }

  void _handleOrderCreated(UserOrder order) {
    setState(() {
      _orders.insert(0, order);
      _currentIndex = 4; // Navigate to Profile / My Orders
    });

    // Native Android Notification & In-App SnackBar
    NotificationService.triggerNotification(
      context: context,
      title: 'Order Confirmed · ${order.orderNumber}',
      message: 'Your ${order.type.toUpperCase()} request for ${order.device} has been successfully scheduled.',
      orderId: order.orderNumber,
      onTapViewOrder: () {
        setState(() => _currentIndex = 4);
      },
    );
  }

  void _openLocationPicker() {
    final cities = [
      {'name': 'Mumbai', 'areas': ['Mira Road', 'Andheri West', 'Bandra', 'Borivali', 'Thane']},
      {'name': 'Bengaluru', 'areas': ['Indiranagar', 'Koramangala', 'HSR Layout', 'Whitefield']},
      {'name': 'Delhi NCR', 'areas': ['Connaught Place', 'Gurugram CyberCity', 'Noida Sec 62']},
      {'name': 'Hyderabad', 'areas': ['HITEC City', 'Gachibowli', 'Jubilee Hills']},
      {'name': 'Pune', 'areas': ['Kothrud', 'Viman Nagar', 'Baner', 'Hinjewadi']},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(ctx).size.height * 0.65,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Select Your Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      Text('Doorstep service available in 200+ cities', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    ],
                  ),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: cities.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, idx) {
                    final c = cities[idx];
                    final cityName = c['name'] as String;
                    final areas = c['areas'] as List<String>;
                    final isSelected = _selectedCity == cityName;

                    return ExpansionTile(
                      dense: true,
                      leading: Icon(
                        Icons.location_city,
                        color: isSelected ? const Color(0xFF059669) : const Color(0xFF64748B),
                        size: 20,
                      ),
                      title: Text(
                        cityName,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          color: isSelected ? const Color(0xFF059669) : const Color(0xFF0F172A),
                        ),
                      ),
                      children: areas.map((area) {
                        return ListTile(
                          dense: true,
                          title: Text(area, style: const TextStyle(fontSize: 13)),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF94A3B8)),
                          onTap: () {
                            setState(() {
                              _selectedCity = cityName;
                              _selectedArea = area;
                            });
                            Navigator.pop(ctx);
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: AppBar(
          backgroundColor: const Color(0xFF0F172A),
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFF4F46E5), Color(0xFF2563EB)],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7C3AED).withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'CAM',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: -0.5),
                          ),
                          TextSpan(
                            text: 'SIK',
                            style: TextStyle(
                              color: Color(0xFF818CF8),
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: _openLocationPicker,
                      child: Row(
                        children: [
                          const Icon(Icons.place, color: Color(0xFF34D399), size: 12),
                          const SizedBox(width: 2),
                          Text(
                            '$_selectedArea, $_selectedCity',
                            style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                          const Icon(Icons.arrow_drop_down, color: Colors.white70, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.location_on_outlined, color: Colors.white70, size: 22),
              tooltip: 'Select Location',
              onPressed: _openLocationPicker,
            ),
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Colors.white70, size: 22),
              tooltip: 'Notifications',
              onPressed: () {
                _showNotificationsDialog();
              },
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeScreen(),
          SellWorkflowWidget(
            categories: _categories,
            preselectedCategory: _preselectedSellCategory,
            userProfile: widget.userProfile,
            onProfileUpdate: widget.onProfileUpdate,
            onOrderCreated: _handleOrderCreated,
          ),
          BuyRefurbishedWidget(
            products: _refurbishedProducts,
            userProfile: widget.userProfile,
            onProfileUpdate: widget.onProfileUpdate,
            onOrderCreated: _handleOrderCreated,
          ),
          ExchangeWorkflowWidget(
            refurbishedProducts: _refurbishedProducts,
            userProfile: widget.userProfile,
            onProfileUpdate: widget.onProfileUpdate,
            onOrderCreated: _handleOrderCreated,
          ),
          UserProfileWidget(
            profile: widget.userProfile,
            orders: _orders,
            onProfileUpdate: widget.onProfileUpdate,
            onLogout: widget.onLogout,
            onNavigateToSell: () => setState(() => _currentIndex = 1),
            onNavigateToBuy: () => setState(() => _currentIndex = 2),
          ),
        ],
      ),
      bottomNavigationBar: CamsikBottomBar(
        selectedIndex: _currentIndex,
        onItemSelected: (idx) => setState(() => _currentIndex = idx),
      ),
    );
  }

  void _showNotificationsDialog() {
    final notifs = NotificationService.inAppNotifications;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const SizedBox(height: 12),
              if (notifs.isEmpty)
                const Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_none, size: 48, color: Color(0xFF94A3B8)),
                        SizedBox(height: 12),
                        Text('No notifications yet', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: notifs.length,
                    separatorBuilder: (c, i) => const Divider(height: 1),
                    itemBuilder: (c, i) {
                      final n = notifs[i];
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFE2E8F0),
                          child: Icon(Icons.check_circle, color: Color(0xFF059669), size: 20),
                        ),
                        title: Text(n['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        subtitle: Text(n['message'] as String, style: const TextStyle(fontSize: 12)),
                        onTap: () {
                          Navigator.pop(ctx);
                          setState(() => _currentIndex = 4);
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // ── TAB 0: HOME SCREEN ──

  Widget _buildHomeScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. FULL-WIDTH INFINITE LOOPING BANNER (PROPER TOP SPACING, NEVER TOUCHING HEADER)
          Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 8),
            child: CamsikFullWidthBannerCarousel(
              banners: _banners,
              onBannerTap: (catId) => _navigateToSellWithCategory(catId),
            ),
          ),

          const SizedBox(height: 10),

          // 2. COMPACT HORIZONTAL 1-ROW ACTION HUB (SELL | BUY | EXCHANGE)
          _buildCompactHorizontalActionHub(),

          const SizedBox(height: 24),

          // 3. EXPLORE 8 TECH CATEGORIES
          _buildEightCategoriesBar(),

          const SizedBox(height: 24),

          // 4. TOP REFURBISHED DEALS
          _buildTopDealsShowcase(),

          const SizedBox(height: 24),

          // 5. CAMSIK TRUST SCORECARD
          _buildTrustScorecard(),

          const SizedBox(height: 24),

          // 6. 3-STEP RECOMMERCE WORKFLOW
          _buildHowItWorksSection(),

          const SizedBox(height: 24),

          // 7. WHY CAMSIK
          _buildWhyCamsikSection(),

          const SizedBox(height: 24),

          // 8. FAQS & GUARANTEES (FULL 10 FAQS WITH CATEGORY TABS)
          const CamsikFaqSectionWidget(),
        ],
      ),
    );
  }

  // COMPACT HORIZONTAL 1-ROW ACTION HUB: SELL | BUY | EXCHANGE
  Widget _buildCompactHorizontalActionHub() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Action 1: Sell
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _currentIndex = 1),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF059669), Color(0xFF10B981)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF059669).withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            kRupee,
                            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Sell',
                        style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w900, fontSize: 13),
                      ),
                      const Text(
                        'Instant Cash',
                        style: TextStyle(color: Color(0xFF059669), fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(width: 1, height: 48, color: const Color(0xFFE2E8F0)),
            // Action 2: Buy
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _currentIndex = 2),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 22),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Buy',
                        style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w900, fontSize: 13),
                      ),
                      const Text(
                        'Refurbished',
                        style: TextStyle(color: Color(0xFF4F46E5), fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(width: 1, height: 48, color: const Color(0xFFE2E8F0)),
            // Action 3: Exchange
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _currentIndex = 3),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(Icons.swap_horiz_rounded, color: Colors.white, size: 24),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Exchange',
                        style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w900, fontSize: 13),
                      ),
                      const Text(
                        '+$kRupee 5,000 Bonus',
                        style: TextStyle(color: Color(0xFF7C3AED), fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. 8 TECH CATEGORIES
  Widget _buildEightCategoriesBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explore Tech Categories',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                  ),
                  Text(
                    'Sell or upgrade across 8 device categories',
                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => setState(() => _currentIndex = 1),
                child: const Text('View All', style: TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 118,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _categories.length,
            itemBuilder: (ctx, idx) {
              final cat = _categories[idx];
              final catId = cat['id'] as String;
              final catName = cat['name'] as String;
              final catImg = cat['image'] as String;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: InkWell(
                  onTap: () => _navigateToSellWithCategory(catId),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 88,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Image.asset(
                              catImg,
                              fit: BoxFit.contain,
                              errorBuilder: (c, e, s) => const Icon(Icons.devices, size: 28, color: Color(0xFF059669)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          catName,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0F172A), height: 1.1),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 4. TOP REFURBISHED DEALS
  Widget _buildTopDealsShowcase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Certified Refurbished Deals',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                  ),
                  Text(
                    '45-Point certified · 12 months warranty · 90%+ battery',
                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => setState(() => _currentIndex = 2),
                child: const Text('Shop All', style: TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _refurbishedProducts.length,
            itemBuilder: (ctx, idx) {
              final p = _refurbishedProducts[idx];
              final name = p['model'] as String;
              final price = p['sellingPrice'] as int;
              final origPrice = p['originalPrice'] as int;
              final discount = p['discount'] as int;
              final battery = p['batteryHealth'] as String;
              final image = p['image'] as String;

              return Container(
                width: 170,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$discount% OFF',
                            style: const TextStyle(color: Color(0xFF059669), fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          battery,
                          style: const TextStyle(color: Color(0xFF64748B), fontSize: 9, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Center(
                        child: Image.asset(
                          image,
                          fit: BoxFit.contain,
                          errorBuilder: (c, e, s) => const Icon(Icons.devices, size: 40, color: Color(0xFF94A3B8)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          formatCurrency(price),
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF059669)),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formatCurrency(origPrice),
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Color(0xFF94A3B8),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 5. CAMSIK TRUST SCORECARD
  Widget _buildTrustScorecard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF34D399).withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.verified_user, color: Color(0xFF34D399), size: 18),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Camsik Quality & Trust Guarantee',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _buildTrustMetric('3,20,000+', 'Devices Rehomed'),
                _buildTrustMetric('4.8 / 5.0', 'Google Rating'),
                _buildTrustMetric('15 Mins', 'Spot UPI Payout'),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: Colors.white12, height: 1),
            const SizedBox(height: 12),
            const Row(
              children: [
                Icon(Icons.shield_outlined, color: Color(0xFF38BDF8), size: 16),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'DoD 5220.22-M military-grade certified data wipe on every device before handover.',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustMetric(String value, String label) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(color: Color(0xFF34D399), fontWeight: FontWeight.w900, fontSize: 16),
          ),
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)),
        ],
      ),
    );
  }

  // 6. HOW IT WORKS SECTION
  Widget _buildHowItWorksSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How Camsik ReCommerce Works',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 12),
          _buildStepCard(
            step: '01',
            title: 'Instant 60-Sec AI Valuation',
            desc: 'Select your device model, answer category-specific condition questions and get a guaranteed quote.',
            icon: Icons.speed,
            color: const Color(0xFF059669),
          ),
          const SizedBox(height: 8),
          _buildStepCard(
            step: '02',
            title: 'Free Doorstep Verification',
            desc: 'A verified Camsik camera technician visits your doorstep at your scheduled slot in 200+ cities.',
            icon: Icons.doorbell_outlined,
            color: const Color(0xFF4F46E5),
          ),
          const SizedBox(height: 8),
          _buildStepCard(
            step: '03',
            title: 'Instant Spot UPI Transfer',
            desc: 'Full payout credited directly to your bank account or UPI ID before the device leaves your hands.',
            icon: Icons.account_balance_wallet_outlined,
            color: const Color(0xFF7C3AED),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard({
    required String step,
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: Icon(icon, color: color, size: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'STEP $step $kBullet ',
                      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      title,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 7. WHY CAMSIK
  Widget _buildWhyCamsikSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Why 3.2 Lakh+ Sellers Trust Camsik',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 12),
            _buildWhyBullet('Guaranteed Best Market Price', 'AI pricing calculated from live nationwide second-hand market transactions.'),
            _buildWhyBullet('Zero Hidden Deductions', 'Transparent inspection criteria with objective condition grading.'),
            _buildWhyBullet('1-Step Doorstep Exchange', 'Seamlessly upgrade to certified refurbished devices with only net difference payable.'),
            _buildWhyBullet('Certified DoD Military Wipe', 'Permanent zero-recovery data erasure keeping your personal files 100% secure.'),
          ],
        ),
      ),
    );
  }

  Widget _buildWhyBullet(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF059669), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A))),
                Text(desc, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── FULL 10-QUESTION FAQ SECTION WITH CATEGORY FILTER (EXACT WEBSITE PARITY) ──

class CamsikFaqSectionWidget extends StatefulWidget {
  const CamsikFaqSectionWidget({super.key});

  @override
  State<CamsikFaqSectionWidget> createState() => _CamsikFaqSectionWidgetState();
}

class _CamsikFaqSectionWidgetState extends State<CamsikFaqSectionWidget> {
  String _selectedCategory = 'All Questions';

  final List<String> _categories = [
    'All Questions',
    'Selling & Valuation',
    'Buying Refurbished',
    'Exchange & Upgrade',
    'Doorstep & Privacy',
  ];

  final List<Map<String, String>> _allFaqs = [
    {
      'id': 'faq-1',
      'category': 'Selling & Valuation',
      'badge': 'AI Valuation Engine',
      'q': 'How is the resale price of my phone, laptop, or camera calculated on Camsik?',
      'a': 'Our proprietary pricing algorithm analyzes live secondary market demand across India, processor/sensor generation, physical cosmetics, battery cycle health, display condition (OLED burn-in, scratches), camera sensor health, and included original accessories to calculate the highest guaranteed payout.',
    },
    {
      'id': 'faq-2',
      'category': 'Selling & Valuation',
      'badge': 'KYC & Paperwork',
      'q': 'Do I need the original box and bill to sell my device on Camsik?',
      'a': 'No! An original bill and retail packaging are not mandatory. Having them adds a small value bonus, but you can sell your smartphone, MacBook, tablet, or camera with just a valid government photo ID (Aadhaar Card, Driving License, or Passport) for legal KYC compliance.',
    },
    {
      'id': 'faq-3',
      'category': 'Buying Refurbished',
      'badge': '45-Point Inspection',
      'q': 'What quality checks do certified refurbished devices go through?',
      'a': 'Every device undergoes a 45-point hardware inspection conducted by certified diagnostic technicians. We test touchscreen responsiveness, battery health (guaranteed 85%+), motherboard thermals, camera optics, biometric sensors (Face ID/Touch ID/Shutter), and speaker audio clarity. Defective units are rejected.',
    },
    {
      'id': 'faq-4',
      'category': 'Buying Refurbished',
      'badge': 'Warranty & Returns',
      'q': 'What warranty and return policy do I get when buying refurbished tech?',
      'a': 'All certified refurbished devices purchased from Camsik come with a 6 to 12 months comprehensive warranty covering manufacturing and hardware defects, along with a 7-day hassle-free replacement guarantee if the device fails to meet expectations.',
    },
    {
      'id': 'faq-5',
      'category': 'Exchange & Upgrade',
      'badge': '1-Step Doorstep Swap',
      'q': 'How does the 1-step device exchange process work?',
      'a': 'Select the upgraded device you want and enter the details of your old phone, laptop, or camera. We add an exclusive exchange bonus (up to $kRupee 5,000) directly to your trade-in credit. Our specialist arrives at your doorstep with your upgraded device, inspects your old gadget, and you pay only the remaining balance on the spot.',
    },
    {
      'id': 'faq-6',
      'category': 'Exchange & Upgrade',
      'badge': 'Cashback Balance',
      'q': 'What happens if my old gadget is worth more than the device I want to buy?',
      'a': 'If your trade-in valuation exceeds the cost of your selected upgrade, Camsik pays YOU the remaining balance! The technician immediately transfers the surplus cash to your UPI or bank account right at your doorstep.',
    },
    {
      'id': 'faq-7',
      'category': 'Doorstep & Privacy',
      'badge': 'DoD 5220.22-M Wipe',
      'q': 'How is my private data and photos protected before device resale?',
      'a': 'Data security is our highest priority. Before any device leaves your hands, our technician performs a certified DoD 5220.22-M military-grade data sanitization wiping all internal SSDs, storage buffers, and user accounts. You receive a digitally signed legal bill of sale and liability indemnity certificate.',
    },
    {
      'id': 'faq-8',
      'category': 'Doorstep & Privacy',
      'badge': '100% Free Doorstep',
      'q': 'Are there any pickup or cancellation fees if I decline the doorstep quote?',
      'a': 'Zero hidden fees and zero travel charges! Doorstep evaluation is 100% free across 200+ cities in India. If the final on-site quote does not meet your expectations for any reason, you can decline with zero penalty.',
    },
    {
      'id': 'faq-9',
      'category': 'Selling & Valuation',
      'badge': '7-Day Price Lock',
      'q': 'How long is my online price quote valid?',
      'a': 'Once you generate a quote on Camsik, your price is locked for 7 days. You have complete flexibility to schedule your free doorstep pickup at any convenient slot within that period without worrying about market price fluctuations.',
    },
    {
      'id': 'faq-10',
      'category': 'Doorstep & Privacy',
      'badge': 'Instant Spot Transfer',
      'q': 'When and how will I receive payment for my device?',
      'a': 'Payment is initiated immediately before the technician packs the equipment. You can choose Instant UPI (Google Pay, PhonePe, Paytm) or direct IMPS bank transfer. The technician waits until you receive the bank confirmation SMS.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedCategory == 'All Questions'
        ? _allFaqs
        : _allFaqs.where((f) => f['category'] == _selectedCategory).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF059669).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.help_outline_rounded, color: Color(0xFF059669), size: 18),
              ),
              const SizedBox(width: 8),
              const Text(
                'Frequently Asked Questions',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) setState(() => _selectedCategory = cat);
                    },
                    selectedColor: const Color(0xFF059669),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF475569),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: isSelected ? const Color(0xFF059669) : const Color(0xFFE2E8F0)),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          ...filtered.map((f) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: Color(0xFFE2E8F0))),
                child: ExpansionTile(
                  leading: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      f['badge']!,
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                    ),
                  ),
                  title: Text(f['q']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A))),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 14),
                      child: Text(f['a']!, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, height: 1.5)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ── FULL-WIDTH INFINITE LOOPING BANNER CAROUSEL WIDGET ──

class CamsikFullWidthBannerCarousel extends StatefulWidget {
  final List<Map<String, dynamic>> banners;
  final Function(String) onBannerTap;

  const CamsikFullWidthBannerCarousel({
    super.key,
    required this.banners,
    required this.onBannerTap,
  });

  @override
  State<CamsikFullWidthBannerCarousel> createState() => _CamsikFullWidthBannerCarouselState();
}

class _CamsikFullWidthBannerCarouselState extends State<CamsikFullWidthBannerCarousel> {
  late final PageController _pageController;
  int _virtualPage = 1000;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _virtualPage);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients && widget.banners.isNotEmpty) {
        _virtualPage++;
        _pageController.animateToPage(
          _virtualPage,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();

    final actualCount = widget.banners.length;
    final currentActualIndex = _virtualPage % actualCount;

    return Column(
      children: [
        // FULL WIDTH CONTAINER (Edge-to-Edge)
        SizedBox(
          height: 195,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (page) {
              setState(() {
                _virtualPage = page;
              });
            },
            itemBuilder: (ctx, index) {
              final banner = widget.banners[index % actualCount];
              final catId = banner['categoryFilter'] as String? ?? 'cat-smartphone';
              final badge = banner['badge'] as String? ?? 'CAMSIK RECOMMERCE';
              final titlePrefix = banner['titlePrefix'] as String? ?? 'Sell ';
              final titleHighlight = banner['titleHighlight'] as String? ?? 'Devices';
              final desc = banner['description'] as String? ?? '';
              final ctaText = banner['ctaText'] as String? ?? 'Check Price';
              final image = banner['image'] as String? ?? 'assets/images/categories/smartphone.png';

              return Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Text Column
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              badge,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF38BDF8),
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          RichText(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: titlePrefix,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14),
                                ),
                                TextSpan(
                                  text: titleHighlight,
                                  style: const TextStyle(color: Color(0xFF34D399), fontWeight: FontWeight.w900, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            desc,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white70, fontSize: 10, height: 1.25),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF059669),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  minimumSize: const Size(0, 28),
                                  elevation: 2,
                                ),
                                onPressed: () => widget.onBannerTap(catId),
                                child: Text(
                                  ctaText,
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Row(
                                children: [
                                  Icon(Icons.local_shipping, size: 11, color: Color(0xFF34D399)),
                                  SizedBox(width: 3),
                                  Text(
                                    'Free Pickup',
                                    style: TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Image Column
                    Expanded(
                      flex: 2,
                      child: Image.asset(
                        image,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stack) => const Icon(Icons.devices, color: Colors.white70, size: 48),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            actualCount,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: currentActualIndex == i ? 18 : 6,
              height: 5,
              decoration: BoxDecoration(
                color: currentActualIndex == i ? const Color(0xFF059669) : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── TAB 1: SELL WORKFLOW (DYNAMIC CATEGORIES, MODELS, QUESTIONS & QUOTE) ──

class SellWorkflowWidget extends StatefulWidget {
  final List<Map<String, dynamic>> categories;
  final String? preselectedCategory;
  final UserProfile userProfile;
  final Function(UserProfile) onProfileUpdate;
  final Function(UserOrder) onOrderCreated;

  const SellWorkflowWidget({
    super.key,
    required this.categories,
    this.preselectedCategory,
    required this.userProfile,
    required this.onProfileUpdate,
    required this.onOrderCreated,
  });

  @override
  State<SellWorkflowWidget> createState() => _SellWorkflowWidgetState();
}

class _SellWorkflowWidgetState extends State<SellWorkflowWidget> {
  int _step = 0; // 0: Category, 1: Brand/Model, 2: Variant, 3: Questions, 4: Summary, 5: Pickup Slot
  late Map<String, dynamic> _selectedCategory;
  List<Map<String, dynamic>> _models = [];
  Map<String, dynamic>? _selectedModel;
  String _selectedStorage = 'Body Only';
  String _selectedColor = 'Black';

  // Dynamic Questions from backend
  List<Map<String, dynamic>> _questions = [];
  final Map<int, int> _selectedAnswers = {}; // questionIndex -> optionIndex

  int _basePrice = 58000;
  int _calculatedPrice = 58000;

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _upiController = TextEditingController();
  String _selectedSlot = '11:00 AM – 1:00 PM';
  String _selectedDate = 'Tomorrow';

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.categories.firstWhere(
      (c) => c['id'] == widget.preselectedCategory,
      orElse: () => widget.categories.isNotEmpty ? widget.categories.first : {'id': 'cat-dslr', 'name': 'DSLR & Mirrorless'},
    );
    _addressController.text = widget.userProfile.address;
    _upiController.text = widget.userProfile.upiId;
    _loadModelsForCategory(_selectedCategory['id'] as String);
  }

  void _loadModelsForCategory(String catId) {
    final syncModels = ApiService.getFallbackModelsSync(categoryId: catId);
    final syncQuestions = ApiService.getQuestionsSync(categoryId: catId);
    setState(() {
      _models = syncModels;
      _questions = syncQuestions;
      _selectedAnswers.clear();
      for (int i = 0; i < _questions.length; i++) {
        _selectedAnswers[i] = 0;
      }
    });
    _recalculatePrice();

    // Silent background fetch to update if online
    ApiService.fetchModels(categoryId: catId).then((models) {
      if (mounted && models.isNotEmpty) {
        setState(() => _models = models);
      }
    });
    ApiService.fetchQuestions(categoryId: catId).then((questions) {
      if (mounted && questions.isNotEmpty) {
        setState(() {
          _questions = questions;
          _selectedAnswers.clear();
          for (int i = 0; i < _questions.length; i++) {
            _selectedAnswers[i] = 0;
          }
        });
        _recalculatePrice();
      }
    });
  }

  void _recalculatePrice() {
    int price = _basePrice;
    for (int qIdx = 0; qIdx < _questions.length; qIdx++) {
      final optIdx = _selectedAnswers[qIdx] ?? 0;
      final options = _questions[qIdx]['options'] as List?;
      if (options != null && optIdx < options.length) {
        final adj = (options[optIdx]['adj'] as num?)?.toInt() ?? 0;
        price += adj;
      }
    }
    setState(() {
      _calculatedPrice = price > 3000 ? price : 3000;
    });
  }

  void _handleConfirmSellOrder() async {
    final orderData = {
      'type': 'sell',
      'customerName': widget.userProfile.name,
      'customerPhone': widget.userProfile.phone,
      'customerAddress': _addressController.text.trim(),
      'pickupDate': _selectedDate,
      'pickupSlot': _selectedSlot,
      'paymentMethod': 'Instant UPI (${_upiController.text.trim()})',
      'amount': _calculatedPrice,
      'deviceName': '${_selectedModel?['name'] ?? 'Device'} ($_selectedStorage)',
      'status': 'Order Placed',
    };

    final created = await ApiService.createOrder(orderData);
    if (created != null && mounted) {
      final userOrder = UserOrder.fromJson(created);
      widget.onOrderCreated(userOrder);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 1,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getStepTitle(),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            if (_step > 0)
              Text(
                '${_selectedCategory['name']}${_selectedModel != null ? ' > ${_selectedModel!['name']}' : ''}',
                style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
              ),
          ],
        ),
        leading: _step > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _step--),
              )
            : null,
      ),
      body: _buildStepContent(),
    );
  }

  String _getStepTitle() {
    switch (_step) {
      case 0:
        return 'Step 1 of 6: Select Category';
      case 1:
        return 'Step 2 of 6: Select Device Model';
      case 2:
        return 'Step 3 of 6: Storage & Variant';
      case 3:
        return 'Step 4 of 6: Device Condition';
      case 4:
        return 'Step 5 of 6: Valuation Summary';
      case 5:
        return 'Step 6 of 6: Schedule Pickup';
      default:
        return 'Sell Device';
    }
  }

  Widget _buildStepContent() {
    switch (_step) {
      case 0:
        return _buildCategoryStep();
      case 1:
        return _buildModelStep();
      case 2:
        return _buildVariantStep();
      case 3:
        return _buildQuestionsStep();
      case 4:
        return _buildSummaryStep();
      case 5:
        return _buildPickupStep();
      default:
        return _buildCategoryStep();
    }
  }

  // Step 0: Category
  Widget _buildCategoryStep() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.15,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: widget.categories.length,
      itemBuilder: (ctx, idx) {
        final cat = widget.categories[idx];
        return InkWell(
          onTap: () {
            setState(() {
              _selectedCategory = cat;
              _step = 1;
            });
            _loadModelsForCategory(cat['id'] as String);
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2)),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.asset(
                    cat['image'] as String,
                    fit: BoxFit.contain,
                    errorBuilder: (c, e, s) => const Icon(Icons.devices, size: 36, color: Color(0xFF059669)),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  cat['name'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Step 1: Model with REAL MODEL IMAGES
  Widget _buildModelStep() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _models.length,
      separatorBuilder: (c, i) => const SizedBox(height: 10),
      itemBuilder: (ctx, idx) {
        final m = _models[idx];
        final name = m['name'] as String;
        final brand = m['brand'] as String? ?? '';
        final basePrice = (m['basePrice'] as num?)?.toInt() ?? 50000;
        final image = m['image'] as String? ?? 'assets/images/categories/dslr.png';
        final specs = m['specs'] as String? ?? '';

        return InkWell(
          onTap: () {
            setState(() {
              _selectedModel = m;
              _basePrice = basePrice;
              final storages = m['storages'] as List?;
              if (storages != null && storages.isNotEmpty) {
                _selectedStorage = storages.first as String;
              }
              final colors = m['colors'] as List?;
              if (colors != null && colors.isNotEmpty) {
                _selectedColor = colors.first as String;
              }
              _step = 2;
            });
            _recalculatePrice();
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                // Real Model Image
                Container(
                  width: 60,
                  height: 60,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                    image,
                    fit: BoxFit.contain,
                    errorBuilder: (c, e, s) => const Icon(Icons.devices, size: 30, color: Color(0xFF94A3B8)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                      ),
                      if (brand.isNotEmpty)
                        Text(brand, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                      if (specs.isNotEmpty)
                        Text(
                          specs,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Up to', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                    Text(
                      formatCurrency(basePrice),
                      style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF059669), fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Step 2: Variant & Configuration
  Widget _buildVariantStep() {
    final storages = (_selectedModel?['storages'] as List?)?.cast<String>() ?? ['Standard'];
    final colors = (_selectedModel?['colors'] as List?)?.cast<String>() ?? ['Standard Color'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Image.asset(
                  _selectedModel?['image'] as String? ?? 'assets/images/categories/dslr.png',
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => const Icon(Icons.devices, size: 32, color: Color(0xFF94A3B8)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedModel?['name'] as String? ?? '',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    Text(
                      'Base Valuation: ${formatCurrency(_basePrice)}',
                      style: const TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Select Storage / Configuration:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: storages.map((s) {
              final isSel = _selectedStorage == s;
              return ChoiceChip(
                label: Text(s),
                selected: isSel,
                onSelected: (val) => setState(() => _selectedStorage = s),
                selectedColor: const Color(0xFF059669),
                labelStyle: TextStyle(color: isSel ? Colors.white : const Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 12),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const Text('Select Color:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: colors.map((c) {
              final isSel = _selectedColor == c;
              return ChoiceChip(
                label: Text(c),
                selected: isSel,
                onSelected: (val) => setState(() => _selectedColor = c),
                selectedColor: const Color(0xFF059669),
                labelStyle: TextStyle(color: isSel ? Colors.white : const Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 12),
              );
            }).toList(),
          ),
          const SizedBox(height: 36),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => setState(() => _step = 3),
              child: const Text('Proceed to Diagnostic Questions', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // Step 3: Category-Specific Diagnostic Questions
  Widget _buildQuestionsStep() {
    return Column(
      children: [
        // Live Price Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          color: const Color(0xFF0F172A),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Estimated Payout:', style: TextStyle(color: Colors.white70, fontSize: 12)),
              Text(
                formatCurrency(_calculatedPrice),
                style: const TextStyle(color: Color(0xFF34D399), fontWeight: FontWeight.w900, fontSize: 18),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _questions.length,
            separatorBuilder: (c, i) => const SizedBox(height: 16),
            itemBuilder: (ctx, qIdx) {
              final q = _questions[qIdx];
              final qText = q['question'] as String;
              final options = (q['options'] as List?)?.cast<Map<String, dynamic>>() ?? [];
              final selectedOptIdx = _selectedAnswers[qIdx] ?? 0;

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${qIdx + 1}. $qText',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 10),
                    ...List.generate(options.length, (optIdx) {
                      final opt = options[optIdx];
                      final label = opt['label'] as String;
                      final sublabel = opt['sublabel'] as String? ?? '';
                      final adj = (opt['adj'] as num?)?.toInt() ?? 0;
                      final isSelected = selectedOptIdx == optIdx;

                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedAnswers[qIdx] = optIdx;
                          });
                          _recalculatePrice();
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF059669).withValues(alpha: 0.08) : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: isSelected ? const Color(0xFF059669) : const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                size: 16,
                                color: isSelected ? const Color(0xFF059669) : const Color(0xFF94A3B8),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                    if (sublabel.isNotEmpty)
                                      Text(sublabel, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                                  ],
                                ),
                              ),
                              if (adj != 0)
                                Text(
                                  adj > 0 ? '+${formatCurrency(adj)}' : '-${formatCurrency(adj.abs())}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: adj > 0 ? const Color(0xFF059669) : const Color(0xFFEF4444),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => setState(() => _step = 4),
              child: const Text('View Final Quote Summary', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }

  // Step 4: Summary Breakdown
  Widget _buildSummaryStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text('Guaranteed Instant Payout Quote', style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 6),
                Text(
                  formatCurrency(_calculatedPrice),
                  style: const TextStyle(color: Color(0xFF34D399), fontWeight: FontWeight.w900, fontSize: 32),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_selectedModel?['name']} ($_selectedStorage, $_selectedColor)',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Valuation Breakdown:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                _buildBreakdownRow('Base Market Value', formatCurrency(_basePrice), isNeutral: true),
                const Divider(height: 16),
                ...List.generate(_questions.length, (qIdx) {
                  final optIdx = _selectedAnswers[qIdx] ?? 0;
                  final options = _questions[qIdx]['options'] as List?;
                  if (options == null || optIdx >= options.length) return const SizedBox.shrink();
                  final opt = options[optIdx];
                  final label = opt['label'] as String;
                  final adj = (opt['adj'] as num?)?.toInt() ?? 0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
                          ),
                        ),
                        Text(
                          adj == 0
                              ? '$kRupee 0'
                              : adj > 0
                                  ? '+${formatCurrency(adj)}'
                                  : '-${formatCurrency(adj.abs())}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: adj > 0
                                ? const Color(0xFF059669)
                                : adj < 0
                                    ? const Color(0xFFEF4444)
                                    : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const Divider(height: 16),
                _buildBreakdownRow('Final Handover Cash', formatCurrency(_calculatedPrice), isHighlight: true),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => setState(() => _step = 5),
              child: const Text('Schedule Doorstep Handover', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(String label, String value, {bool isNeutral = false, bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isHighlight ? 13 : 12,
            fontWeight: isHighlight ? FontWeight.w900 : FontWeight.w600,
            color: isHighlight ? const Color(0xFF0F172A) : const Color(0xFF475569),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isHighlight ? 15 : 12,
            fontWeight: isHighlight ? FontWeight.w900 : FontWeight.bold,
            color: isHighlight ? const Color(0xFF059669) : const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  // Step 5: Pickup Details & Slots
  Widget _buildPickupStep() {
    final dates = ['Today', 'Tomorrow', 'Day After Tomorrow'];
    final slots = [
      '9:00 AM – 11:00 AM',
      '11:00 AM – 1:00 PM',
      '1:00 PM – 3:00 PM',
      '3:00 PM – 5:00 PM',
      '5:00 PM – 7:00 PM',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pickup Date:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: dates.map((d) {
              final isSel = _selectedDate == d;
              return ChoiceChip(
                label: Text(d),
                selected: isSel,
                onSelected: (v) => setState(() => _selectedDate = d),
                selectedColor: const Color(0xFF059669),
                labelStyle: TextStyle(color: isSel ? Colors.white : const Color(0xFF0F172A), fontSize: 11, fontWeight: FontWeight.bold),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Preferred Time Slot:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: slots.map((s) {
              final isSel = _selectedSlot == s;
              return ChoiceChip(
                label: Text(s),
                selected: isSel,
                onSelected: (v) => setState(() => _selectedSlot = s),
                selectedColor: const Color(0xFF059669),
                labelStyle: TextStyle(color: isSel ? Colors.white : const Color(0xFF0F172A), fontSize: 11, fontWeight: FontWeight.bold),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text('Pickup Address:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          TextField(
            controller: _addressController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Enter complete flat, street and pincode',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Payment UPI ID:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          TextField(
            controller: _upiController,
            decoration: InputDecoration(
              hintText: 'e.g. mobile@upi or gpay',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
            ),
          ),
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
              onPressed: _handleConfirmSellOrder,
              child: const Text('Confirm Doorstep Pickup Booking', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── TAB 2: BUY REFURBISHED WIDGET (WITH MULTI-UNIT LIVE SELECTOR) ──

class BuyRefurbishedWidget extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  final UserProfile userProfile;
  final Function(UserProfile) onProfileUpdate;
  final Function(UserOrder) onOrderCreated;

  const BuyRefurbishedWidget({
    super.key,
    required this.products,
    required this.userProfile,
    required this.onProfileUpdate,
    required this.onOrderCreated,
  });

  @override
  State<BuyRefurbishedWidget> createState() => _BuyRefurbishedWidgetState();
}

class _BuyRefurbishedWidgetState extends State<BuyRefurbishedWidget> {
  String _selectedCategory = 'all';
  String _selectedCondition = 'all';
  String _searchQuery = '';
  Map<String, dynamic>? _activeDetailProduct;
  int _selectedUnitIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (_activeDetailProduct != null) {
      return _buildProductDetailView();
    }

    var filtered = widget.products;
    if (_selectedCategory != 'all') {
      filtered = filtered.where((p) => (p['category'] as String).toLowerCase() == _selectedCategory.toLowerCase()).toList();
    }
    if (_selectedCondition != 'all') {
      filtered = filtered.where((p) => (p['condition'] as String).toLowerCase() == _selectedCondition.toLowerCase()).toList();
    }
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase().trim();
      filtered = filtered.where((p) =>
        (p['model'] as String).toLowerCase().contains(q) ||
        (p['brand'] as String).toLowerCase().contains(q)
      ).toList();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 1,
        title: const Text('Buy Certified Refurbished', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Search & Filter Bar
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search iPhone, MacBook, Canon, Sony...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    filled: true,
                    fillColor: const Color(0xFFF1F5F9),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryChip('all', 'All Categories'),
                      _buildCategoryChip('smartphones', 'Smartphones'),
                      _buildCategoryChip('cameras', 'Cameras'),
                      _buildCategoryChip('laptops', 'Laptops'),
                      _buildCategoryChip('tablets', 'Tablets'),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildConditionChip('all', 'All Conditions'),
                      _buildConditionChip('superb', 'Superb (Like New)'),
                      _buildConditionChip('good', 'Good Condition'),
                      _buildConditionChip('fair', 'Fair Condition'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('No devices found matching your criteria.'))
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (ctx, idx) {
                      final p = filtered[idx];
                      final name = p['model'] as String;
                      final price = p['sellingPrice'] as int;
                      final origPrice = p['originalPrice'] as int;
                      final battery = p['batteryHealth'] as String;
                      final condition = p['condition'] as String;
                      final image = p['image'] as String;
                      final units = (p['availableUnits'] as List?) ?? [];

                      return InkWell(
                        onTap: () {
                          setState(() {
                            _activeDetailProduct = p;
                            _selectedUnitIndex = 0;
                          });
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(10),
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
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEDE9FE),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      condition,
                                      style: const TextStyle(color: Color(0xFF6D28D9), fontSize: 9, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    '${units.length} Units',
                                    style: const TextStyle(color: Color(0xFF059669), fontSize: 9, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Expanded(
                                child: Center(
                                  child: Image.asset(
                                    image,
                                    fit: BoxFit.contain,
                                    errorBuilder: (c, e, s) => const Icon(Icons.devices, size: 36, color: Color(0xFF94A3B8)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A)),
                              ),
                              Text(
                                battery,
                                style: const TextStyle(color: Color(0xFF64748B), fontSize: 10),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    formatCurrency(price),
                                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF059669)),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    formatCurrency(origPrice),
                                    style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: Color(0xFF94A3B8),
                                      fontSize: 9,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String val, String label) {
    final isSel = _selectedCategory == val;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(label),
        selected: isSel,
        onSelected: (s) => setState(() => _selectedCategory = val),
        selectedColor: const Color(0xFF059669),
        labelStyle: TextStyle(
          color: isSel ? Colors.white : const Color(0xFF0F172A),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildConditionChip(String val, String label) {

    final isSel = _selectedCondition == val;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(label),
        selected: isSel,
        onSelected: (s) => setState(() => _selectedCondition = val),
        selectedColor: const Color(0xFF4F46E5),
        labelStyle: TextStyle(
          color: isSel ? Colors.white : const Color(0xFF0F172A),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // PRODUCT DETAIL VIEW WITH SAME-PAGE MULTIPLE UNITS SELECTOR
  Widget _buildProductDetailView() {
    final p = _activeDetailProduct!;
    final units = (p['availableUnits'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final activeUnit = units.isNotEmpty && _selectedUnitIndex < units.length
        ? units[_selectedUnitIndex]
        : <String, dynamic>{};

    final currentPrice = (activeUnit['price'] as num?)?.toInt() ?? (p['sellingPrice'] as int);
    final currentBattery = activeUnit['batteryHealth'] as String? ?? (p['batteryHealth'] as String);
    final gallery = (p['gallery'] as List?)?.cast<String>() ?? [p['image'] as String];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 1,
        title: Text(p['model'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => _activeDetailProduct = null),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gallery
            SizedBox(
              height: 200,
              child: PageView.builder(
                itemCount: gallery.length,
                itemBuilder: (c, i) => Center(
                  child: Image.asset(
                    gallery[i],
                    fit: BoxFit.contain,
                    errorBuilder: (ctx, e, s) => const Icon(Icons.devices, size: 60, color: Color(0xFF94A3B8)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              p['model'] as String,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 4),
            Text(
              p['specs'] as String? ?? '',
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  formatCurrency(currentPrice),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF059669)),
                ),
                const SizedBox(width: 8),
                Text(
                  formatCurrency(p['originalPrice'] as int),
                  style: const TextStyle(decoration: TextDecoration.lineThrough, color: Color(0xFF94A3B8), fontSize: 14),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    '${p['discount']}% OFF',
                    style: const TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // MULTIPLE UNITS SELECTOR ON SAME PAGE (Section 20 & 21)
            const Text('Select Tracked Available Unit:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 8),
            ...List.generate(units.length, (uIdx) {
              final u = units[uIdx];
              final isSel = _selectedUnitIndex == uIdx;
              final uNote = u['note'] as String? ?? 'Unit ${uIdx + 1}';
              final uPrice = (u['price'] as num?)?.toInt() ?? currentPrice;

              return InkWell(
                onTap: () => setState(() => _selectedUnitIndex = uIdx),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSel ? const Color(0xFF059669).withValues(alpha: 0.06) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isSel ? const Color(0xFF059669) : const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSel ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: isSel ? const Color(0xFF059669) : const Color(0xFF94A3B8),
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(uNote, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            Text('Battery / Health: $currentBattery', style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                          ],
                        ),
                      ),
                      Text(
                        formatCurrency(uPrice),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF059669), fontSize: 13),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            // Inspection Scorecard
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.verified, color: Color(0xFF059669), size: 16),
                      SizedBox(width: 6),
                      Text('45-Point Hardware Diagnostics Passed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('✓ OLED / Retinal Panel: 100% Passed\n✓ TrueTone & 120Hz ProMotion: Verified\n✓ Battery Longevity: Verified Operational\n✓ Cameras & OIS Stabilization: 100% Tested\n✓ 12-Month Camsik Comprehensive Warranty Included',
                    style: TextStyle(fontSize: 11, color: Color(0xFF475569), height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                ),
                onPressed: () => _handleBuyCheckout(currentPrice),
                child: const Text('Proceed to Instant Checkout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleBuyCheckout(int finalPrice) async {
    final orderData = {
      'type': 'buy',
      'customerName': widget.userProfile.name,
      'customerPhone': widget.userProfile.phone,
      'customerAddress': widget.userProfile.address,
      'amount': finalPrice,
      'deviceName': 'Refurbished ${_activeDetailProduct!['model']}',
      'status': 'Order Placed',
      'paymentMethod': 'Prepaid / Online UPI',
    };

    final created = await ApiService.createOrder(orderData);
    if (created != null && mounted) {
      setState(() => _activeDetailProduct = null);
      widget.onOrderCreated(UserOrder.fromJson(created));
    }
  }
}

// ── TAB 3: EXCHANGE WORKFLOW (OLD VALUATION + NEW PRODUCT + DIFFERENCE) ──

class ExchangeWorkflowWidget extends StatefulWidget {
  final List<Map<String, dynamic>> refurbishedProducts;
  final UserProfile userProfile;
  final Function(UserProfile) onProfileUpdate;
  final Function(UserOrder) onOrderCreated;

  const ExchangeWorkflowWidget({
    super.key,
    required this.refurbishedProducts,
    required this.userProfile,
    required this.onProfileUpdate,
    required this.onOrderCreated,
  });

  @override
  State<ExchangeWorkflowWidget> createState() => _ExchangeWorkflowWidgetState();
}

class _ExchangeWorkflowWidgetState extends State<ExchangeWorkflowWidget> {
  // Steps: 0: select-old, 1: condition, 2: select-new, 3: product-detail, 4: checkout, 5: confirmed
  int _step = 0;

  // Step 0: Trade-in Old Device
  String _oldCategoryFilter = 'all';
  String _oldSearchQuery = '';
  List<Map<String, dynamic>> _tradeInDevices = [];
  Map<String, dynamic>? _selectedOldDevice;

  // Step 1: Diagnostics & Valuation
  List<Map<String, dynamic>> _questions = [];
  final Map<int, int> _selectedAnswers = {};
  int _oldBaseValue = 48000;
  int _calculatedOldValue = 45000;
  final int _exchangeBonus = 5000; // Guaranteed Camsik exchange bonus

  // Step 2: Browse Upgrade Catalog
  String _newCategoryFilter = 'all';
  String _newSearchQuery = '';

  // Step 3: Product Detail View
  Map<String, dynamic>? _selectedNewDevice;
  String _selectedCondition = 'Superb';
  int _selectedUnitIndex = 0;

  // Step 4: Checkout, Coupons & Address
  String? _appliedCouponCode;
  int _couponDiscount = 0;
  final TextEditingController _couponController = TextEditingController();
  String _selectedDate = 'Tomorrow';
  String _selectedSlot = '10:00 AM – 1:00 PM';
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _pincodeController;
  bool _isPlacingOrder = false;

  // Step 5: Confirmed Order
  UserOrder? _confirmedOrder;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userProfile.name);
    _phoneController = TextEditingController(text: widget.userProfile.phone);
    _addressController = TextEditingController(text: widget.userProfile.address);
    _cityController = TextEditingController(text: 'Mumbai');
    _pincodeController = TextEditingController(text: '401107');
    _loadTradeInDevices();
  }

  @override
  void dispose() {
    _couponController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _loadTradeInDevices() {
    final allModels = ApiService.getFallbackModelsSync();
    setState(() {
      _tradeInDevices = allModels;
    });
  }

  void _recalcOldValue() {
    int val = _oldBaseValue;
    for (int qIdx = 0; qIdx < _questions.length; qIdx++) {
      final optIdx = _selectedAnswers[qIdx] ?? 0;
      final options = _questions[qIdx]['options'] as List?;
      if (options != null && optIdx < options.length) {
        final adj = (options[optIdx]['adj'] as num?)?.toInt() ?? 0;
        val += adj;
      }
    }
    setState(() {
      _calculatedOldValue = val > 4000 ? val : 4000;
    });
  }

  int _getAdjustedNewDevicePrice() {
    final basePrice = (_selectedNewDevice?['sellingPrice'] as int?) ?? 70000;
    if (_selectedCondition == 'Good') return (basePrice * 0.92).toInt();
    if (_selectedCondition == 'Fair') return (basePrice * 0.85).toInt();
    return basePrice;
  }

  void _applyCoupon(String code) {
    final c = code.trim().toUpperCase();
    if (c == 'CAMSIK500') {
      setState(() {
        _appliedCouponCode = c;
        _couponDiscount = 500;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coupon CAMSIK500 applied! \u20B9500 extra discount.'), backgroundColor: Color(0xFF059669)),
      );
    } else if (c == 'UPGRADE1000') {
      setState(() {
        _appliedCouponCode = c;
        _couponDiscount = 1000;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coupon UPGRADE1000 applied! \u20B91,000 extra discount.'), backgroundColor: Color(0xFF059669)),
      );
    } else if (c == 'FESTIVE1500') {
      setState(() {
        _appliedCouponCode = c;
        _couponDiscount = 1500;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coupon FESTIVE1500 applied! \u20B91,500 extra discount.'), backgroundColor: Color(0xFF059669)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid coupon code. Try CAMSIK500 or UPGRADE1000.'), backgroundColor: Color(0xFFDC2626)),
      );
    }
  }

  void _handleConfirmExchange() async {
    final newPrice = _getAdjustedNewDevicePrice();
    final totalTradeIn = _calculatedOldValue + _exchangeBonus;
    final netDiff = newPrice - totalTradeIn - _couponDiscount;
    final netPayable = netDiff > 0 ? netDiff : 0;

    setState(() => _isPlacingOrder = true);

    final orderData = {
      'type': 'exchange',
      'customerName': _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : widget.userProfile.name,
      'customerPhone': _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : widget.userProfile.phone,
      'customerAddress': '${_addressController.text.trim()}, ${_cityController.text.trim()} - ${_pincodeController.text.trim()}',
      'pickupDate': _selectedDate,
      'pickupSlot': _selectedSlot,
      'amount': netPayable,
      'deviceName': '${_selectedOldDevice?['name']} ➔ ${_selectedNewDevice?['model']}',
      'status': 'Exchange Confirmed',
      'paymentMethod': netDiff <= 0 ? 'Cashback Disbursal via UPI' : 'Doorstep Swap (Cash / UPI)',
    };

    final created = await ApiService.createOrder(orderData);
    if (!mounted) return;
    setState(() => _isPlacingOrder = false);

    final order = UserOrder.fromJson(created ?? orderData);
    widget.onOrderCreated(order);

    setState(() {
      _confirmedOrder = order;
      _step = 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 1,
        title: Text(_getStepTitle(), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        leading: _step > 0 && _step < 5
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _step--),
              )
            : null,
      ),
      body: _buildStepContent(),
    );
  }

  String _getStepTitle() {
    switch (_step) {
      case 0:
        return 'Step 1 of 5: Select Old Device';
      case 1:
        return 'Step 2 of 5: Old Device Condition';
      case 2:
        return 'Step 3 of 5: Select Upgrade Device';
      case 3:
        return 'Step 4 of 5: Upgrade Details';
      case 4:
        return 'Step 5 of 5: Exchange Checkout';
      case 5:
        return '1-Step Exchange Confirmed';
      default:
        return 'Device Exchange';
    }
  }

  Widget _buildStepContent() {
    switch (_step) {
      case 0:
        return _buildSelectOldStep();
      case 1:
        return _buildOldQuestionsStep();
      case 2:
        return _buildSelectNewStep();
      case 3:
        return _buildProductDetailStep();
      case 4:
        return _buildCheckoutStep();
      case 5:
        return _buildConfirmedStep();
      default:
        return _buildSelectOldStep();
    }
  }

  // ── STEP 0: SELECT OLD DEVICE ──
  Widget _buildSelectOldStep() {
    final catList = [
      {'id': 'all', 'label': 'All Devices'},
      {'id': 'cat-dslr', 'label': 'Cameras'},
      {'id': 'cat-lens', 'label': 'Lenses'},
      {'id': 'cat-smartphone', 'label': 'Smartphones'},
      {'id': 'cat-laptop', 'label': 'Laptops'},
    ];

    var filtered = _tradeInDevices;
    if (_oldCategoryFilter != 'all') {
      filtered = filtered.where((d) => (d['categoryId'] as String? ?? '').toLowerCase() == _oldCategoryFilter.toLowerCase()).toList();
    }
    if (_oldSearchQuery.trim().isNotEmpty) {
      final q = _oldSearchQuery.toLowerCase().trim();
      filtered = filtered.where((d) =>
        (d['name'] as String? ?? '').toLowerCase().contains(q) ||
        (d['brand'] as String? ?? '').toLowerCase().contains(q)
      ).toList();
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.white,
          child: Column(
            children: [
              TextField(
                onChanged: (v) => setState(() => _oldSearchQuery = v),
                decoration: InputDecoration(
                  hintText: 'Search old iPhone, Sony A7, Canon, MacBook...',
                  prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF64748B)),
                  filled: true,
                  fillColor: const Color(0xFFF1F5F9),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: catList.map((cat) {
                    final isSel = _oldCategoryFilter == cat['id'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(cat['label']!),
                        selected: isSel,
                        onSelected: (val) {
                          if (val) setState(() => _oldCategoryFilter = cat['id']!);
                        },
                        selectedColor: const Color(0xFF7C3AED),
                        labelStyle: TextStyle(
                          color: isSel ? Colors.white : const Color(0xFF0F172A),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            separatorBuilder: (c, i) => const SizedBox(height: 10),
            itemBuilder: (ctx, idx) {
              final d = filtered[idx];
              final name = d['name'] as String? ?? 'Device';
              final base = (d['basePrice'] as num?)?.toInt() ?? 45000;
              final image = d['image'] as String? ?? 'assets/images/categories/dslr.png';
              final specs = d['specs'] as String? ?? 'Verified hardware valuation';

              return InkWell(
                onTap: () {
                  final catId = d['categoryId'] as String? ?? 'cat-dslr';
                  final questions = ApiService.getQuestionsSync(categoryId: catId);
                  setState(() {
                    _selectedOldDevice = d;
                    _oldBaseValue = base;
                    _questions = questions;
                    _selectedAnswers.clear();
                    for (int i = 0; i < _questions.length; i++) {
                      _selectedAnswers[i] = 0;
                    }
                    _step = 1;
                  });
                  _recalcOldValue();
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12)),
                        child: Image.asset(image, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.devices, size: 28, color: Color(0xFF7C3AED))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                            const SizedBox(height: 2),
                            Text(specs, style: const TextStyle(color: Color(0xFF64748B), fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text('Base: ${formatCurrency(base)}', style: const TextStyle(color: Color(0xFF059669), fontSize: 11, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(6)),
                                  child: const Text('+$kRupee 5,000 Bonus', style: TextStyle(color: Color(0xFF7C3AED), fontSize: 9, fontWeight: FontWeight.w900)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF94A3B8)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── STEP 1: OLD DEVICE CONDITION & DIAGNOSTICS ──
  Widget _buildOldQuestionsStep() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3B0764), Color(0xFF1E1B4B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_selectedOldDevice?['name'] ?? 'Old Device', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  const Text('Valuation + $kRupee 5,000 Exchange Bonus', style: TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
              Text(
                formatCurrency(_calculatedOldValue + _exchangeBonus),
                style: const TextStyle(color: Color(0xFFC084FC), fontWeight: FontWeight.w900, fontSize: 20),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _questions.length,
            separatorBuilder: (c, i) => const SizedBox(height: 14),
            itemBuilder: (ctx, qIdx) {
              final q = _questions[qIdx];
              final options = (q['options'] as List?)?.cast<Map<String, dynamic>>() ?? [];
              final sel = _selectedAnswers[qIdx] ?? 0;

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${qIdx + 1}. ${q['question']}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 10),
                    ...List.generate(options.length, (optIdx) {
                      final opt = options[optIdx];
                      final isSel = sel == optIdx;
                      final adj = (opt['adj'] as num?)?.toInt() ?? 0;

                      return InkWell(
                        onTap: () {
                          setState(() => _selectedAnswers[qIdx] = optIdx);
                          _recalcOldValue();
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSel ? const Color(0xFF7C3AED).withValues(alpha: 0.08) : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: isSel ? const Color(0xFF7C3AED) : const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSel ? Icons.radio_button_checked : Icons.radio_button_off,
                                size: 16,
                                color: isSel ? const Color(0xFF7C3AED) : const Color(0xFF94A3B8),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(opt['label'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                              ),
                              if (adj != 0)
                                Text(
                                  adj > 0 ? '+${formatCurrency(adj)}' : '-${formatCurrency(adj.abs())}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: adj > 0 ? const Color(0xFF059669) : const Color(0xFFEF4444),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 3,
              ),
              onPressed: () => setState(() => _step = 2),
              child: const Text('Next: Choose Upgrade Device', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ),
      ],
    );
  }

  // ── STEP 2: SELECT UPGRADE REFURBISHED DEVICE ──
  Widget _buildSelectNewStep() {
    final catList = [
      {'id': 'all', 'label': 'All Upgrades'},
      {'id': 'cameras', 'label': 'Cameras'},
      {'id': 'lenses', 'label': 'Lenses'},
      {'id': 'smartphones', 'label': 'Smartphones'},
      {'id': 'laptops', 'label': 'Laptops'},
    ];

    var filtered = widget.refurbishedProducts;
    if (_newCategoryFilter != 'all') {
      filtered = filtered.where((p) => (p['category'] as String? ?? '').toLowerCase() == _newCategoryFilter.toLowerCase()).toList();
    }
    if (_newSearchQuery.trim().isNotEmpty) {
      final q = _newSearchQuery.toLowerCase().trim();
      filtered = filtered.where((p) =>
        (p['model'] as String? ?? '').toLowerCase().contains(q) ||
        (p['brand'] as String? ?? '').toLowerCase().contains(q)
      ).toList();
    }

    final totalTradeIn = _calculatedOldValue + _exchangeBonus;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.white,
          child: Column(
            children: [
              TextField(
                onChanged: (v) => setState(() => _newSearchQuery = v),
                decoration: InputDecoration(
                  hintText: 'Search upgrade flagships (Sony, Canon, iPhone, Mac)...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  filled: true,
                  fillColor: const Color(0xFFF1F5F9),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: catList.map((cat) {
                    final isSel = _newCategoryFilter == cat['id'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(cat['label']!),
                        selected: isSel,
                        onSelected: (val) {
                          if (val) setState(() => _newCategoryFilter = cat['id']!);
                        },
                        selectedColor: const Color(0xFF4F46E5),
                        labelStyle: TextStyle(color: isSel ? Colors.white : const Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            separatorBuilder: (c, i) => const SizedBox(height: 10),
            itemBuilder: (ctx, idx) {
              final p = filtered[idx];
              final name = p['model'] as String? ?? 'Device';
              final price = p['sellingPrice'] as int? ?? 65000;
              final image = p['image'] as String? ?? 'assets/images/categories/dslr.png';
              final diff = price - totalTradeIn;

              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedNewDevice = p;
                    _selectedCondition = 'Superb';
                    _selectedUnitIndex = 0;
                    _step = 3;
                  });
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12)),
                        child: Image.asset(image, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.devices, size: 28, color: Color(0xFF4F46E5))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 2),
                            Text('Price: ${formatCurrency(price)}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                            const SizedBox(height: 4),
                            Text(
                              diff > 0 ? 'Pay Difference: ${formatCurrency(diff)}' : 'You Receive: +${formatCurrency(diff.abs())} Cash',
                              style: TextStyle(
                                color: diff > 0 ? const Color(0xFF4F46E5) : const Color(0xFF059669),
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF94A3B8)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── STEP 3: PRODUCT DETAIL SCREEN (GALLERY, CONDITION TABS, UNITS, 45-POINT CHECK) ──
  Widget _buildProductDetailStep() {
    if (_selectedNewDevice == null) return const Center(child: Text('Device not selected'));

    final p = _selectedNewDevice!;
    final name = p['model'] as String? ?? 'Device';
    final brand = p['brand'] as String? ?? 'Brand';
    final image = p['image'] as String? ?? 'assets/images/categories/dslr.png';
    final specs = p['specs'] as String? ?? 'Certified 45-point hardware tested with comprehensive warranty.';
    final units = (p['availableUnits'] as List?) ?? [
      {'serial': 'CSM-8821', 'batteryHealth': '96%', 'warranty': '12 Months'},
      {'serial': 'CSM-8822', 'batteryHealth': '92%', 'warranty': '12 Months'},
    ];

    final adjustedPrice = _getAdjustedNewDevicePrice();
    final totalTradeIn = _calculatedOldValue + _exchangeBonus;
    final netDiff = adjustedPrice - totalTradeIn;
    final netPayable = netDiff > 0 ? netDiff : 0;
    final cashback = netDiff < 0 ? netDiff.abs() : 0;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Main Image
                Center(
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Image.asset(image, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.devices, size: 64, color: Color(0xFF4F46E5))),
                  ),
                ),
                const SizedBox(height: 16),

                // Title and Brand
                Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                Text('$brand · Certified Refurbished', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                const SizedBox(height: 14),

                // Condition Selector Tabs (Superb, Good, Fair)
                const Text('Select Refurbished Grade:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildConditionChip('Superb', 'Superb (Like New)'),
                    const SizedBox(width: 8),
                    _buildConditionChip('Good', 'Good Condition'),
                    const SizedBox(width: 8),
                    _buildConditionChip('Fair', 'Fair Condition'),
                  ],
                ),
                const SizedBox(height: 16),

                // Available Unit Selector
                const Text('Select Verified Serial Unit:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 8),
                Column(
                  children: List.generate(units.length, (uIdx) {
                    final u = units[uIdx] as Map<String, dynamic>;
                    final isSel = _selectedUnitIndex == uIdx;
                    final serial = u['serial']?.toString() ?? 'Unit ${uIdx + 1}';
                    final battery = u['batteryHealth']?.toString() ?? '95%';
                    final warranty = u['warranty']?.toString() ?? '12 Months';

                    return InkWell(
                      onTap: () => setState(() => _selectedUnitIndex = uIdx),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSel ? const Color(0xFF4F46E5).withValues(alpha: 0.08) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isSel ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(isSel ? Icons.check_circle : Icons.radio_button_off, color: isSel ? const Color(0xFF4F46E5) : const Color(0xFF94A3B8), size: 18),
                                const SizedBox(width: 8),
                                Text(serial, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(6)),
                                  child: Text('Battery: $battery', style: const TextStyle(color: Color(0xFF059669), fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(6)),
                                  child: Text(warranty, style: const TextStyle(color: Color(0xFF7C3AED), fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),

                // 45-Point Inspection Checklist Badge
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.verified, color: Color(0xFF059669), size: 18),
                          SizedBox(width: 6),
                          Text('45-Point Hardware Certified', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(specs, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Live Exchange Calculation Sticky Bar
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, -3)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cashback > 0 ? 'Cashback to You:' : 'Net Difference:',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                      Text(
                        cashback > 0 ? '+$kRupee${formatCurrency(cashback)}' : formatCurrency(netPayable),
                        style: TextStyle(
                          color: cashback > 0 ? const Color(0xFF059669) : const Color(0xFF4F46E5),
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () => setState(() => _step = 4),
                    child: const Row(
                      children: [
                        Text('Proceed to Checkout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_rounded, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConditionChip(String key, String label) {
    final isSel = _selectedCondition == key;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedCondition = key),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSel ? const Color(0xFF4F46E5) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isSel ? const Color(0xFF4F46E5) : const Color(0xFFCBD5E1)),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSel ? Colors.white : const Color(0xFF0F172A),
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  // ── STEP 4: CHECKOUT, COUPONS & ADDRESS ──
  Widget _buildCheckoutStep() {
    final adjustedPrice = _getAdjustedNewDevicePrice();
    final totalTradeIn = _calculatedOldValue + _exchangeBonus;
    final netDiff = adjustedPrice - totalTradeIn - _couponDiscount;
    final netPayable = netDiff > 0 ? netDiff : 0;
    final cashback = netDiff < 0 ? netDiff.abs() : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exchange Overview Cards
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                _buildSummaryLine('Upgraded Device ($_selectedCondition)', formatCurrency(adjustedPrice)),
                _buildSummaryLine('Old Device Trade-In Valuation', formatCurrency(_calculatedOldValue)),
                _buildSummaryLine('Guaranteed Camsik Exchange Bonus', '+$kRupee 5,000', isBonus: true),
                if (_couponDiscount > 0)
                  _buildSummaryLine('Coupon ($_appliedCouponCode)', '-${formatCurrency(_couponDiscount)}', isBonus: true),
                const Divider(height: 16),
                _buildSummaryLine(
                  cashback > 0 ? 'Cashback Paid to You on Handover' : 'Net Doorstep Payable Balance',
                  cashback > 0 ? '+$kRupee${formatCurrency(cashback)}' : formatCurrency(netPayable),
                  isBold: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Coupon Code Section
          const Text('Apply Upgrade Coupon:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _couponController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: 'Enter coupon code',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF059669),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onPressed: () => _applyCoupon(_couponController.text),
                child: const Text('Apply', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ActionChip(
                  label: const Text('CAMSIK500 (-$kRupee 500)'),
                  onPressed: () {
                    _couponController.text = 'CAMSIK500';
                    _applyCoupon('CAMSIK500');
                  },
                ),
                const SizedBox(width: 6),
                ActionChip(
                  label: const Text('UPGRADE1000 (-$kRupee 1,000)'),
                  onPressed: () {
                    _couponController.text = 'UPGRADE1000';
                    _applyCoupon('UPGRADE1000');
                  },
                ),
                const SizedBox(width: 6),
                ActionChip(
                  label: const Text('FESTIVE1500 (-$kRupee 1,500)'),
                  onPressed: () {
                    _couponController.text = 'FESTIVE1500';
                    _applyCoupon('FESTIVE1500');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Doorstep Handover Slot
          const Text('Select Handover Date & Time Slot:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            children: ['Tomorrow', 'Day After'].map((d) {
              final isSel = _selectedDate == d;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(d),
                  selected: isSel,
                  onSelected: (v) => setState(() => _selectedDate = d),
                  selectedColor: const Color(0xFF7C3AED),
                  labelStyle: TextStyle(color: isSel ? Colors.white : const Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 11),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['10:00 AM – 1:00 PM', '2:00 PM – 5:00 PM', '5:00 PM – 8:00 PM'].map((s) {
              final isSel = _selectedSlot == s;
              return ChoiceChip(
                label: Text(s),
                selected: isSel,
                onSelected: (v) => setState(() => _selectedSlot = s),
                selectedColor: const Color(0xFF7C3AED),
                labelStyle: TextStyle(color: isSel ? Colors.white : const Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 11),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Handover Address Form
          const Text('Doorstep Handover Details:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Mobile Phone',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _addressController,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Delivery & Handover Address',
              hintText: 'Flat, Wing, Building, Road name',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _cityController,
                  decoration: InputDecoration(labelText: 'City', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _pincodeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Pincode', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Payment Preference
          const Text('Payment Settlement Preference:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
            child: Row(
              children: [
                const Icon(Icons.handshake, color: Color(0xFF059669)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    cashback > 0 ? 'Technician pays cash / UPI to you on doorstep' : 'Pay balance to technician at doorstep via Cash / UPI',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Confirm Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
              ),
              onPressed: _isPlacingOrder ? null : _handleConfirmExchange,
              child: _isPlacingOrder
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                  : const Text('Confirm 1-Step Doorstep Swap Booking', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  // ── STEP 5: CONFIRMED ORDER RECEIPT ──
  Widget _buildConfirmedStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFFDCFCE7),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 52),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '1-Step Exchange Booked!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 6),
          const Text(
            'Your doorstep swap has been scheduled successfully.',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Verification OTP Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Order Number:', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    Text(_confirmedOrder?.orderNumber ?? 'CSM-EXC-94821', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Doorstep Handover OTP:', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(8)),
                      child: Text(_confirmedOrder?.otp ?? '8921', style: const TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.w900, fontSize: 16)),
                    ),
                  ],
                ),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Scheduled Slot:', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    Text('$_selectedDate ($_selectedSlot)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                setState(() => _step = 0);
              },
              child: const Text('Exchange Another Device', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryLine(String label, String value, {bool isBonus = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: const Color(0xFF475569))),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 14 : 12,
              fontWeight: isBold ? FontWeight.w900 : FontWeight.bold,
              color: isBonus ? const Color(0xFF059669) : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}

// ── TAB 4: PROFILE & ORDER CENTER ──

class UserProfileWidget extends StatelessWidget {
  final UserProfile profile;
  final List<UserOrder> orders;
  final Function(UserProfile) onProfileUpdate;
  final VoidCallback onLogout;
  final VoidCallback onNavigateToSell;
  final VoidCallback onNavigateToBuy;

  const UserProfileWidget({
    super.key,
    required this.profile,
    required this.orders,
    required this.onProfileUpdate,
    required this.onLogout,
    required this.onNavigateToSell,
    required this.onNavigateToBuy,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFF059669),
                  child: Text(
                    profile.name.isNotEmpty ? profile.name.substring(0, 1).toUpperCase() : 'C',
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(profile.phone, style: const TextStyle(color: Color(0xFF34D399), fontSize: 12)),
                      Text(profile.email, style: const TextStyle(color: Colors.white60, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // MY ORDERS SECTION (Section 52 & 53)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('My Orders & Handover Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              Text('${orders.length} Active', style: const TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 10),
          if (orders.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
              child: const Center(
                child: Column(
                  children: [
                    Icon(Icons.shopping_bag_outlined, size: 40, color: Color(0xFF94A3B8)),
                    SizedBox(height: 8),
                    Text('No orders yet', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold, fontSize: 13)),
                    Text('Sell, buy, or exchange devices to see your orders here.', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                  ],
                ),
              ),
            )
          else
            ...orders.map((o) => _buildOrderCard(context, o)),

          const SizedBox(height: 24),
          const Text('Account & Support', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 10),
          _buildSettingsTile(Icons.location_on_outlined, 'Saved Doorstep Addresses', profile.address),
          _buildSettingsTile(Icons.account_balance_wallet_outlined, 'Payout UPI & Bank Account', profile.upiId),
          _buildSettingsTile(Icons.support_agent_outlined, 'Customer Support', 'WhatsApp: +91 8976000010'),
          _buildSettingsTile(Icons.verified_outlined, 'Warranty & Data Protection Policy', 'DoD 5220.22-M Wipe Certificate'),
          _buildSettingsTile(Icons.privacy_tip_outlined, 'Privacy Policy & Terms', 'Camsik ReCommerce terms'),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFEF4444),
                side: const BorderSide(color: Color(0xFFEF4444)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: onLogout,
              child: const Text('Log Out of Camsik', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, UserOrder o) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: o.type == 'buy' ? const Color(0xFFEDE9FE) : const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  o.orderNumber,
                  style: TextStyle(
                    color: o.type == 'buy' ? const Color(0xFF7C3AED) : const Color(0xFF059669),
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
              Text(
                o.status,
                style: const TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(o.device, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formatCurrency(o.amount), style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF0F172A), fontSize: 14)),
              Text('OTP: ${o.otp}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4F46E5), fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 12),
          Row(
            children: [
              const Icon(Icons.schedule, size: 12, color: Color(0xFF64748B)),
              const SizedBox(width: 4),
              Text(o.date, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
              const Spacer(),
              TextButton(
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(50, 20)),
                onPressed: () {
                  _showOrderTimelineModal(context, o);
                },
                child: const Text('View Timeline', style: TextStyle(color: Color(0xFF059669), fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showOrderTimelineModal(BuildContext context, UserOrder o) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order Status Timeline: ${o.orderNumber}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...List.generate(o.timelineSteps.length, (idx) {
                final isDone = idx <= o.currentStep;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Icon(
                        isDone ? Icons.check_circle : Icons.radio_button_off,
                        color: isDone ? const Color(0xFF059669) : const Color(0xFF94A3B8),
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        o.timelineSteps[idx],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
                          color: isDone ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF059669), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                Text(subtitle, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF94A3B8)),
        ],
      ),
    );
  }
}

// ── BOTTOM NAVIGATION BAR ──

class CamsikBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CamsikBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onItemSelected,
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xFF059669).withValues(alpha: 0.15),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home, color: Color(0xFF059669)),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.attach_money_rounded),
          selectedIcon: Icon(Icons.attach_money, color: Color(0xFF059669)),
          label: 'Sell',
        ),
        NavigationDestination(
          icon: Icon(Icons.shopping_bag_outlined),
          selectedIcon: Icon(Icons.shopping_bag, color: Color(0xFF059669)),
          label: 'Buy',
        ),
        NavigationDestination(
          icon: Icon(Icons.swap_horiz_rounded),
          selectedIcon: Icon(Icons.swap_horiz, color: Color(0xFF7C3AED)),
          label: 'Exchange',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person, color: Color(0xFF059669)),
          label: 'Profile',
        ),
      ],
    );
  }
}
