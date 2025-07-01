// lib/ui/auth/widgets/login_screen.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../viewmodel/login_view_model.dart';

/// Login screen with mocked authentication logic using [LoginViewModel].
///
/// Provides:
/// - Email & password fields
/// - Login button with loading state
/// - Error display if credentials are wrong
class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Text editing controllers
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    // State for obscuring password field
    final obscurePassword = useState(true);

    // Watch the auth state
    final authState = ref.watch(loginViewModelProvider);

    //Theme
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.4,
                child: Image.asset(
                  'assets/login_screen_bg.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Container(color: Colors.white.withOpacity(0.3),),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 80),
                      _TopSection(),
                      const SizedBox(height: 48),

                      //Input Fields
                      Column(
                        children: [
                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Password field with visibility toggle with forgot password button
                          Column(
                            children: [
                              TextField(
                                controller: passwordController,
                                obscureText: obscurePassword.value,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      obscurePassword.value ? Icons.visibility_off : Icons.visibility,
                                    ),
                                    onPressed: () => obscurePassword.value = !obscurePassword.value,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              Align(
                                alignment: Alignment.centerRight, // Or Alignment.topRight, Alignment.bottomRight, etc.
                                child: InkWell(
                                  onTap: () {
                                    throw UnimplementedError(
                                        "This feature has not been implemented yet"
                                    );//TODO: implement forgot password
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      'Forgot Password?',
                                      style: TextStyle(color: Color(0xff2563EB), fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      //Login Button
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [

                          // 🔐 Login Button
                          FilledButton(
                            onPressed: authState is AsyncLoading
                                ? null
                                : () {
                              ref.read(loginViewModelProvider.notifier).login(
                                emailController.text,
                                passwordController.text,
                              );
                            },

                            style: FilledButton.styleFrom(
                              fixedSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),

                            child: authState is AsyncLoading
                                ? const
                            SizedBox(
                              width: 20,
                              height: 20,
                              child:
                              CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ) :

                            Text(
                              'Login',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // ❌ Show Error Message
                          if (authState is AsyncError)
                            Text(
                              authState.error.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                        ],
                      ),

                      const Spacer(),

                      //Don't have an account?
                      RichText(
                        text: TextSpan(
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.black54,
                          ), // Default text style for the sentence
                          children: <TextSpan>[
                            const TextSpan(text: "Don't have an account? "),
                            TextSpan(
                              text: 'Create one here',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline, // Optional: underline it
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {context.go('/signup');},
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center, // Optional: if you want the whole text centered
                      ),

                      //For visual consistency
                      const SizedBox(height: 24)
                    ]
                ),
              ),
            )
          ]
      ),
      extendBody: false,
    );
  }
}

class _TopSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FlutterLogo(size: 50),

        const SizedBox(height: 20),

        Text(
          "Good to see you again 👋",
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: Color(0xFF121212),
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          "Continue with smarter payments, fewer delays,\nand total control",
          textAlign: TextAlign.start,
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ]
    );
  }
}
