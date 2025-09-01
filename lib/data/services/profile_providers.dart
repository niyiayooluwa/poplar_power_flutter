import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/repositories/auth_repository_impl.dart';
import 'package:poplar_power/domain/use_cases/profile/get_profile_use_case.dart';
import 'package:poplar_power/data/services/app_providers.dart';

final getProfileUseCaseProvider = Provider<GetProfileUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GetProfileUseCase(authRepository);
});
