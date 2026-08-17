import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/category.dart';
import '../services/preferences_helper.dart';

class SettingsScreen extends StatefulWidget {
 const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {
  final preferencesHelper =
  PreferencesHelper();

  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    loadSetting();
  }

  Future<void> loadSetting() async {
    final value =
    await preferencesHelper
        .getDefaultCategory();

    if (!mounted) {
      return;
    }

    setState(() {
      selectedCategory = value;
    });
  }

  Future<void> saveSetting(
      String value,
      ) async {
    await preferencesHelper
        .saveDefaultCategory(value);

    if (!mounted) {
      return;
    }

    setState(() {
      selectedCategory = value;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Default category saved.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              'Browsing Preferences',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 5),

            Text(
              'Choose the category you want to use as your default preference.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 11,
              ),
            ),

            SizedBox(height: 20),

            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(13),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCategory,
                  isExpanded: true,
                  hint: Text(
                    'Select default category',
                  ),
                  items: Category.values.map(
                        (category) {
                      return DropdownMenuItem<String>(
                        value: category.name,
                        child: Text(
                          category.name,
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      saveSetting(value);
                    }
                  },
                ),
              ),
            ),

            SizedBox(height: 25),

            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color(0xffE6F0EE),
                borderRadius:
                BorderRadius.circular(13),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.primaryColor,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      selectedCategory == null
                          ? 'No default category selected.'
                          : 'Default category: $selectedCategory',
                      style: TextStyle(
                        fontSize: 11,
                        color:
                        AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}