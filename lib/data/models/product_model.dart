import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.category,
    required super.thumbnail,
    required super.rating,
    required super.stock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'] as int,
        title: json['title'] as String? ?? 'Sans titre',
        description: json['description'] as String? ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0,
        category: json['category'] as String? ?? 'Autre',
        thumbnail: json['thumbnail'] as String? ?? '',
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        stock: json['stock'] as int? ?? 0,
      );

  factory ProductModel.fromEntity(Product product) => ProductModel(
        id: product.id,
        title: product.title,
        description: product.description,
        price: product.price,
        category: product.category,
        thumbnail: product.thumbnail,
        rating: product.rating,
        stock: product.stock,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'category': category,
        'thumbnail': thumbnail,
        'rating': rating,
        'stock': stock,
      };
}
