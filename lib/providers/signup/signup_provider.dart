// import 'package:flutter/foundation.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../models/custom_error.dart';
import '../../repositories/auth_repository.dart';
import 'signup_state.dart';

// class SignupProvider with ChangeNotifier {
class SignupProvider extends StateNotifier<SignupState> with LocatorMixin {
  // SignupState _state = SignupState.initial();
  // SignupState get state => _state;
  SignupProvider() : super(SignupState.initial());

  // final AuthRepository authRepository;
  // SignupProvider({
  //   required this.authRepository,
  // });

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    // _state = _state.copyWith(signupStatus: SignupStatus.submitting);
    state = state.copyWith(signupStatus: SignupStatus.submitting);
    // notifyListeners();

    try {
      // await authRepository.signup(name: name, email: email, password: password);
      await read<AuthRepository>()
          .signup(name: name, email: email, password: password);
      // _state = _state.copyWith(signupStatus: SignupStatus.success);
      state = state.copyWith(signupStatus: SignupStatus.success);
      // notifyListeners();
    } on CustomError catch (e) {
      // _state = _state.copyWith(signupStatus: SignupStatus.error, error: e);
      state = state.copyWith(signupStatus: SignupStatus.error, error: e);
      // notifyListeners();
      rethrow;
    }
  }
}
