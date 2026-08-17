import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app_theme.dart';
import '../../models/category.dart';
import '../../models/product.dart';
import '../../profile/profile_screen.dart';
import '../product_card.dart';
import '../products_cubit/products_cubit.dart';
import '../products_cubit/products_state.dart';
import '../../favorites/favorites_screen.dart';
import '../../listings/my_listings_screen.dart';
import 'product_details_screen.dart';


class DiscoverScreen extends StatefulWidget {
 const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() =>
      _DiscoverScreenState();
}

class _DiscoverScreenState
    extends State<DiscoverScreen> {
  int selectedIndex = 0;
  Category? selectedCategory;

  final List<String> titles = [
    'Discover',
    'Favorites',
    'Sell',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildBody() {
    if (selectedIndex == 0) {
      return _buildDiscover();
    }

    if (selectedIndex == 1) {
      return FavoritesScreen(
        embedded: true,
      );
    }

    if (selectedIndex == 2) {
      return MyListingsScreen(
        embedded: true,
      );
    }

    return ProfileScreen(
      embedded: true,
    );
  }

  Widget _buildDiscover() {
    return SafeArea(
      child: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            );
          }

          if (state is ProductsError) {
            return _buildError(state.message);
          }

          if (state is ProductsLoaded) {
            return Column(
              children: [
                _buildHeader(),
                _buildCategories(),
                Expanded(
                  child: _buildProducts(
                    state.products,
                    state.favoriteIds,
                  ),
                ),
              ],
            );
          }

          return SizedBox();
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        15,
        20,
        10,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Souq Corner',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.search,
              size: 20,
            ),
          ),
          SizedBox(width: 9),
          CircleAvatar(
            radius: 19,
            backgroundColor: Color(0xffD8E9E7),
            child: Text(
              'SM',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 48,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 18),
        scrollDirection: Axis.horizontal,
        children: [
          _categoryChip(
            name: 'All',
            selected: selectedCategory == null,
            onTap: () {
              setState(() {
                selectedCategory = null;
              });
            },
          ),
          ...Category.values.map(
                (category) {
              return _categoryChip(
                name: category.name,
                selected:
                selectedCategory == category,
                onTap: () {
                  setState(() {
                    selectedCategory = category;
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _categoryChip({
    required String name,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 17,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: selected
                ? AppTheme.primaryColor
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            name,
            style: TextStyle(
              fontSize: 11,
              color: selected
                  ? Colors.white
                  : Colors.grey[700],
              fontWeight: selected
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProducts(
      List<Product> products,
      Set<String> favorites,
      ) {
    final filteredProducts =
    selectedCategory == null
        ? products
        : products
        .where(
          (product) =>
      product.category ==
          selectedCategory,
    )
        .toList();

    if (filteredProducts.isEmpty) {
      return Center(
        child: Text(
          'No products in this category',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      );
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
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];

        return ProductCard(
          product: product,
          isFavorite: favorites.contains(
            product.id,
          ),
          onFavorite: () {
            context
                .read<ProductsCubit>()
                .toggleFavorite(product.id);
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

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_outlined,
              size: 55,
              color: Colors.grey[400],
            ),
            SizedBox(height: 15),
            Text(
              'Could not load products',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            SizedBox(height: 7),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context
                    .read<ProductsCubit>()
                    .loadProducts();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        if (index == 2) {
          setState(() {
            selectedIndex = 2;
          });
          return;
        }

        setState(() {
          selectedIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppTheme.primaryColor,
      unselectedItemColor: Colors.grey[500],
      selectedFontSize: 10,
      unselectedFontSize: 10,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_outlined),
          activeIcon: Icon(Icons.grid_view),
          label: 'Discover',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          activeIcon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sell_outlined),
          activeIcon: Icon(Icons.sell),
          label: 'Sell',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}