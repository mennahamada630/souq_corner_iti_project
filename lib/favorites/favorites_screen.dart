import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app_theme.dart';
import '../products/product_card.dart';
import '../products/products_cubit/products_cubit.dart';
import '../products/products_cubit/products_state.dart';
import '../products/screens/product_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final bool embedded;

 const FavoritesScreen({
    super.key,
    this.embedded = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          if (!embedded)
            _buildHeader(context),
          if (embedded)
            Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                18,
                20,
                10,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Favorites',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Expanded(
            child: BlocBuilder<
                ProductsCubit,
                ProductsState>(
              builder: (context, state) {
                if (state is ProductsLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  );
                }

                if (state is ProductsError) {
                  return Center(
                    child: Text(state.message),
                  );
                }

                if (state is ProductsLoaded) {
                  final favorites =
                  state.products.where(
                        (product) {
                      return state.favoriteIds
                          .contains(product.id);
                    },
                  ).toList();

                  if (favorites.isEmpty) {
                    return _emptyState();
                  }

                  return GridView.builder(
                    padding: EdgeInsets.fromLTRB(
                      18,
                      8,
                      18,
                      20,
                    ),
                    gridDelegate:
                    SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 220,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.74,
                    ),
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final product =
                      favorites[index];

                      return ProductCard(
                        product: product,
                        isFavorite: true,
                        onFavorite: () {
                          context
                              .read<ProductsCubit>()
                              .toggleFavorite(
                            product.id,
                          );
                        },
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailsScreen(
                                    product: product,
                                  ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }

                return SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        18,
        20,
        10,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
          Text(
            'Favorites',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 58,
              color: Colors.grey[300],
            ),
            SizedBox(height: 15),
            Text(
              'No favorites yet',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 7),
            Text(
              'Tap the heart on any product to save it here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}