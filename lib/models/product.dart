import 'category.dart';

abstract class Product {
  final String id;
  final String title;
  final double price;
  final Category category;
  final String description;
  final String imageUrl;
  final String sellerId;
  final String sellerName;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.sellerId,
    required this.sellerName,
  });
}

mixin Sellable {
  String get listingType => 'User Listing';

  bool canBeEdited(String currentUserId, String ownerId) {
    return currentUserId == ownerId;
  }
}

class ApiProduct extends Product {
  ApiProduct({
    required super.id,
    required super.title,
    required super.price,
    required super.category,
    required super.description,
    required super.imageUrl,
    required super.sellerId,
    required super.sellerName,
  });
}

class UserProduct extends Product with Sellable {
  UserProduct({
    required super.id,
    required super.title,
    required super.price,
    required super.category,
    required super.description,
    required super.imageUrl,
    required super.sellerId,
    required super.sellerName,
  });
}