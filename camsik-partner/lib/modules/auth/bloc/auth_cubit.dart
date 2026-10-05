import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/network_exceptions.dart';
import '../../../../core/services/session_service.dart';
import '../../../../models/partner_models.dart';
import '../data/models/requests/partner_login_request.dart';
import '../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepositoryImpl(),
        super(const AuthInitial());

  Future<void> login({
    required String identifier,
    required String password,
  }) async {
    final cleanId = identifier.trim();
    final cleanPass = password.trim();

    if (cleanId.isEmpty) {
      emit(const AuthFailure('Please enter your partner email or phone number.'));
      return;
    }

    if (cleanPass.isEmpty) {
      emit(const AuthFailure('Please enter your password.'));
      return;
    }

    emit(const AuthLoading());

    try {
      final response = await _authRepository.login(
        PartnerLoginRequest(
          identifier: cleanId,
          password: cleanPass,
        ),
      );

      final data = response.data;
      if (data != null && data['success'] == true) {
        final partnerJson = data['partner'] ?? data['user'];
        if (partnerJson != null) {
          final partner = PartnerUser.fromJson(Map<String, dynamic>.from(partnerJson));
          await SessionService.saveSession(partner);
          emit(AuthSuccess(
            partner: partner,
            message: data['message']?.toString() ?? 'Logged in successfully',
          ));
          return;
        }
      }

      final errMsg = data?['message']?.toString() ?? 'Login failed. Please verify partner credentials.';
      emit(AuthFailure(errMsg));
    } catch (e) {
      /*
      // Fallback offline authentication for testing if needed
      */
      final errorMsg = NetworkExceptions.getErrorMessage(e);
      emit(AuthFailure(errorMsg));
    }
  }

  Future<void> logout() async {
    await SessionService.clearSession();
    emit(const AuthInitial());
  }
}
