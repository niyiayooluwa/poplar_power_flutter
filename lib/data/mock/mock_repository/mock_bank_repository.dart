import '../../../domain/models/bank.dart';

class BankRepository {
  static const _delay = Duration(milliseconds: 300);

  Future<List<Bank>> fetchBanks() async {
    await Future.delayed(_delay);

    return [
      Bank(name: "AB Microfinance Bank", bankLogo: "assets/banks/ab.png"),
      Bank(
        name: "Accion Microfinance Bank",
        bankLogo: "assets/banks/accion.png",
      ),
      Bank(name: "Access Bank", bankLogo: "assets/banks/access.png"),
      Bank(
        name: "Addosser Microfinance Bank",
        bankLogo: "assets/banks/addosser.png",
      ),
      Bank(
        name: "Assets Microfinance Bank",
        bankLogo: "assets/banks/assets.png",
      ),
      Bank(
        name: "Baobab Microfinance Bank",
        bankLogo: "assets/banks/baobab.png",
      ),
      Bank(
        name: "Boctrust Microfinance Bank",
        bankLogo: "assets/banks/boctrust.png",
      ),
      Bank(name: "Carbon", bankLogo: "assets/banks/carbon.png"),
      Bank(name: "CashX", bankLogo: "assets/banks/cashx.png"),
      Bank(name: "Citibank Nigeria", bankLogo: "assets/banks/citibank.png"),
      Bank(name: "Dot Microfinance Bank", bankLogo: "assets/banks/dot.png"),
      Bank(name: "Ecobank Nigeria", bankLogo: "assets/banks/ecobank.png"),
      Bank(name: "FairMoney", bankLogo: "assets/banks/fairmoney.png"),
      Bank(name: "Fidelity Bank", bankLogo: "assets/banks/fidelity.png"),
      Bank(
        name: "Fina Trust Microfinance Bank",
        bankLogo: "assets/banks/fina_trust.png",
      ),
      Bank(name: "Finca Microfinance Bank", bankLogo: "assets/banks/finca.png"),
      Bank(
        name: "First Bank of Nigeria",
        bankLogo: "assets/banks/firstbank.png",
      ),
      Bank(
        name: "First City Monument Bank (FCMB)",
        bankLogo: "assets/banks/fcmb.png",
      ),
      Bank(
        name: "Fortis Microfinance Bank",
        bankLogo: "assets/banks/fortis.png",
      ),
      Bank(name: "Globus Bank", bankLogo: "assets/banks/globus.png"),
      Bank(name: "Guaranty Trust Bank (GTB)", bankLogo: "assets/banks/gtb.png"),
      Bank(name: "Hasal Microfinance Bank", bankLogo: "assets/banks/hasal.png"),
      Bank(name: "Heritage Bank", bankLogo: "assets/banks/heritage.png"),
      Bank(name: "Jaiz Bank", bankLogo: "assets/banks/jaiz.png"),
      Bank(name: "Keystone Bank", bankLogo: "assets/banks/keystone.png"),
      Bank(name: "Kuda Bank", bankLogo: "assets/banks/kuda.png"),
      Bank(name: "LAPO Microfinance Bank", bankLogo: "assets/banks/lapo.png"),
      Bank(
        name: "Mainstreet Microfinance Bank",
        bankLogo: "assets/banks/mainstreet.png",
      ),
      Bank(name: "Mint Finex", bankLogo: "assets/banks/mint.png"),
      Bank(name: "Mkobo Microfinance Bank", bankLogo: "assets/banks/mkobo.png"),
      Bank(name: "Momo", bankLogo: "assets/banks/momo.png"),
      Bank(name: "Moniepoint", bankLogo: "assets/banks/moniepoint.png"),
      Bank(
        name: "Mutual Trust Microfinance Bank",
        bankLogo: "assets/banks/mutual_trust.png",
      ),
      Bank(name: "NPF Microfinance Bank", bankLogo: "assets/banks/npf.png"),
      Bank(name: "OPay", bankLogo: "assets/banks/opay.png"),
      Bank(name: "Optimus Bank", bankLogo: "assets/banks/optimus.png"),
      Bank(name: "Paga", bankLogo: "assets/banks/paga.png"),
      Bank(name: "Palmpay", bankLogo: "assets/banks/palmpay.png"),
      Bank(name: "Parallex Bank", bankLogo: "assets/banks/parallex.png"),
      Bank(name: "PayAttitude", bankLogo: "assets/banks/payattitude.png"),
      Bank(name: "Polaris Bank", bankLogo: "assets/banks/polaris.png"),
      Bank(
        name: "Premium Trust Bank",
        bankLogo: "assets/banks/premium_trust.png",
      ),
      Bank(name: "Providus Bank", bankLogo: "assets/banks/providus.png"),
      Bank(name: "Pryme App", bankLogo: "assets/banks/pryme.png"),
      Bank(name: "Raven Bank", bankLogo: "assets/banks/raven.png"),
      Bank(
        name: "Renmoney Microfinance Bank",
        bankLogo: "assets/banks/renmoney.png",
      ),
      Bank(
        name: "Rephidim Microfinance Bank",
        bankLogo: "assets/banks/rephidim.png",
      ),
      Bank(name: "Rex Microfinance Bank", bankLogo: "assets/banks/rex.png"),
      Bank(name: "Rubies Bank", bankLogo: "assets/banks/rubies.png"),
      Bank(name: "Signature Bank", bankLogo: "assets/banks/signature.png"),
      Bank(
        name: "Source Microfinance Bank",
        bankLogo: "assets/banks/source.png",
      ),
      Bank(name: "Sparkle", bankLogo: "assets/banks/sparkle.png"),
      Bank(
        name: "Sparkle Microfinance Bank",
        bankLogo: "assets/banks/sparkle_mfb.png",
      ),
      Bank(name: "Stanbic IBTC Bank", bankLogo: "assets/banks/stanbic.png"),
      Bank(
        name: "Standard Chartered Bank Nigeria",
        bankLogo: "assets/banks/standard_chartered.png",
      ),
      Bank(
        name: "Stanford Microfinance Bank",
        bankLogo: "assets/banks/stanford.png",
      ),
      Bank(name: "Sterling Bank", bankLogo: "assets/banks/sterling.png"),
      Bank(name: "Summit Bank", bankLogo: "assets/banks/summit.png"),
      Bank(name: "Suntrust Bank", bankLogo: "assets/banks/suntrust.png"),
      Bank(name: "Taj Bank", bankLogo: "assets/banks/taj.png"),
      Bank(name: "Titan Trust Bank", bankLogo: "assets/banks/titan.png"),
      Bank(
        name: "Trustbond Microfinance Bank",
        bankLogo: "assets/banks/trustbond.png",
      ),
      Bank(name: "Union Bank of Nigeria", bankLogo: "assets/banks/union.png"),
      Bank(
        name: "United Bank for Africa (UBA)",
        bankLogo: "assets/banks/uba.png",
      ),
      Bank(name: "Unity Bank", bankLogo: "assets/banks/unity.png"),
      Bank(name: "VBank", bankLogo: "assets/banks/vbank.png"),
      Bank(name: "VFD Microfinance Bank", bankLogo: "assets/banks/vfd.png"),
      Bank(name: "Wema Bank", bankLogo: "assets/banks/wema.png"),
      Bank(name: "Zenith Bank", bankLogo: "assets/banks/zenith.png"),
    ];
  }

  Future<List<String>> fetchBankName() async {
    final all = await fetchBanks();
    return all.map((bank) => bank.name).toList();
  }
}