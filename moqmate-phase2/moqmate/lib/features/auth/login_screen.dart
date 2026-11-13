import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../core/validators.dart';
import '../../core/widgets.dart';
import '../../services/auth_service.dart';
import '../../services/providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ref.read(authServiceProvider).signIn(email: _email.text, password: _password.text);
    } catch (e) {
      if (mounted) showMessage(context, AuthService.messageFor(e), error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _forgot() async {
    final err = Validators.email(_email.text);
    if (err != null) {
      showMessage(context, 'Enter your email above first.', error: true);
      return;
    }
    try {
      await ref.read(authServiceProvider).sendPasswordReset(_email.text);
      if (mounted) showMessage(context, 'If an account exists for that email, a reset link has been sent.');
    } catch (e) {
      if (mounted) showMessage(context, AuthService.messageFor(e), error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.groups_rounded, size: 56, color: AppColors.crimson),
                    const SizedBox(height: 12),
                    const Text('Welcome back',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.wine)),
                    const SizedBox(height: 4),
                    const Text('Buy Together. Pay Less. Grow Together.',
                        textAlign: TextAlign.center, style: TextStyle(color: AppColors.burgundy)),
                    const SizedBox(height: 28),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      decoration: inputDec('Email', icon: Icons.mail_outline),
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _password,
                      obscureText: _obscure,
                      decoration: inputDec('Password',
                          icon: Icons.lock_outline,
                          suffix: IconButton(
                            icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          )),
                      validator: (v) => (v == null || v.isEmpty) ? 'Password is required' : null,
                      onFieldSubmitted: (_) => _submit(),
                    ),
                    Align(alignment: Alignment.centerRight, child: TextButton(onPressed: _forgot, child: const Text('Forgot password?'))),
                    const SizedBox(height: 8),
                    AsyncButton(label: 'Sign in', loading: _loading, onPressed: _submit),
                    const SizedBox(height: 12),
                    TextButton(onPressed: () => context.go('/register'), child: const Text('New to MOQMate? Create an account')),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
