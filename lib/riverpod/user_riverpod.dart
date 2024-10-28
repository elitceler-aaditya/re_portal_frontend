import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_portal_frontend/modules/shared/models/user.dart';

class UserNotifier extends StateNotifier<User> {
  UserNotifier() : super(const User());

  void setUser(User user) {
    state = user;
  }

  void updateUser({
    String? userId,
    String? name,
    String? email,  
    String? phoneNumber,
    String? token,
  }) {
    state = state.copyWith(
      userId: userId ?? state.userId,
      name: name ?? state.name,
      email: email ?? state.email,
      phoneNumber: phoneNumber ?? state.phoneNumber,
      token: token ?? state.token,
    );
  }

  void clearUser() {
    state = const User();
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User>((ref) {
  return UserNotifier();
});
