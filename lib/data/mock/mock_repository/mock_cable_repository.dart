import '../../../domain/models/cable_provider.dart';

class CablePackagesRepository {
  static const _delay = Duration(milliseconds: 300);

  Future<List<CableProvider>> fetchCableProviders() async {
    await Future.delayed(_delay);

    return [
      // ===== DStv (Base + Add-ons) =====
      CableProvider(
        name: 'DStv',
        packages: [
          // Base Bouquets
          CablePackage(name: 'DStv Premium', price: 21000),
          CablePackage(name: 'DStv Compact Plus', price: 14500),
          CablePackage(name: 'DStv Compact', price: 10500),
          CablePackage(name: 'DStv Confam', price: 6200),
          CablePackage(name: 'DStv Yanga', price: 3600),
          CablePackage(name: 'DStv Padi', price: 2500),

          // Add-ons
          CablePackage(name: 'DStv French Plus', price: 2500),
          CablePackage(name: 'DStv Indian', price: 1200),
          CablePackage(name: 'DStv Portuguese', price: 1500),
          CablePackage(name: 'DStv Asian', price: 1800),
        ],
      ),

      // ===== GOtv (Base + Add-ons) =====
      CableProvider(
        name: 'GOtv',
        packages: [
          // Base Bouquets
          CablePackage(name: 'GOtv Supa+', price: 7600),
          CablePackage(name: 'GOtv Supa', price: 5700),
          CablePackage(name: 'GOtv Max', price: 4150),
          CablePackage(name: 'GOtv Jolli', price: 3100),
          CablePackage(name: 'GOtv Jinja', price: 2250),
          CablePackage(name: 'GOtv Lite', price: 1300),

          // Add-ons
          CablePackage(name: 'GOtv English Plus', price: 800),
          CablePackage(name: 'GOtv Yoruba', price: 500),
          CablePackage(name: 'GOtv Hausa', price: 500),
          CablePackage(name: 'GOtv Igbo', price: 500),
        ],
      ),

      // ===== Startimes (Base + Add-ons) =====
      CableProvider(
        name: 'Startimes',
        packages: [
          // Base Bouquets
          CablePackage(name: 'Startimes Nova', price: 1900),
          CablePackage(name: 'Startimes Basic', price: 2500),
          CablePackage(name: 'Startimes Smart', price: 3800),
          CablePackage(name: 'Startimes Classic', price: 5500),
          CablePackage(name: 'Startimes Super', price: 7500),

          // Add-ons
          CablePackage(name: 'Startimes Sports', price: 1500),
          CablePackage(name: 'Startimes Chinese', price: 1000),
          CablePackage(name: 'Startimes Nollywood', price: 1200),
        ],
      ),

      // ===== Showmax (All plans include duration) =====
      CableProvider(
        name: 'Showmax',
        packages: [
          // Mobile Plans
          CablePackage(name: 'Showmax Mobile', price: 1200, duration: '1 Month'),
          CablePackage(name: 'Showmax Mobile (Annual)', price: 12000, duration: '1 Year'),

          // Entertainment Plans
          CablePackage(name: 'Showmax Entertainment', price: 3800, duration: '1 Month'),
          CablePackage(name: 'Showmax Entertainment (Annual)', price: 38000, duration: '1 Year'),

          // Premier League Plans
          CablePackage(name: 'Showmax Premier League', price: 4200, duration: '1 Month'),
          CablePackage(name: 'Showmax Premier League (Annual)', price: 42000, duration: '1 Year'),

          // Add-ons (Bundles with DStv/GOtv)
          CablePackage(name: 'Showmax + DStv Compact', price: 12500, duration: '1 Month'),
          CablePackage(name: 'Showmax + GOtv Supa', price: 8500, duration: '1 Month'),
        ],
      ),
    ];
  }

  Future<List<String>> fetchCableProviderNames() async {
    final all = await fetchCableProviders();
    return all.map((provider) => provider.name).toList();
  }
}

