import 'package:flutter/material.dart';
import '../screens/settings_screen.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const Header({Key? key, required this.title}) : super(key: key);

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => _navigateToSettings(context),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
