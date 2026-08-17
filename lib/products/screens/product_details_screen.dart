import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_theme.dart';
import '../../models/product.dart';
import '../products_cubit/products_cubit.dart';
import '../products_cubit/products_state.dart';


class ProductDetailsScreen extends StatelessWidget {
  final Product product;

 const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, state) {
            final isFavorite =
                state is ProductsLoaded &&
                    state.favoriteIds
                        .contains(product.id);

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        _buildImageHeader(
                          context,
                          isFavorite,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            20,
                            18,
                            20,
                            30,
                          ),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      product.title,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight:
                                        FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '\$${product.price.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: AppTheme
                                          .terracottaColor,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 17),

                              Divider(
                                color: Color(0xffE5DED5),
                              ),

                              SizedBox(height: 15),

                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor:
                                    Color(0xffD8E9E7),
                                    child: Text(
                                      product.sellerName
                                          .isNotEmpty
                                          ? product
                                          .sellerName[0]
                                          .toUpperCase()
                                          : 'S',
                                      style: TextStyle(
                                        color: AppTheme
                                            .primaryColor,
                                        fontWeight:
                                        FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        product.sellerName,
                                        style: TextStyle(
                                          fontWeight:
                                          FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        'Local Seller',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              SizedBox(height: 25),

                              Text(
                                'Description',
                                style: TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),

                              SizedBox(height: 8),

                              Text(
                                product.description.isEmpty
                                    ? 'No description available.'
                                    : product.description,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  height: 1.5,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(
                    18,
                    8,
                    18,
                    18,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(13),
                        ),
                        child: IconButton(
                          onPressed: () {
                            context
                                .read<ProductsCubit>()
                                .toggleFavorite(
                              product.id,
                            );
                          },
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: AppTheme
                                .terracottaColor,
                          ),
                        ),
                      ),

                      SizedBox(width: 9),

                      Expanded(
                        child: SizedBox(
                          height: 54,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Seller contact feature is ready for integration.',
                                  ),
                                ),
                              );
                            },
                            style:
                            ElevatedButton.styleFrom(
                              backgroundColor:
                              AppTheme.primaryColor,
                              foregroundColor:
                              Colors.white,
                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(
                                  13,
                                ),
                              ),
                            ),
                            child: Text(
                              'Contact Seller',
                              style: TextStyle(
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildImageHeader(
      BuildContext context,
      bool isFavorite,
      ) {
    return Container(
      height: 350,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xffDCECEA),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 15,
            left: 15,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 18,
                ),
              ),
            ),
          ),
          Positioned(
            top: 15,
            right: 15,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  context
                      .read<ProductsCubit>()
                      .toggleFavorite(product.id);
                },
                icon: Icon(
                  isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  size: 18,
                  color:
                  AppTheme.terracottaColor,
                ),
              ),
            ),
          ),
          Center(
            child: product.imageUrl.isEmpty
                ? Icon(
              product.category.icon,
              size: 65,
              color: Colors.grey,
            )
                : Image.network(
              product.imageUrl,
              width: 230,
              height: 230,
              fit: BoxFit.contain,
              errorBuilder:
                  (context, error, stackTrace) {
                return Icon(
                  Icons.image_outlined,
                  size: 60,
                  color: Colors.grey,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}