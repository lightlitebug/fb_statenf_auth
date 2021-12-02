// import 'package:flutter/foundation.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../models/custom_error.dart';
import '../../models/user_model.dart';
import '../../repositories/profile_repository.dart';
import 'profile_state.dart';

// class ProfileProvider with ChangeNotifier {
class ProfileProvider extends StateNotifier<ProfileState> with LocatorMixin {
  // ProfileState _state = ProfileState.initial();
  // ProfileState get state => _state;
  ProfileProvider() : super(ProfileState.initial());

  // final ProfileRepository profileRepository;
  // ProfileProvider({
  //   required this.profileRepository,
  // });

  Future<void> getProfile({required String uid}) async {
    // _state = _state.copyWith(profileStatus: ProfileStatus.loading);
    state = state.copyWith(profileStatus: ProfileStatus.loading);
    // notifyListeners();

    try {
      // final User user = await profileRepository.getProfile(uid: uid);
      final User user = await read<ProfileRepository>().getProfile(uid: uid);

      // _state = _state.copyWith(profileStatus: ProfileStatus.loaded, user: user);
      state = state.copyWith(profileStatus: ProfileStatus.loaded, user: user);
      // notifyListeners();
    } on CustomError catch (e) {
      // _state = _state.copyWith(profileStatus: ProfileStatus.error, error: e);
      state = state.copyWith(profileStatus: ProfileStatus.error, error: e);
      // notifyListeners();
    }
  }
}
