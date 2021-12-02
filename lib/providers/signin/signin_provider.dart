import 'package:state_notifier/state_notifier.dart';

import '../../models/custom_error.dart';
import '../../repositories/auth_repository.dart';
import 'signin_state.dart';

class SigninProvider extends StateNotifier<SigninState> with LocatorMixin {
  SigninProvider() : super(SigninState.initial());

  Future<void> signin({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(signinStatus: SigninStatus.submitting);

    try {
      await read<AuthRepository>().signin(email: email, password: password);
      state = state.copyWith(signinStatus: SigninStatus.success);
    } on CustomError catch (e) {
      state = state.copyWith(signinStatus: SigninStatus.error, error: e);
      rethrow;
    }
  }
}
