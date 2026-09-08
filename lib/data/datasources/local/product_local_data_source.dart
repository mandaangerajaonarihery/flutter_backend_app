import '../../../core/storage/local_storage.dart';
import '../../../domain/entities/product.dart';

class ProductLocalDataSource {
  const ProductLocalDataSource(this._storage);

  final LocalStorage _storage;

  Future<void> cacheProducts(List<Product> products) => _storage.cacheProducts(products);

  List<Product> getCachedProducts() => _storage.readProducts();
}
