import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/category.dart';
import '../../models/product.dart';
import '../../services/api_service.dart';
import '../../services/firestore_service.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ApiService apiService;
  final FirestoreService firestoreService;

  String? _userId;

  ProductsCubit(
      this.apiService,
      this.firestoreService,
      ) : super(ProductsLoading());

  void setUser(String userId) {
    if (_userId == userId && state is ProductsLoaded) {
      return;
    }

    _userId = userId;
    loadProducts();
  }

  Future<void> loadProducts() async {
    final userId = _userId;

    if (userId == null) {
      return;
    }

    emit(ProductsLoading());

    try {
      final apiData = await apiService.getProducts();

      final apiProducts = apiData.map((json) {
        final data = json as Map<String, dynamic>;

        return ApiProduct(
          id: 'api_${data['id']}',
          title: data['title']?.toString() ?? 'Product',
          price: (data['price'] as num?)?.toDouble() ?? 0,
          category: _convertCategory(
            data['category']?.toString(),
          ),
          description:
          data['description']?.toString() ?? '',
          imageUrl:
          data['image']?.toString() ?? '',
          sellerId: 'api',
          sellerName: 'Souq Corner',
        );
      }).toList();

      final listingSnapshot =
      await firestoreService.getListings(userId);

      final userProducts =
      listingSnapshot.docs.map((doc) {
        final data = doc.data();

        return UserProduct(
          id: doc.id,
          title: data['title']?.toString() ?? '',
          price:
          (data['price'] as num?)?.toDouble() ?? 0,
          category: _convertCategory(
            data['category']?.toString(),
          ),
          description:
          data['description']?.toString() ?? '',
          imageUrl:
          data['imageUrl']?.toString() ?? '',
          sellerId:
          data['sellerId']?.toString() ?? '',
          sellerName:
          data['sellerName']?.toString() ?? '',
        );
      }).toList();

      final favorites =
      await firestoreService.getFavoriteIds(userId);

      emit(
        ProductsLoaded(
          products: [
            ...apiProducts,
            ...userProducts,
          ],
          favoriteIds: favorites,
        ),
      );
    } on DioException catch (error) {
      emit(
        ProductsError(
          error.message ?? 'Failed to load products',
        ),
      );
    } catch (error) {
      emit(
        ProductsError(
          'Something went wrong while loading products',
        ),
      );
    }
  }

  Future<void> toggleFavorite(String productId) async {
    final currentState = state;
    final userId = _userId;

    if (currentState is! ProductsLoaded ||
        userId == null) {
      return;
    }

    final updatedFavorites =
    Set<String>.from(currentState.favoriteIds);

    try {
      if (updatedFavorites.contains(productId)) {
        updatedFavorites.remove(productId);

        await firestoreService.removeFavorite(
          userId,
          productId,
        );
      } else {
        updatedFavorites.add(productId);

        await firestoreService.addFavorite(
          userId,
          productId,
        );
      }

      emit(
        ProductsLoaded(
          products: currentState.products,
          favoriteIds: updatedFavorites,
        ),
      );
    } catch (error) {
      emit(
        ProductsError(
          'Failed to update favorite',
        ),
      );

      emit(
        ProductsLoaded(
          products: currentState.products,
          favoriteIds: currentState.favoriteIds,
        ),
      );
    }
  }

  Future<void> addListing({
    required String title,
    required double price,
    required Category category,
    required String description,
    required String imageUrl,
    required String sellerName,
  }) async {
    final userId = _userId;

    if (userId == null) {
      return;
    }

    try {
      await firestoreService.addListing(
        userId,
        {
          'title': title,
          'price': price,
          'category': category.name,
          'description': description,
          'imageUrl': imageUrl,
          'sellerId': userId,
          'sellerName': sellerName,
          'createdAt': DateTime.now(),
        },
      );

      await loadProducts();
    } catch (error) {
      emit(
        ProductsError(
          'Failed to add listing',
        ),
      );
    }
  }

  Future<void> updateListing({
    required String listingId,
    required String title,
    required double price,
    required Category category,
    required String description,
    required String imageUrl,
  }) async {
    final userId = _userId;

    if (userId == null) {
      return;
    }

    try {
      await firestoreService.updateListing(
        userId,
        listingId,
        {
          'title': title,
          'price': price,
          'category': category.name,
          'description': description,
          'imageUrl': imageUrl,
        },
      );

      await loadProducts();
    } catch (error) {
      emit(
        ProductsError(
          'Failed to update listing',
        ),
      );
    }
  }

  Future<void> deleteListing(String listingId) async {
    final userId = _userId;

    if (userId == null) {
      return;
    }

    try {
      await firestoreService.deleteListing(
        userId,
        listingId,
      );

      await loadProducts();
    } catch (error) {
      emit(
        ProductsError(
          'Failed to delete listing',
        ),
      );
    }
  }

  Category _convertCategory(String? category) {
    if (category == null) {
      return Category.other;
    }

    final value = category.toLowerCase();

    if (value.contains('jewel')) {
      return Category.crafts;
    }

    if (value.contains('men') ||
        value.contains('women')) {
      return Category.clothes;
    }

    if (value.contains('electronic')) {
      return Category.electronics;
    }

    if (value.contains('home')) {
      return Category.home;
    }

    if (value.contains('food')) {
      return Category.food;
    }

    if (value.contains('craft')) {
      return Category.crafts;
    }

    return Category.other;
  }
}