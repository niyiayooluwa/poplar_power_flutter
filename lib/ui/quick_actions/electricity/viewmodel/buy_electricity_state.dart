import '../../../../domain/models/electricity_disco.dart';

class BuyElectricityState {
  /// A list of available Electricity Discos
  final List<ElectricityDisco> electricityDiscos;

  ///The currently selected Disco
  final ElectricityDisco? selectedDisco;

  ///The currently selected product
  final ElectricityProduct? selectedProduct;

  ///The meter number;
  final String? meterNumber;

  ///The price
  final String? price;

  ///Creates an instance of [BuyElectricityState].
  ///
  /// [electricityDiscos] is the list of available Electricity Discos.
  /// [selectedDisco] is the currently selected Disco.
  /// [selectedProduct] is the currently selected product.
  const BuyElectricityState({
    required this.electricityDiscos,
    required this.selectedDisco,
    required this.selectedProduct,
    required this.meterNumber,
    required this.price
  });

  factory BuyElectricityState.initial() {
    return const BuyElectricityState(
      electricityDiscos: [],
      selectedDisco: null,
      selectedProduct: null,
      meterNumber: null,
      price: null
    );
  }

  ///Creates a copy of the current state with the given fields replaced with the
  ///new values.
  BuyElectricityState copyWith({
    List<ElectricityDisco>? electricityDiscos,
    ElectricityDisco? selectedDisco,
    ElectricityProduct? selectedProduct,
    String? meterNumber,
    String? price
  }) {
    return BuyElectricityState(
      electricityDiscos: electricityDiscos ?? this.electricityDiscos,
      selectedDisco: selectedDisco ?? this.selectedDisco,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      meterNumber: meterNumber ?? this.meterNumber,
      price: price ?? this.price,
    );
  }
}