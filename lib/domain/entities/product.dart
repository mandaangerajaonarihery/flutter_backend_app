class Product {
  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.thumbnail,
    this.rating = 0,
    this.stock = 0,
  });

  final int id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String thumbnail;
  final double rating;
  final int stock;
}
