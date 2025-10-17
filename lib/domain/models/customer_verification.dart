
class CustomerVerification {
  final String fullname;
  final bool enabled;
  final String meterNumber;
  final String accountNumber;
  final double arrearsBalance;
  final String accountType;
  final String address;
  final double minamount;
  final double maxamount;

  CustomerVerification({
    required this.fullname,
    required this.enabled,
    required this.meterNumber,
    required this.accountNumber,
    required this.arrearsBalance,
    required this.accountType,
    required this.address,
    required this.minamount,
    required this.maxamount,
  });
}
