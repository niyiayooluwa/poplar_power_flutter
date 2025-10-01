import 'dart:convert';

import 'package:poplar_power/data/models/user/user_dto.dart';
import 'package:poplar_power/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that handles persisting and retrieving the user profile
/// to and from local storage.
class UserProfileStorage {
  static const _userProfileKey = 'user_profile';

  /// Saves the user profile to local storage.
  /// The [User] entity is converted to a [UserDto] and then to a JSON string for storage.
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userDto = UserDto.fromEntity(user);
    final jsonString = jsonEncode(userDto.toJson());
    await prefs.setString(_userProfileKey, jsonString);
  }

  /// Loads the user profile from local storage.
  /// The JSON string is retrieved and converted to a [UserDto], then to a [User] entity.
  /// Returns null if no user profile is found.
  Future<User?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userProfileKey);
    if (jsonString != null) {
      try {
        final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
        final userDto = UserDto.fromJson(jsonMap);
        return userDto.toEntity();
      } catch (e) {
        // If parsing fails, delete the corrupted data.
        await deleteUser();
        return null;
      }
    }
    return null;
  }

  /// Deletes the user profile from local storage.
  Future<void> deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userProfileKey);
  }
}
