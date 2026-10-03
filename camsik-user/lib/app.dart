import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'modules/auth/bloc/auth_cubit.dart';
import 'modules/home/bloc/home_cubit.dart';
import 'modules/orders/bloc/orders_cubit.dart';
import 'modules/sell/bloc/sell_cubit.dart';
import 'core/services/session_service.dart';
import 'models/user_profile.dart';
import 'core/routes/app_routes.dart';
import 'modules/auth/auth_screen.dart';
import 'modules/main_navigation_screen.dart';
import 'modules/onboarding/onboarding_screen.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class CamsikUserApp extends StatefulWidget {
  const CamsikUserApp({super.key});

  @override
  State<CamsikUserApp> createState() => _CamsikUserAppState();
}

class _CamsikUserAppState extends State<CamsikUserApp> {
  bool _isFirstLaunch = false;
  bool _isLoggedIn = false;

  // Active User Profile - Starts clean and empty by default
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
          name: savedProfile['name']?.toString().isNotEmpty == true
              ? savedProfile['name']
              : 'Camsik Customer',
          phone: savedProfile['phone']?.toString() ?? '',
          email: savedProfile['email']?.toString() ?? '',
          avatarIndex:
              (savedProfile['avatarIndex'] as num?)?.toInt() ?? 0,
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => AuthCubit()..checkSession()),
        BlocProvider<HomeCubit>(create: (_) => HomeCubit()..loadHomeData()),
        BlocProvider<OrdersCubit>(create: (_) => OrdersCubit()),
        BlocProvider<SellCubit>(create: (_) => SellCubit()),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: scaffoldMessengerKey,
        title: 'Camsik User',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRoutes.onGenerateRoute,
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
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
      ),
    );
  }
}
