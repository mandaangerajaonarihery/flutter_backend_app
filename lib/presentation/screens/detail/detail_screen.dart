import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/app_scope.dart';
import '../../widgets/status_views.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.productId});
  final int productId;
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() { super.initState(); WidgetsBinding.instance.addPostFrameCallback((_) => AppScope.of(context).loadProduct(widget.productId)); }

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    return Scaffold(appBar: AppBar(title: const Text('Détail'), leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back))), body: controller.isLoading ? const LoadingView(label: 'Chargement du détail...') : controller.errorMessage != null ? ErrorView(message: controller.errorMessage!, onRetry: () => controller.loadProduct(widget.productId)) : controller.selectedProduct == null ? const EmptyView(message: 'Produit introuvable.') : LayoutBuilder(builder: (context, constraints) { final product = controller.selectedProduct!; final content = Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(product.category.toUpperCase(), style: Theme.of(context).textTheme.labelLarge), const SizedBox(height: 8), Text(product.title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)), const SizedBox(height: 12), Text('\u20ac${product.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 20), Text(product.description, style: Theme.of(context).textTheme.bodyLarge), const SizedBox(height: 20), Row(children: [const Icon(Icons.star, color: Colors.amber), const SizedBox(width: 6), Text('${product.rating.toStringAsFixed(1)} / 5'), const SizedBox(width: 22), Text('${product.stock} en stock')]) ])); final image = ClipRRect(borderRadius: BorderRadius.circular(18), child: Image.network(product.thumbnail, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const ColoredBox(color: Colors.black12, child: Icon(Icons.image_outlined, size: 56)))); return SingleChildScrollView(padding: const EdgeInsets.all(20), child: constraints.maxWidth >= 800 ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: AspectRatio(aspectRatio: 1, child: image)), Expanded(child: content)]) : Column(children: [AspectRatio(aspectRatio: 1.3, child: image), content])); }));
  }
}
