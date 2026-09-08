import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({String? query});
  Future<Product> getProductById(int id);
}
