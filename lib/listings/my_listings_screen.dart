import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app_theme.dart';
import '../models/product.dart';
import '../products/products_cubit/products_cubit.dart';
import '../products/products_cubit/products_state.dart';
import 'edit_listing_screen.dart';
import '../sell/sell_item_screen.dart';

class MyListingsScreen extends StatelessWidget {
  final bool embedded;

 const MyListingsScreen({
    super.key,
    this.embedded = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              18,
              20,
              12,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'My Listings',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SellItemScreen(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<
                ProductsCubit,
                ProductsState>(
              builder: (context, state) {
                if (state is ProductsLoading) {
                  return Center(
                    child:
                    CircularProgressIndicator(
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
                  final listings =
                  state.products.where(
                        (product) {
                      return product is UserProduct;
                    },
                  ).toList();

                  if (listings.isEmpty) {
                    return _empty(context);
                  }

                  return ListView.builder(
                    padding: EdgeInsets.fromLTRB(
                      18,
                      5,
                      18,
                      20,
                    ),
                    itemCount: listings.length,
                    itemBuilder: (context, index) {
                      final product =
                      listings[index];

                      return _listingCard(
                        context,
                        product,
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

  Widget _listingCard(
      BuildContext context,
      Product product,
      ) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: product.category.color,
              borderRadius:
              BorderRadius.circular(10),
            ),
            child: product.imageUrl.isEmpty
                ? Icon(
              product.category.icon,
              color: Colors.grey,
            )
                : Image.network(
              product.imageUrl,
              fit: BoxFit.contain,
              errorBuilder:
                  (context, error, stackTrace) {
                return Icon(
                  Icons.image_outlined,
                  color: Colors.grey,
                );
              },
            ),
          ),

          SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '\$${product.price.toStringAsFixed(0)}',
                  style: TextStyle(
                    color:
                    AppTheme.terracottaColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Active',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () async {
              final updated =
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditListingScreen(
                        product: product,
                      ),
                ),
              );

              if (updated != null) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Listing updated successfully.',
                    ),
                  ),
                );
              }
            },
            icon: Icon(
              Icons.edit_outlined,
              size: 18,
              color: AppTheme.primaryColor,
            ),
          ),

          IconButton(
            onPressed: () {
              _deleteDialog(
                context,
                product.id,
              );
            },
            icon: Icon(
              Icons.delete_outline,
              size: 18,
              color: Colors.red[300],
            ),
          ),
        ],
      ),
    );
  }

  Widget _empty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sell_outlined,
            size: 55,
            color: Colors.grey[300],
          ),
          SizedBox(height: 12),
          Text(
            'You have no listings yet.',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 14),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SellItemScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
              AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text('Sell an Item'),
          ),
        ],
      ),
    );
  }

  void _deleteDialog(
      BuildContext context,
      String id,
      ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'Delete Listing',
          ),
          content: Text(
            'Are you sure you want to remove this listing?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                context
                    .read<ProductsCubit>()
                    .deleteListing(id);
              },
              child: Text(
                'DELETE',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}