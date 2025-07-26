import 'dart:async';

import '../../../domain/models/electricity_disco.dart';

class ElectricityDiscoRepository {

  ///Fetches a list of Discos and their associated products.
  Future<List<ElectricityDisco>> fetchDiscos() async {
    return [
      ElectricityDisco(
        name: 'Eko Electricity',
        products: [
          ElectricityProduct(name: 'Prepaid'),
          ElectricityProduct(name: 'Postpaid'),
        ],
      ),

      ElectricityDisco(
        name: 'Enugu Electricity',
        products: [
          ElectricityProduct(name: 'Prepaid'),
          ElectricityProduct(name: 'Postpaid'),
        ],
      ),

      ElectricityDisco(
        name: 'Portharcourt Electricity',
        products: [
          ElectricityProduct(name: 'Prepaid'),
          ElectricityProduct(name: 'Postpaid'),
        ],
      ),

      ElectricityDisco(
        name: 'Abuja Electricity',
        products: [
          ElectricityProduct(name: 'Prepaid'),
          ElectricityProduct(name: 'Postpaid'),
        ],
      ),
      ElectricityDisco(
        name: 'Kano Electricity',
        products: [
          ElectricityProduct(name: 'Prepaid'),
          ElectricityProduct(name: 'Postpaid'),
        ],
      ),

      ElectricityDisco(
        name: 'Ikeja Electricity',
        products: [
          ElectricityProduct(name: 'Prepaid'),
          ElectricityProduct(name: 'Postpaid'),
        ],
      ),

      ElectricityDisco(
        name: 'Kaduna Electricity',
        products: [
          ElectricityProduct(name: 'Prepaid'),
          ElectricityProduct(name: 'Postpaid'),
        ],
      ),
      ElectricityDisco(
        name: 'Jos Electricity',
        products: [
          ElectricityProduct(name: 'Prepaid'),
          ElectricityProduct(name: 'Postpaid'),
        ],
      ),

      ElectricityDisco(
        name: 'Ibadan Electricity',
        products: [
          ElectricityProduct(name: 'Prepaid'),
          ElectricityProduct(name: 'Postpaid'),
        ],
      ),

      ElectricityDisco(
        name: 'Aba Electricity',
        products: [
          ElectricityProduct(name: 'Prepaid'),
          ElectricityProduct(name: 'Postpaid'),
        ],
      ),

      ElectricityDisco(
        name: 'Benin Electricity',
        products: [
          ElectricityProduct(name: 'Prepaid'),
          ElectricityProduct(name: 'Postpaid'),
        ],
      ),

      ElectricityDisco(
        name: 'ASOLAR',
        products: [ElectricityProduct(name: 'ASOLAR')],
      ),

      ElectricityDisco(
        name: 'Switch Solar',
        products: [ElectricityProduct(name: 'Switch Solar')],
      ),

      ElectricityDisco(
        name: 'Wave-Length',
        products: [ElectricityProduct(name: 'Wave-Length')],
      ),

      ElectricityDisco(
        name: 'A1 Power',
        products: [ElectricityProduct(name: 'A1 Power')],
      ),

      ElectricityDisco(
        name: 'A4 and T power',
        products: [ElectricityProduct(name: 'A4 and T power')],
      ),

      ElectricityDisco(
        name: 'Smarter Grid',
        products: [
          ElectricityProduct(name: 'Tier 1', price: 120000),
          ElectricityProduct(name: 'Tier 2', price: 150000),
          ElectricityProduct(name: 'Tier 3', price: 180000),
          ElectricityProduct(name: 'Tier 4', price: 210000),
          ElectricityProduct(name: 'Tier 5', price: 240000),
          ElectricityProduct(name: 'Tier 6', price: 270000),
          ElectricityProduct(name: 'Tier 7', price: 300000),
          ElectricityProduct(name: 'Tier 8', price: 350000),
          ElectricityProduct(name: 'Tier 9', price: 400000),
          ElectricityProduct(name: 'Tier 10', price: 450000),
          ElectricityProduct(name: 'Tier 11', price: 500000),
          ElectricityProduct(name: 'Tier 12', price: 550000),
        ],
      ),

      ElectricityDisco(
        name: 'CLOUD Energy',
        products: [ElectricityProduct(name: 'CLOUD Energy')],
      ),

      ElectricityDisco(
        name: 'Oolu Solar',
        products: [ElectricityProduct(name: 'Oolu Solar')],
      ),

      ElectricityDisco(
        name: 'ASOLAR Devices',
        products: [ElectricityProduct(name: 'ASOLAR Devices')],
      ),

      ElectricityDisco(
        name: 'Greenlight Planet',
        products: [ElectricityProduct(name: 'Greenlight Planet')],
      ),

      ElectricityDisco(
        name: 'Privida Sparkmeter',
        products: [ElectricityProduct(name: 'Privida Sparkmeter')],
      ),

      ElectricityDisco(
        name: 'Privider Steamaco',
        products: [ElectricityProduct(name: 'Privider Steamaco')],
      ),

      ElectricityDisco(
        name: 'YEDC',
        products: [
          ElectricityProduct(name: 'Prepaid'),
          ElectricityProduct(name: 'Postpaid'),
        ],
      ),

      ElectricityDisco(
        name: 'APLE-KAYZ',
        products: [ElectricityProduct(name: 'APLE-KAYZ')],
      ),

      ElectricityDisco(
        name: 'Husk Power',
        products: [ElectricityProduct(name: 'Husk Power')],
      ),

      ElectricityDisco(
        name: 'Lumos',
        products: [ElectricityProduct(name: 'Lumos')],
      ),

      ElectricityDisco(
        name: 'Privida',
        products: [ElectricityProduct(name: 'Privida')],
      ),
    ];
  }

  ///Fetches a list of Discos names for SmartInput dropdowns or search
  Future<List<String>> fetchAvailableDiscos() async {
    final all = await fetchDiscos();
    return all.map((provider) => provider.name).toList();
  }
}
