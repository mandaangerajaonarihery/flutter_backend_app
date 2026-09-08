import 'package:flutter/foundation.dart';

import '../../core/errors/app_exceptions.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/product_repository.dart';

class AppController extends ChangeNotifier {
  AppController(this._authRepository, this._productRepository);

  final AuthRepository _authRepository;
  final ProductRepository _productRepository;

  User? user;
  List<Product> products = const [];
  Product? selectedProduct;
  bool isStarting = true;
  bool isLoading = false;
  bool isAuthenticated = false;
  bool isOffline = false;
  String? errorMessage;

  Future<void> restoreSession() async {
    isStarting = true;
    notifyListeners();
    user = await _authRepository.restoreSession();
    isAuthenticated = user != null;
    isStarting = false;
    notifyListeners();
    if (isAuthenticated) await loadProducts();
  }

  Future<bool> login(String username, String password) async {
    return _runAuth(() async {
      user = await _authRepository.login(username, password);
      isAuthenticated = true;
      await loadProducts();
    });
  }

  Future<bool> register(String email, String password) async {
    return _runAuth(() async {
      await _authRepository.register(email, password);
    });
  }

  Future<void> logout() async {
    await _authRepository.logout();
    user = null;
    isAuthenticated = false;
    products = const [];
    notifyListeners();
  }

  Future<void> loadProducts({String? query}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      products = await _productRepository.getProducts(query: query);
      isOffline = false;
    } on AppException catch (error) {
      errorMessage = error.message;
      isOffline = error is CacheException;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> search(String query) => loadProducts(query: query);

  Future<void> loadProduct(int id) async {
    isLoading = true;
    errorMessage = null;
    selectedProduct = null;
    notifyListeners();
    try {
      selectedProduct = await _productRepository.getProductById(id);
      isOffline = false;
    } on AppException catch (error) {
      errorMessage = error.message;
      isOffline = error is CacheException;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> _runAuth(Future<void> Function() action) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await action();
      return true;
    } on AppException catch (error) {
      errorMessage = error.message;
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
