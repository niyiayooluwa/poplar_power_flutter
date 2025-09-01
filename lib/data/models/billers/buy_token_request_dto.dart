class BuyTokenRequestDto {
  final String meterNumber;
  final int amount;
  final String walletPin;
  final String notificationPreference;
  final String? email;
  final String? phoneNumber;
  final String provider;
  final String categoryOrBillerGroups;
  final String categoryIdOrBillers;
  final String billerIdOrProductId;

  BuyTokenRequestDto({
    required this.meterNumber,
    required this.amount,
    required this.walletPin,
    required this.notificationPreference,
    this.email,
    this.phoneNumber,
    required this.provider,
    required this.categoryOrBillerGroups,
    required this.categoryIdOrBillers,
    required this.billerIdOrProductId,
  });

  Map<String, dynamic> toJson() {
    return {
      'meterNumber': meterNumber,
      'amount': amount,
      'walletPin': walletPin,
      'notificationPreference': notificationPreference,
      'email': email,
      'phoneNumber': phoneNumber,
      'provider': provider,
      'CategoryOrBillerGroups': categoryOrBillerGroups,
      'CategoryIdOrBillers': categoryIdOrBillers,
      'billerIdOrProductId': billerIdOrProductId,
    };
  }
}
