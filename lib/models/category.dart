import 'package:flutter/material.dart';

enum Category {
  food(
    name: 'Food',
    icon: Icons.restaurant,
    color: Color(0xffE8D9C5),
  ),
  crafts(
    name: 'Crafts',
    icon: Icons.handyman_outlined,
    color: Color(0xffEAD7D0),
  ),
  clothes(
    name: 'Clothes',
    icon: Icons.checkroom_outlined,
    color: Color(0xffD9E4E2),
  ),
  electronics(
    name: 'Electronics',
    icon: Icons.devices_outlined,
    color: Color(0xffDDE3EA),
  ),
  home(
    name: 'Home',
    icon: Icons.home_outlined,
    color: Color(0xffE5DFC9),
  ),
  other(
    name: 'Other',
    icon: Icons.category_outlined,
    color: Color(0xffE2E2E2),
  );

  final String name;
  final IconData icon;
  final Color color;

  const Category({
    required this.name,
    required this.icon,
    required this.color,
  });
}