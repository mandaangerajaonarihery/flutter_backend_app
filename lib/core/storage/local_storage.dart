import 'dart:convert';

import 'package:hive/hive.dart';

import '../constants/app_constants.dart';
import '../errors/app_exceptions.dart';
import '../../domain/entities/product.dart';

class LocalStorage {
  const LocalStorage(this._box);

  final Box<dynamic> _box;

  Future<void> cacheProducts(List<Product> products) async {
    await _box.put(AppConstants.productsBox, products.map(_toMap).toList());
  }

  List<Product> readProducts() {
    final raw = _box.get(AppConstants.productsBox);
    if (raw is! List) throw const CacheException('Aucun produit en cache.');
    try {
      return raw.map((item) => _fromMap(Map<String, dynamic>.from(item as Map))).toList();
    } catch (_) {
      throw const CacheException();
    }
  }

  Map<String, dynamic> _toMap(Product product) => {
        'id': product.id,
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'category': product.category,
        'thumbnail': product.thumbnail,
        'rating': product.rating,
        'stock': product.stock,
      };

  Product _fromMap(Map<String, dynamic> map) => Product(
        id: map['id'] as int,
        title: map['title'] as String,
        description: map['description'] as String,
        price: (map['price'] as num).toDouble(),
        category: map['category'] as String,
        thumbnail: map['thumbnail'] as String,
        rating: (map['rating'] as num).toDouble(),
        stock: map['stock'] as int,
      );

  String encodeProduct(Product product) => jsonEncode(_toMap(product));
}
