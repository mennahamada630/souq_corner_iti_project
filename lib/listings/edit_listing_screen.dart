import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_theme.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../products/products_cubit/products_cubit.dart';


class EditListingScreen extends StatefulWidget {
  final Product product;

 const EditListingScreen({
    super.key,
    required this.product,
  });

  @override
  State<EditListingScreen> createState() =>
      _EditListingScreenState();
}

class _EditListingScreenState
    extends State<EditListingScreen> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController titleController;
  late final TextEditingController priceController;
  late final TextEditingController imageController;
  late final TextEditingController descriptionController;

  late Category selectedCategory;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.product.title,
    );

    priceController = TextEditingController(
      text: widget.product.price.toString(),
    );

    imageController = TextEditingController(
      text: widget.product.imageUrl,
    );

    descriptionController =
        TextEditingController(
          text: widget.product.description,
        );

    selectedCategory =
        widget.product.category;
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    imageController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    await context
        .read<ProductsCubit>()
        .updateListing(
      listingId: widget.product.id,
      title: titleController.text.trim(),
      price: double.parse(
        priceController.text.trim(),
      ),
      category: selectedCategory,
      description:
      descriptionController.text.trim(),
      imageUrl: imageController.text.trim(),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      loading = false;
    });

    Navigator.pop(
      context,
      true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Listing',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'TITLE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 7),
                TextFormField(
                  controller: titleController,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Title is required';
                    }

                    return null;
                  },
                ),

                SizedBox(height: 17),

                Text(
                  'PRICE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 7),
                TextFormField(
                  controller: priceController,
                  keyboardType:
                  TextInputType.number,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Price is required';
                    }

                    if (double.tryParse(
                      value.trim(),
                    ) ==
                        null) {
                      return 'Enter a valid price';
                    }

                    return null;
                  },
                ),

                SizedBox(height: 17),

                Text(
                  'IMAGE URL',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 7),
                TextFormField(
                  controller: imageController,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Image URL is required';
                    }

                    return null;
                  },
                ),

                SizedBox(height: 17),

                Text(
                  'CATEGORY',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 9),

                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: Category.values.map(
                        (category) {
                      final selected =
                          category ==
                              selectedCategory;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory =
                                category;
                          });
                        },
                        child: Container(
                          padding:
                          EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 8,
                          ),
                          decoration:
                          BoxDecoration(
                            color: selected
                                ? AppTheme
                                .primaryColor
                                : Colors.white,
                            borderRadius:
                            BorderRadius
                                .circular(20),
                            border: Border.all(
                              color: selected
                                  ? AppTheme
                                  .primaryColor
                                  : Color(
                                0xffDDD4CA,
                              ),
                            ),
                          ),
                          child: Text(
                            category.name,
                            style: TextStyle(
                              fontSize: 10,
                              color: selected
                                  ? Colors.white
                                  : Colors.grey[700],
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),

                SizedBox(height: 17),

                Text(
                  'DESCRIPTION',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 7),
                TextFormField(
                  controller:
                  descriptionController,
                  maxLines: 5,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Description is required';
                    }

                    return null;
                  },
                ),

                SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed:
                    loading ? null : save,
                    style:
                    ElevatedButton.styleFrom(
                      backgroundColor:
                      AppTheme.primaryColor,
                      foregroundColor:
                      Colors.white,
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(13),
                      ),
                    ),
                    child: loading
                        ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : Text(
                      'Save Changes',
                      style: TextStyle(
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}