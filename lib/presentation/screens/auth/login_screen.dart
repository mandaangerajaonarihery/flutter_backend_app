import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/app_scope.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController(text: 'emilys');
  final _password = TextEditingController(text: 'emilyspass');

  @override
  void dispose() { _username.dispose(); _password.dispose(); super.dispose(); }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final controller = AppScope.of(context);
    final success = await controller.login(_username.text.trim(), _password.text);
    if (!mounted) return;
    if (!success) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(controller.errorMessage ?? 'Connexion impossible.')));
  }

  @override
  Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 460), child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.hub, size: 52, color: Theme.of(context).colorScheme.primary), const SizedBox(height: 22), Text('Flutter Backend App', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)), const SizedBox(height: 8), const Text('Explore real data, even when the connection gets quiet.'), const SizedBox(height: 30), AppTextField(controller: _username, label: 'Username'), const SizedBox(height: 16), AppTextField(controller: _password, label: 'Password', obscureText: true), const SizedBox(height: 24), AppButton(label: 'Se connecter', isLoading: AppScope.of(context).isLoading, onPressed: _login), const SizedBox(height: 14), Center(child: TextButton(onPressed: () => context.go('/register'), child: const Text('Créer un compte'))), const SizedBox(height: 12), Text('Compte de démonstration DummyJSON: emilys / emilyspass', style: Theme.of(context).textTheme.bodySmall) ])))))));
}
