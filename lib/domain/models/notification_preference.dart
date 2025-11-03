/// Enum representing the user's preference for receiving notifications.
enum NotificationPreference {
  email,
  sms,
  both,
  none;

  /// Converts the enum to its uppercase string representation for API requests.
  String toJson() => name.toUpperCase();

  /// Creates a [NotificationPreference] from a string.
  /// Defaults to [both] if the string is unrecognized.
  static NotificationPreference fromJson(String json) {
    return values.firstWhere(
      (e) => e.name.toUpperCase() == json.toUpperCase(),
      orElse: () => both,
    );
  }
}
