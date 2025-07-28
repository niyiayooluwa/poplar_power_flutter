import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/ui/profile/viewmodel/profile_viewmodel.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileViewModelProvider);
    final profileViewModel = ref.read(profileViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (profileState.isLoading)
                const Center(child: CircularProgressIndicator())
              else
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('Full Name'),
                        subtitle: Text(profileState.profile!.fullName),
                      ),
                      ListTile(
                        title: const Text('Email'),
                        subtitle: Text(profileState.profile!.email),
                      ),
                      ListTile(
                        title: const Text('Phone Number'),
                        subtitle: Text(profileState.profile!.phoneNumber),
                      ),
                    ],
                  ),
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
                  onPressed: () => profileViewModel.changePassword(),
                  child: const Text('Change Password'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
