import '../../models/product.dart';

abstract class ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final Set<String> favoriteIds;

  ProductsLoaded({
    required this.products,
    required this.favoriteIds,
  });
}

class ProductsError extends ProductsState {
  final String message;

  ProductsError(this.message);
}