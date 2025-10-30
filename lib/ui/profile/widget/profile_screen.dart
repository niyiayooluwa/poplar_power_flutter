import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/ui/profile/viewmodel/profile_viewmodel.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileViewModelProvider);
    final profileViewModel = ref.read(profileViewModelProvider.notifier);
    final theme = Theme.of(context);

    ref.listen<ProfileState>(profileViewModelProvider, (previous, current) {
      if (current.isLoggedOut) {
        context.go('/login');
        profileViewModel.resetLogoutStatus();
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (profileState.isLoading)
                const Center(child: CircularProgressIndicator())
              else
                Column(
                  children: [
                    Text(
                      profileState.user!.fullName,
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      profileState.user!.email,
                      style: theme.textTheme.bodyMedium,
                    ),
                    ListTile(
                      title: const Text('Phone Number'),
                      subtitle: Text(profileState.user!.phone),
                    ),
                  ],
                ),
              const SizedBox(height: 24),

              SwitchListTile(
                title: const Text('Enable Biometrics'),
                value: profileState.enableBiometrics,
                onChanged: (value) => profileViewModel.setBiometrics(value),
              ),
              const SizedBox(height: 24),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the PasswordRecoveryScreen, passing the user's email
                    context.push('/forgot-password', extra: {'email': profileState.user!.email});
                  },
                  child: const Text('Change Password'),
                ),
              ),
              const SizedBox(height: 24),

              Center(
                child: ElevatedButton(
                  onPressed: () => profileViewModel.logout(),
                  child: const Text('Logout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
