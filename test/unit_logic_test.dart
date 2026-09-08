import 'dart:io';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:flutter_backend_app/core/errors/app_exceptions.dart';
import 'package:flutter_backend_app/core/localization/app_localizations.dart';
import 'package:flutter_backend_app/core/network/dio_client.dart';
import 'package:flutter_backend_app/core/storage/local_storage.dart';
import 'package:flutter_backend_app/core/storage/token_storage.dart';
import 'package:flutter_backend_app/data/datasources/local/product_local_data_source.dart';
import 'package:flutter_backend_app/data/datasources/remote/product_remote_data_source.dart';
import 'package:flutter_backend_app/data/models/product_model.dart';
import 'package:flutter_backend_app/data/repositories/product_repository_impl.dart';
import 'package:flutter_backend_app/domain/entities/product.dart';
import 'package:flutter_backend_app/domain/entities/user.dart';
import 'package:flutter_backend_app/domain/repositories/auth_repository.dart';
import 'package:flutter_backend_app/domain/repositories/product_repository.dart';
import 'package:flutter_backend_app/presentation/controllers/app_controller.dart';

class FakeRemote extends ProductRemoteDataSource {
  FakeRemote(this.products, {this.failure}) : super(DioClient(SecureTokenStorage()));
  final List<ProductModel> products;
  final AppException? failure;

  @override
  Future<List<ProductModel>> getProducts({String? query}) async {
    if (failure != null) throw failure!;
    if (query == null || query.trim().isEmpty) return products;
    return products.where((item) => item.title.toLowerCase().contains(query.toLowerCase())).toList();
  }
}

class FakeLocal extends ProductLocalDataSource {
  FakeLocal(this.products) : super(LocalStorage(_box));
  static final _box = Hive.box<dynamic>('unit_logic_cache');
  List<ProductModel> products;

  @override
  Future<void> cacheProducts(List<dynamic> products) async => this.products = products.cast<ProductModel>();

  @override
  List<ProductModel> getCachedProducts() {
    if (products.isEmpty) throw const CacheException('Cache vide');
    return products;
  }
}

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository(this.currentUser);
  User? currentUser;
  bool loggedOut = false;

  @override
  Future<User> login(String username, String password) async => currentUser!;
  @override
  Future<User> register(String email, String password) async => currentUser!;
  @override
  Future<User?> restoreSession() async => currentUser;
  @override
  Future<User> getCurrentUser() async => currentUser!;
  @override
  Future<void> logout() async => loggedOut = true;
  @override
  Future<bool> get hasSession async => currentUser != null;
}

class FakeProductRepository implements ProductRepository {
  FakeProductRepository(this.products);
  final List<Product> products;
  @override
  Future<List<Product>> getProducts({String? query}) async => query == null ? products : products.where((item) => item.title.contains(query)).toList();
  @override
  Future<Product> getProductById(int id) async => products.firstWhere((item) => item.id == id);
}

ProductModel product(int id, [String title = 'Product']) => ProductModel(id: id, title: '$title $id', description: 'Description', price: 10, category: 'test', thumbnail: 'image', rating: 4, stock: 2);
User user() => const User(id: 1, username: 'demo', email: 'demo@example.com', firstName: 'Demo', lastName: 'User', image: '');

void main() {
  setUpAll(() async {
    Hive.init(Directory.systemTemp.path);
    await Hive.openBox<dynamic>('unit_logic_cache');
  });
  tearDownAll(Hive.close);

  test('ProductModel parses optional numeric values', () {
    final result = ProductModel.fromJson({'id': 1, 'title': 'A', 'price': 12, 'rating': 4, 'stock': 3});
    expect(result.price, 12.0);
    expect(result.rating, 4.0);
  });
  test('ProductModel serializes its complete data', () => expect(product(1).toJson()['id'], 1));
  test('User exposes a display name', () => expect(user().displayName, 'Demo User'));
  test('repository returns remote products', () async {
    final result = await ProductRepositoryImpl(FakeRemote([product(1)]), FakeLocal([])).getProducts();
    expect(result.single.id, 1);
  });
  test('repository filters remote products by query', () async {
    final result = await ProductRepositoryImpl(FakeRemote([product(1, 'Apple'), product(2, 'Bread')]), FakeLocal([])).getProducts(query: 'apple');
    expect(result.single.id, 1);
  });
  test('repository falls back to cached products', () async {
    final result = await ProductRepositoryImpl(FakeRemote([], failure: const NetworkException()), FakeLocal([product(2)])).getProducts();
    expect(result.single.id, 2);
  });
  test('repository reports cache failure when both sources fail', () async {
    expect(ProductRepositoryImpl(FakeRemote([], failure: const NetworkException()), FakeLocal([])).getProducts(), throwsA(isA<CacheException>()));
  });
  test('controller restores an authenticated session', () async {
    final controller = AppController(FakeAuthRepository(user()), FakeProductRepository([product(1)]));
    await controller.restoreSession();
    expect(controller.isAuthenticated, isTrue);
    expect(controller.products, hasLength(1));
  });
  test('controller loads a selected product', () async {
    final controller = AppController(FakeAuthRepository(user()), FakeProductRepository([product(3)]));
    await controller.loadProduct(3);
    expect(controller.selectedProduct?.id, 3);
  });
  test('controller logout clears session and products', () async {
    final auth = FakeAuthRepository(user());
    final controller = AppController(auth, FakeProductRepository([product(1)]));
    await controller.restoreSession();
    await controller.logout();
    expect(controller.isAuthenticated, isFalse);
    expect(controller.products, isEmpty);
    expect(auth.loggedOut, isTrue);
  });
  test('localization provides French and English labels', () {
    expect(AppLocalizations(const Locale('fr')).login, 'Connexion');
    expect(AppLocalizations(const Locale('en')).login, 'Sign in');
  });
}
