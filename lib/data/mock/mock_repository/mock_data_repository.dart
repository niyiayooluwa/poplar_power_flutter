import 'dart:async';

import '../../../domain/models/data_bundle.dart';
import '../../../domain/models/internet_service_provider.dart';

/// Repository responsible for fetching Internet Service Providers and their data bundles.
/// TODO(): Replace this mock logic with actual API/service layer later on.
class DataBundleRepository {
  /// Simulated delay for asynchronous fetch.
  static const _delay = Duration(milliseconds: 300);

  /// Fetches a list of ISPs and their associated data bundles.
  Future<List<InternetServiceProvider>> fetchISPs() async {
    await Future.delayed(_delay);

    return [
      InternetServiceProvider(
        name: 'MTN',
        bundles: [
          DataBundle(name: 'Daily 100MB', price: 100, validity: '1 Day'),
          DataBundle(name: 'Daily 300MB', price: 200, validity: '1 Day'),
          DataBundle(name: 'Daily 500MB', price: 300, validity: '1 Day'),
          DataBundle(name: 'Weekly 750MB', price: 500, validity: '7 Days'),
          DataBundle(name: 'Weekly 1.5GB', price: 1000, validity: '7 Days'),
          DataBundle(name: 'Weekly 3GB', price: 1500, validity: '7 Days'),
          DataBundle(name: 'Monthly 1.5GB', price: 1000, validity: '30 Days'),
          DataBundle(name: 'Monthly 3GB', price: 2000, validity: '30 Days'),
          DataBundle(name: 'Monthly 5GB', price: 2500, validity: '30 Days'),
          DataBundle(name: 'Monthly 10GB', price: 4500, validity: '30 Days'),
          DataBundle(name: 'Monthly 20GB', price: 8000, validity: '30 Days'),
          DataBundle(name: 'Night 1GB', price: 200, validity: '12AM-5AM'),
          DataBundle(name: 'Night 2.5GB', price: 500, validity: '12AM-5AM'),
          DataBundle(name: 'Social Pack 500MB', price: 200, validity: '7 Days'),
          DataBundle(name: 'YouTube 3GB', price: 1000, validity: '14 Days'),
        ],
      ),
      InternetServiceProvider(
        name: 'Airtel',
        bundles: [
          DataBundle(name: 'Daily 200MB', price: 200, validity: '1 Day'),
          DataBundle(name: 'Daily 400MB', price: 300, validity: '1 Day'),
          DataBundle(name: 'Daily 1GB', price: 500, validity: '1 Day'),
          DataBundle(name: 'Weekly 1GB', price: 550, validity: '7 Days'),
          DataBundle(name: 'Weekly 2GB', price: 1000, validity: '7 Days'),
          DataBundle(name: 'Weekly 4GB', price: 1800, validity: '7 Days'),
          DataBundle(name: 'Monthly 3GB', price: 1200, validity: '30 Days'),
          DataBundle(name: 'Monthly 6GB', price: 2000, validity: '30 Days'),
          DataBundle(name: 'Monthly 10GB', price: 3500, validity: '30 Days'),
          DataBundle(name: 'Monthly 15GB', price: 5000, validity: '30 Days'),
          DataBundle(name: 'Monthly 30GB', price: 9000, validity: '30 Days'),
          DataBundle(name: 'Social Pack 300MB', price: 100, validity: '7 Days'),
          DataBundle(name: 'Night 1.5GB', price: 300, validity: '11PM-6AM'),
          DataBundle(name: 'Video Pack 5GB', price: 1500, validity: '14 Days'),
          DataBundle(name: '2-Hour 100MB', price: 50, validity: '2 Hours'),
        ],
      ),
      InternetServiceProvider(
        name: 'GLO',
        bundles: [
          DataBundle(name: 'Daily 90MB', price: 50, validity: '1 Day'),
          DataBundle(name: 'Daily 250MB', price: 100, validity: '1 Day'),
          DataBundle(name: 'Daily 1GB', price: 200, validity: '1 Day'),
          DataBundle(name: 'Weekly 500MB', price: 300, validity: '7 Days'),
          DataBundle(name: 'Weekly 1.2GB', price: 600, validity: '7 Days'),
          DataBundle(name: 'Weekly 2.5GB', price: 1200, validity: '7 Days'),
          DataBundle(name: 'Monthly 2GB', price: 800, validity: '30 Days'),
          DataBundle(name: 'Monthly 5GB', price: 2000, validity: '30 Days'),
          DataBundle(name: 'Monthly 7GB', price: 2500, validity: '30 Days'),
          DataBundle(name: 'Monthly 12GB', price: 4000, validity: '30 Days'),
          DataBundle(name: 'Monthly 25GB', price: 7500, validity: '30 Days'),
          DataBundle(name: 'Night 1GB', price: 100, validity: '1AM-5AM'),
          DataBundle(name: 'Night 3GB', price: 200, validity: '1AM-5AM'),
          DataBundle(name: 'Video Pack 3GB', price: 1000, validity: '14 Days'),
          DataBundle(name: 'Social Pack 1GB', price: 300, validity: '7 Days'),
        ],
      ),
      InternetServiceProvider(
        name: '9mobile',
        bundles: [
          DataBundle(name: 'Daily 150MB', price: 150, validity: '1 Day'),
          DataBundle(name: 'Daily 350MB', price: 250, validity: '1 Day'),
          DataBundle(name: 'Daily 750MB', price: 400, validity: '1 Day'),
          DataBundle(name: 'Weekly 600MB', price: 400, validity: '7 Days'),
          DataBundle(name: 'Weekly 1.5GB', price: 800, validity: '7 Days'),
          DataBundle(name: 'Weekly 3GB', price: 1500, validity: '7 Days'),
          DataBundle(name: 'Monthly 2.5GB', price: 1500, validity: '30 Days'),
          DataBundle(name: 'Monthly 5GB', price: 2500, validity: '30 Days'),
          DataBundle(name: 'Monthly 8GB', price: 3000, validity: '30 Days'),
          DataBundle(name: 'Monthly 15GB', price: 5000, validity: '30 Days'),
          DataBundle(name: 'Monthly 40GB', price: 10000, validity: '30 Days'),
          DataBundle(name: 'YouTube Pack 4GB', price: 500, validity: '7 Days'),
          DataBundle(name: 'Night 2GB', price: 250, validity: '12AM-5AM'),
          DataBundle(name: 'Social Pack 200MB', price: 100, validity: '7 Days'),
          DataBundle(name: 'Weekend 2GB', price: 500, validity: 'Sat-Sun'),
        ],
      ),
      InternetServiceProvider(
        name: 'Smile',
        bundles: [
          DataBundle(name: 'Daily 500MB', price: 300, validity: '1 Day'),
          DataBundle(name: 'Daily 1GB', price: 500, validity: '1 Day'),
          DataBundle(name: 'Daily 2GB', price: 800, validity: '1 Day'),
          DataBundle(name: 'Weekly 3GB', price: 1500, validity: '7 Days'),
          DataBundle(name: 'Weekly 6GB', price: 2500, validity: '7 Days'),
          DataBundle(name: 'Weekly 10GB', price: 4000, validity: '7 Days'),
          DataBundle(name: 'Monthly 10GB', price: 5000, validity: '30 Days'),
          DataBundle(name: 'Monthly 20GB', price: 8000, validity: '30 Days'),
          DataBundle(name: 'Monthly 40GB', price: 12000, validity: '30 Days'),
          DataBundle(name: 'Monthly 75GB', price: 18000, validity: '30 Days'),
          DataBundle(name: 'Monthly Unlimited', price: 15000, validity: '30 Days'),
          DataBundle(name: 'Night 5GB', price: 1000, validity: '12AM-5AM'),
          DataBundle(name: 'Weekday 10GB', price: 3500, validity: 'Mon-Fri'),
          DataBundle(name: 'Weekend 15GB', price: 4000, validity: 'Sat-Sun'),
          DataBundle(name: 'Business 50GB', price: 15000, validity: '30 Days'),
        ],
      ),
      InternetServiceProvider(
        name: 'Spectranet',
        bundles: [
          DataBundle(name: 'Daily 1GB', price: 500, validity: '1 Day'),
          DataBundle(name: 'Daily 2GB', price: 800, validity: '1 Day'),
          DataBundle(name: 'Daily 5GB', price: 1500, validity: '1 Day'),
          DataBundle(name: 'Weekly 7GB', price: 2500, validity: '7 Days'),
          DataBundle(name: 'Weekly 15GB', price: 5000, validity: '7 Days'),
          DataBundle(name: 'Weekly 25GB', price: 8000, validity: '7 Days'),
          DataBundle(name: 'Monthly 20GB', price: 8000, validity: '30 Days'),
          DataBundle(name: 'Monthly 50GB', price: 15000, validity: '30 Days'),
          DataBundle(name: 'Monthly 100GB', price: 25000, validity: '30 Days'),
          DataBundle(name: 'Monthly 200GB', price: 40000, validity: '30 Days'),
          DataBundle(name: 'Monthly Unlimited', price: 30000, validity: '30 Days'),
          DataBundle(name: 'Night 10GB', price: 2000, validity: '12AM-6AM'),
          DataBundle(name: 'Weekend 20GB', price: 5000, validity: 'Sat-Sun'),
          DataBundle(name: 'Gaming 30GB', price: 10000, validity: '30 Days'),
          DataBundle(name: 'Family 100GB', price: 20000, validity: '30 Days'),
        ],
      ),
      InternetServiceProvider(
        name: 'Swift',
        bundles: [
          DataBundle(name: 'Night 2GB', price: 300, validity: '12AM-5AM'),
          DataBundle(name: 'Night 5GB', price: 600, validity: '12AM-5AM'),
          DataBundle(name: 'Night 10GB', price: 1000, validity: '12AM-5AM'),
          DataBundle(name: 'Weekly 5GB', price: 2000, validity: '7 Days'),
          DataBundle(name: 'Weekly 10GB', price: 3500, validity: '7 Days'),
          DataBundle(name: 'Weekly 20GB', price: 6000, validity: '7 Days'),
          DataBundle(name: 'Monthly 15GB', price: 6000, validity: '30 Days'),
          DataBundle(name: 'Monthly 30GB', price: 10000, validity: '30 Days'),
          DataBundle(name: 'Monthly 50GB', price: 15000, validity: '30 Days'),
          DataBundle(name: 'Monthly 80GB', price: 20000, validity: '30 Days'),
          DataBundle(name: 'Monthly 120GB', price: 25000, validity: '30 Days'),
          DataBundle(name: 'Weekday 5GB', price: 1500, validity: 'Mon-Fri'),
          DataBundle(name: 'Weekend 10GB', price: 2000, validity: 'Sat-Sun'),
          DataBundle(name: 'Streaming 25GB', price: 8000, validity: '30 Days'),
          DataBundle(name: 'Office 40GB', price: 12000, validity: '30 Days'),
        ],
      ),
      InternetServiceProvider(
        name: 'Tizeti',
        bundles: [
          DataBundle(name: 'Daily Unlimited', price: 500, validity: '1 Day'),
          DataBundle(name: 'Daily 5GB', price: 300, validity: '1 Day'),
          DataBundle(name: 'Daily 10GB', price: 500, validity: '1 Day'),
          DataBundle(name: 'Weekly Unlimited', price: 2500, validity: '7 Days'),
          DataBundle(name: 'Weekly 20GB', price: 2000, validity: '7 Days'),
          DataBundle(name: 'Weekly 40GB', price: 3500, validity: '7 Days'),
          DataBundle(name: 'Monthly Unlimited', price: 10000, validity: '30 Days'),
          DataBundle(name: 'Monthly 50GB', price: 8000, validity: '30 Days'),
          DataBundle(name: 'Monthly 100GB', price: 12000, validity: '30 Days'),
          DataBundle(name: 'Monthly 200GB', price: 18000, validity: '30 Days'),
          DataBundle(name: 'Monthly 500GB', price: 30000, validity: '30 Days'),
          DataBundle(name: 'Night Unlimited', price: 1000, validity: '12AM-5AM'),
          DataBundle(name: 'Family 150GB', price: 15000, validity: '30 Days'),
          DataBundle(name: 'Business 300GB', price: 25000, validity: '30 Days'),
          DataBundle(name: 'Gamer 100GB', price: 12000, validity: '30 Days'),
        ],
      ),
    ];
  }

  /// Fetches a list of ISP names for SmartInput dropdowns or search.
  Future<List<String>> fetchAvailableISPs() async {
    final all = await fetchISPs();
    return all.map((provider) => provider.name).toList();
  }
}
