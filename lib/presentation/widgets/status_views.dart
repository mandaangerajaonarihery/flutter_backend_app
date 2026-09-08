import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.label = 'Chargement...'});
  final String label;
  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [const CircularProgressIndicator(), const SizedBox(height: 14), Text(label)]));
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.cloud_off, size: 52), const SizedBox(height: 12), Text(message, textAlign: TextAlign.center), const SizedBox(height: 16), FilledButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: const Text('Réessayer'))])));
}

class EmptyView extends StatelessWidget {
  const EmptyView({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) => Center(child: Text(message, textAlign: TextAlign.center));
}

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});
  @override
  Widget build(BuildContext context) => Container(width: double.infinity, color: Theme.of(context).colorScheme.tertiaryContainer, padding: const EdgeInsets.all(10), child: const Text('Mode hors ligne: dernières données disponibles affichées.', textAlign: TextAlign.center));
}
