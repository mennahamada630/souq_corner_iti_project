import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app_theme.dart';
import '../auth/auth_cubit/auth_cubit.dart';
import '../services/firestore_service.dart';
import '../settings/settings_screen.dart';


class ProfileScreen extends StatefulWidget {
  final bool embedded;

  ProfileScreen({
    super.key,
    this.embedded = false,
  });

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {
  final firestoreService = FirestoreService();

  String name = '';
  String email = '';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    final data =
    await firestoreService.getUserProfile(
      user.uid,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      name = data?['name']?.toString() ??
          user.email?.split('@').first ??
          'User';

      email = user.email ?? '';

      loading = false;
    });
  }

  Future<void> editName() async {
    final controller = TextEditingController(
      text: name,
    );

    final newName = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Your name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  controller.text.trim(),
                );
              },
              child: Text('SAVE'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (newName == null ||
        newName.isEmpty) {
      return;
    }

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    await firestoreService.updateUserProfile(
      user.uid,
      newName,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      name = newName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: loading
          ? Center(
        child: CircularProgressIndicator(
          color: AppTheme.primaryColor,
        ),
      )
          : SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20,
          18,
          20,
          30,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment:
                    Alignment.centerLeft,
                    child: Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SettingsScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.settings_outlined,
                  ),
                ),
              ],
            ),

            SizedBox(height: 22),

            CircleAvatar(
              radius: 45,
              backgroundColor:
              Color(0xffD8E9E7),
              child: Text(
                name.isNotEmpty
                    ? name[0].toUpperCase()
                    : 'S',
                style: TextStyle(
                  fontSize: 28,
                  color:
                  AppTheme.primaryColor,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 14),

            Text(
              name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 4),

            Text(
              email,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 11,
              ),
            ),

            SizedBox(height: 8),

            TextButton.icon(
              onPressed: editName,
              icon: Icon(
                Icons.edit_outlined,
                size: 15,
              ),
              label: Text(
                'Edit profile',
              ),
            ),

            SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _statCard(
                    '8',
                    'Items Listed',
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _statCard(
                    '14',
                    'Favorites',
                  ),
                ),
              ],
            ),

            SizedBox(height: 25),

            _profileOption(
              icon:
              Icons.sell_outlined,
              title: 'My Listings',
              onTap: () {
                // Bottom navigation already contains this.
              },
            ),

            _profileOption(
              icon:
              Icons.favorite_border,
              title: 'Saved Favorites',
              onTap: () {},
            ),

            _profileOption(
              icon:
              Icons.settings_outlined,
              title: 'Settings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SettingsScreen(),
                  ),
                );
              },
            ),

            SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () {
                  _logoutDialog(context);
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.red[700],
                  size: 17,
                ),
                label: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.red[700],
                  ),
                ),
                style:
                OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Colors.red[200]!,
                  ),
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                      12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(
      String number,
      String title,
      ) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 3),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        size: 20,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        size: 19,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  void _logoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text(
            'Are you sure you want to logout?',
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

               context.read<AuthCubit>().logout();
              },
              child: Text(
                'LOGOUT',
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