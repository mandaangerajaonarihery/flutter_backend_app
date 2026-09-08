import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:flutter_backend_app/core/errors/app_exceptions.dart';
import 'package:flutter_backend_app/core/network/dio_client.dart';
import 'package:flutter_backend_app/core/storage/local_storage.dart';
import 'package:flutter_backend_app/core/storage/token_storage.dart';
import 'package:flutter_backend_app/data/datasources/local/product_local_data_source.dart';
import 'package:flutter_backend_app/data/datasources/remote/product_remote_data_source.dart';
import 'package:flutter_backend_app/data/models/product_model.dart';
import 'package:flutter_backend_app/data/repositories/product_repository_impl.dart';

class FakeRemote extends ProductRemoteDataSource {
  FakeRemote(this.products, {this.failure}) : super(DioClient(SecureTokenStorage()));

  final List<ProductModel> products;
  final AppException? failure;

  @override
  Future<List<ProductModel>> getProducts({String? query}) async {
    if (failure != null) throw failure!;
    return products;
  }
}

class FakeLocal extends ProductLocalDataSource {
  FakeLocal(this.products) : super(LocalStorage(_box));

  static final _box = Hive.box<dynamic>('repository_test_cache');
  List<ProductModel> products;

  @override
  Future<void> cacheProducts(List<dynamic> products) async {
    this.products = products.cast<ProductModel>();
  }

  @override
  List<ProductModel> getCachedProducts() {
    if (products.isEmpty) throw const CacheException('Cache vide');
    return products;
  }
}

ProductModel product(int id) => ProductModel(id: id, title: 'Product $id', description: 'Description', price: 10, category: 'test', thumbnail: 'image', rating: 4, stock: 2);

void main() {
  setUpAll(() async {
    Hive.init(Directory.systemTemp.path);
    await Hive.openBox<dynamic>('repository_test_cache');
  });

  tearDownAll(() async {
    await Hive.close();
  });

  test('repository returns products from the remote API', () async {
    final remote = FakeRemote([product(1)]);
    final repository = ProductRepositoryImpl(remote, FakeLocal([]));

    final result = await repository.getProducts();

    expect(result.single.id, 1);
  });

  test('repository falls back to Hive cache when network fails', () async {
    final remote = FakeRemote([], failure: const NetworkException());
    final repository = ProductRepositoryImpl(remote, FakeLocal([product(2)]));

    final result = await repository.getProducts();

    expect(result.single.id, 2);
  });

  test('repository exposes a meaningful error when API and cache fail', () async {
    final remote = FakeRemote([], failure: const NetworkException());
    final repository = ProductRepositoryImpl(remote, FakeLocal([]));

    expect(repository.getProducts(), throwsA(isA<CacheException>()));
  });
}
