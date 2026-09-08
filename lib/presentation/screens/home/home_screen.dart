import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/app_scope.dart';
import '../../widgets/product_card.dart';
import '../../widgets/status_views.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Explorer'),
        actions: [
          IconButton(onPressed: () => context.go('/profile'), icon: const Icon(Icons.person_outline), tooltip: 'Profil'),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.loadProducts,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: TextField(
                controller: _searchController,
                onSubmitted: controller.search,
                decoration: InputDecoration(
                  hintText: 'Rechercher un produit',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _searchController.clear();
                      controller.loadProducts();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
            ),
            if (controller.isOffline) const OfflineBanner(),
            Expanded(child: _content(context, controller)),
          ],
        ),
      ),
    );
  }

  Widget _content(BuildContext context, dynamic controller) {
    if (controller.isLoading) return const LoadingView(label: 'Connexion au backend...');
    if (controller.errorMessage != null) {
      return ErrorView(message: controller.errorMessage!, onRetry: controller.loadProducts);
    }
    if (controller.products.isEmpty) return const EmptyView(message: 'Aucun produit trouvé.');
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1200 ? 4 : constraints.maxWidth >= 700 ? 3 : constraints.maxWidth >= 480 ? 2 : 1;
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: columns == 1 ? 1.15 : 0.72,
          ),
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return ProductCard(product: product, onTap: () => context.go('/detail/${product.id}'));
          },
        );
      },
    );
  }
}
