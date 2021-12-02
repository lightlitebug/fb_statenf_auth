import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:state_notifier/state_notifier.dart';

import '../../repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthProvider extends StateNotifier<AuthState> with LocatorMixin {
  AuthProvider() : super(AuthState.unknown());

  @override
  void update(Locator watch) {
    final user = watch<fbAuth.User?>();

    if (user != null) {
      state = state.copyWith(
        authStatus: AuthStatus.authenticated,
        user: user,
      );
    } else {
      state = state.copyWith(authStatus: AuthStatus.unauthenticated);
    }
    print('authState: $state');
    super.update(watch);
  }

  void signout() async {
    await read<AuthRepository>().signout();
  }
}
