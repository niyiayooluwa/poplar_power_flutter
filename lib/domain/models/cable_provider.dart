class CableProvider {
  final String name;
  final List<CablePackage> packages;

  const CableProvider({required this.name, required this.packages});
}

class CablePackage {
  final String name;
  final double price;
  final String? duration;

  const CablePackage({
    required this.name, required this.price,this.duration,});
}