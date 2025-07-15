class ElectricityDisco {
  final String name;
  final List<ElectricityProduct> products;

  const ElectricityDisco({required this.name, required this.products});
}

class ElectricityProduct {
  final String name;
  final double? price;

  const ElectricityProduct({required this.name, this.price});
}
