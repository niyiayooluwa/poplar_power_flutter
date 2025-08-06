import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/mock/mock_repository/mock_disco_repository.dart';
import 'buy_electricity_state.dart';

class BuyElectricityViewModel extends StateNotifier<BuyElectricityState> {
  final ElectricityDiscoRepository _repository;

  BuyElectricityViewModel(this._repository): super(BuyElectricityState.initial()) {
    _loadElectricityDiscos();
  }

  void _loadElectricityDiscos() async {
    final electricityDiscos = await _repository.fetchDiscos();
    state = state.copyWith(electricityDiscos: electricityDiscos);
  }
  void setMeterNumber(String number) {
    state = state.copyWith(meterNumber: number);
  }
  void selectElectricityDisco(String name) {
    final selected =  state.electricityDiscos.firstWhere((disco) => disco.name == name);
    state = state.copyWith(
      selectedDisco: selected,
      selectedProduct: null, //Reset product if Disco changes
    );
  }
  void selectProduct(String productName) {
    final product = state.selectedDisco?.products.firstWhere(
          (product) => product.name == productName /*orElse: () => null*/,
    );
    state = state.copyWith(selectedProduct: product);
  }
  void setPrice(String price) {
    state = state.copyWith(price: price);
  }
  void reset() {
    state = state.copyWith(
      selectedDisco: null,
      price: '',
      selectedProduct: null,
      meterNumber: '',
    );
  }
  bool get isFormValid {
    return state.selectedDisco != null &&
        state.selectedProduct != null &&
        state.meterNumber != null &&
        state.price != null &&
        state.price!.length <= 6 &&
        state.price!.length >= 3 &&
        state.meterNumber!.length < 11 &&
        state.meterNumber!.length >= 6;
  }
}