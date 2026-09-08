import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/app_scope.dart';
import '../../widgets/status_views.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final user = controller.user;
    if (user == null) return const EmptyView(message: 'Aucune session active.');
    return Scaffold(appBar: AppBar(title: const Text('Profil')), body: ListView(padding: const EdgeInsets.all(20), children: [Card(child: Padding(padding: const EdgeInsets.all(22), child: Row(children: [CircleAvatar(radius: 40, backgroundImage: NetworkImage(user.image)), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(user.displayName, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)), const SizedBox(height: 5), Text(user.email), Text('@${user.username}')]))]))), const SizedBox(height: 20), Card(child: Column(children: [ListTile(leading: const Icon(Icons.badge_outlined), title: const Text('Identifiant'), subtitle: Text('${user.id}')), const Divider(height: 1), ListTile(leading: const Icon(Icons.verified_user_outlined), title: const Text('État de session'), subtitle: const Text('Authentifié par le backend'))])), const SizedBox(height: 24), FilledButton.tonalIcon(onPressed: () async { await controller.logout(); if (context.mounted) context.go('/login'); }, icon: const Icon(Icons.logout), label: const Text('Se déconnecter'))]));
  }
}
