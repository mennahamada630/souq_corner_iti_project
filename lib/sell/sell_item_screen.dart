import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_theme.dart';
import '../models/category.dart';
import '../services/firestore_service.dart';
import '../products/products_cubit/products_cubit.dart';


class SellItemScreen extends StatefulWidget {
 const SellItemScreen({super.key});

  @override
  State<SellItemScreen> createState() =>
      _SellItemScreenState();
}

class _SellItemScreenState
    extends State<SellItemScreen> {
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final imageController = TextEditingController();
  final descriptionController =
  TextEditingController();

  Category selectedCategory = Category.home;

  bool loading = false;

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    imageController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    setState(() {
      loading = true;
    });

    final profile =
    await FirestoreService().getUserProfile(
      user.uid,
    );

    final sellerName =
        profile?['name']?.toString() ??
            user.email?.split('@').first ??
            'Seller';

    await context.read<ProductsCubit>().addListing(
      title: titleController.text.trim(),
      price: double.parse(
        priceController.text.trim(),
      ),
      category: selectedCategory,
      description:
      descriptionController.text.trim(),
      imageUrl: imageController.text.trim(),
      sellerName: sellerName,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      loading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Your item has been listed successfully.',
        ),
      ),
    );

    titleController.clear();
    priceController.clear();
    imageController.clear();
    descriptionController.clear();

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sell an Item',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            20,
            8,
            20,
            30,
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                _photoBox(),

                SizedBox(height: 22),

                _label('Image URL'),

                SizedBox(height: 7),

                TextFormField(
                  controller: imageController,
                  keyboardType:
                  TextInputType.url,
                  decoration: InputDecoration(
                    hintText:
                    'https://example.com/image.jpg',
                    prefixIcon: Icon(
                      Icons.link,
                      size: 19,
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Image URL is required';
                    }

                    return null;
                  },
                ),

                SizedBox(height: 17),

                _label('Title'),

                SizedBox(height: 7),

                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText:
                    'e.g. Vintage Rattan Chair',
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Title is required';
                    }

                    return null;
                  },
                ),

                SizedBox(height: 17),

                _label('Price'),

                SizedBox(height: 7),

                TextFormField(
                  controller: priceController,
                  keyboardType:
                  TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '0.00',
                    prefixText: '\$ ',
                  ),
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

                _label('Category'),

                SizedBox(height: 9),

                _categorySelector(),

                SizedBox(height: 17),

                _label('Description'),

                SizedBox(height: 7),

                TextFormField(
                  controller:
                  descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText:
                    'Tell buyers about condition, size, pickup details...',
                    alignLabelWithHint: true,
                  ),
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
                  height: 54,
                  child: ElevatedButton(
                    onPressed:
                    loading ? null : submit,
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
                      'List Item',
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

  Widget _photoBox() {
    return Container(
      height: 125,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Color(0xffDDD4CA),
          width: 1.2,
        ),
      ),
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Icon(
            Icons.camera_alt_outlined,
            color: Colors.grey,
            size: 26,
          ),
          SizedBox(height: 7),
          Text(
            'Paste an image URL below',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _categorySelector() {
    return Wrap(
      spacing: 7,
      runSpacing: 7,
      children: Category.values.map(
            (category) {
          final selected =
              selectedCategory == category;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 9,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.primaryColor
                    : Colors.white,
                borderRadius:
                BorderRadius.circular(20),
                border: Border.all(
                  color: selected
                      ? AppTheme.primaryColor
                      : Color(0xffDDD4CA),
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
    );
  }
}