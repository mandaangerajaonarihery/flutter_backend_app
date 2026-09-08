import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/app_scope.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmation.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    final controller = AppScope.of(context);
    final success = await controller.register(_email.text.trim(), _password.text);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Compte créé par l’API. Vous pouvez vous connecter.'
              : controller.errorMessage ?? 'Inscription impossible.',
        ),
      ),
    );
    if (success) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Créer un compte')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppTextField(controller: _email, label: 'Email', keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 16),
                    AppTextField(controller: _password, label: 'Password', obscureText: true),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmation,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Confirmer le password', prefixIcon: Icon(Icons.lock_outline)),
                      validator: (value) => value != _password.text ? 'Les passwords ne correspondent pas' : null,
                    ),
                    const SizedBox(height: 24),
                    AppButton(label: 'Créer le compte', isLoading: controller.isLoading, onPressed: _register),
                    const SizedBox(height: 12),
                    TextButton(onPressed: () => context.go('/login'), child: const Text('J’ai déjà un compte')),
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
