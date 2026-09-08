import 'package:dio/dio.dart';

import '../../../core/errors/app_exceptions.dart';
import '../../../core/network/dio_client.dart';
import '../../models/product_model.dart';

class ProductRemoteDataSource {
  const ProductRemoteDataSource(this._client);

  final DioClient _client;

  Future<List<ProductModel>> getProducts({String? query}) async {
    try {
      final response = await _client.dio.get('/products', queryParameters: {'limit': 30});
      final products = (response.data['products'] as List).cast<Map<String, dynamic>>();
      final mapped = products.map(ProductModel.fromJson).toList();
      if (query == null || query.trim().isEmpty) return mapped;
      final normalized = query.toLowerCase();
      return mapped.where((product) => product.title.toLowerCase().contains(normalized)).toList();
    } on DioException catch (error) {
      throw _mapError(error);
    }
  }

  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await _client.dio.get('/products/$id');
      return ProductModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw _mapError(error);
    }
  }

  AppException _mapError(DioException error) {
    if (error.response?.statusCode == 401) return const UnauthorizedException();
    if (error.response?.statusCode != null) return const ServerException();
    return const NetworkException();
  }
}
