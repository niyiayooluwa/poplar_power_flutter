enum NetworkProvider { mtn, glo, airtel, nineMobile }

extension NetworkProviderExtension on NetworkProvider {
  String get label {
    switch (this) {
      case NetworkProvider.mtn:
        return "MTN";
      case NetworkProvider.glo:
        return "GLO";
      case NetworkProvider.airtel:
        return "Airtel";
      case NetworkProvider.nineMobile:
        return "9Mobile";
    }
  }

  String get assetPath {
    switch (this) {
      case NetworkProvider.mtn:
        return 'assets/networks/mtn.png';
      case NetworkProvider.glo:
        return 'assets/networks/glo.png';
      case NetworkProvider.airtel:
        return 'assets/networks/airtel.png';
      case NetworkProvider.nineMobile:
        return 'assets/networks/nine-mobile.jpg';
    }
  }
}
