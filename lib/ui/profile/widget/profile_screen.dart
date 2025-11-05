import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/ui/profile/viewmodel/profile_viewmodel.dart';

import '../../../core/application/user_provider.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final profileViewModel = ref.read(profileViewModelProvider.notifier);
    final theme = Theme.of(context);

    ref.listen<ProfileState>(profileViewModelProvider, (previous, current) {
      if (current.isLoggedOut) {
        context.go('/login');
        profileViewModel.resetLogoutStatus();
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: userState.user.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Not logged in'));
          }
          return CustomScrollView(
            slivers: [
              // App Bar with gradient
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: theme.colorScheme.primary,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.primary.withValues(alpha:0.8),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          // Avatar with initials
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha:0.3),
                              border: Border.all(
                                color: Colors.white.withValues(alpha:0.5),
                                width: 3,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                _getInitials(user.fullName),
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            user.fullName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Personal Information Card
                      _buildCard(
                        context,
                        title: 'PERSONAL INFORMATION',
                        children: [
                          _buildInfoTile(
                            icon: Icons.email_outlined,
                            label: 'Email',
                            value: user.email,
                          ),
                          const Divider(height: 1),
                          _buildInfoTile(
                            icon: Icons.phone_outlined,
                            label: 'Phone',
                            value: user.phone,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Security Card
                      _buildCard(
                        context,
                        title: 'SECURITY',
                        children: [
                          _buildActionTile(
                            icon: Icons.lock_outline,
                            title: 'Change Password',
                            onTap: () {
                              context.push(
                                '/forgot-password',
                                extra: {'email': user.email},
                              );
                            },
                          ),

                          _buildActionTile(
                            icon: Icons.pin,
                            title: 'Reset Pin',
                            onTap: () {
                              final accountNo = user.walletAccountNo;
                              if (accountNo != null) {
                                context.push(
                                  '/reset-pin',
                                  extra: {'account': accountNo},
                                );
                              }
                            },
                          ),

                          if (profileViewModel.state.canCheckBiometrics) ...[
                            const Divider(height: 1),
                            _buildSwitchTile(
                              icon: Icons.fingerprint,
                              title: 'Enable Biometrics',
                              value: profileViewModel.state.enableBiometrics,
                              onChanged: (value) =>
                                  profileViewModel.setBiometrics(value),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Logout Card
                      _buildCard(
                        context,
                        children: [
                          _buildActionTile(
                            icon: Icons.logout,
                            title: 'Log Out',
                            onTap: () =>
                                _showLogoutDialog(context, profileViewModel),
                            isDestructive: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // App Version
                      Text(
                        'App Version 1.0.0',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    String? title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Divider(height: 1, color: Colors.grey[100]),
          ],
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[400]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isDestructive ? Colors.red : Colors.grey[700],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isDestructive ? Colors.red : Colors.black87,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    return name
        .split(' ')
        .map((n) => n.isNotEmpty ? n[0] : '')
        .take(2)
        .join('')
        .toUpperCase();
  }

  void _showLogoutDialog(BuildContext context, ProfileViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              viewModel.logout();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
