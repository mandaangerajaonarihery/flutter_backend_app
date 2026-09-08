import '../../core/errors/app_exceptions.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/local/product_local_data_source.dart';
import '../datasources/remote/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this._remote, this._local);

  final ProductRemoteDataSource _remote;
  final ProductLocalDataSource _local;

  @override
  Future<List<Product>> getProducts({String? query}) async {
    try {
      final products = await _remote.getProducts(query: query);
      if (query == null || query.trim().isEmpty) await _local.cacheProducts(products);
      return products;
    } on AppException {
      if (query != null && query.trim().isNotEmpty) rethrow;
      try {
        return _local.getCachedProducts();
      } on AppException {
        rethrow;
      }
    }
  }

  @override
  Future<Product> getProductById(int id) async {
    try {
      final product = await _remote.getProductById(id);
      return product;
    } on AppException {
      final cached = _local.getCachedProducts();
      return cached.firstWhere((product) => product.id == id, orElse: () => throw const CacheException('Produit indisponible hors connexion.'));
    }
  }
}
