import 'package:flutter/cupertino.dart';
import 'package:gofundme/widgets/app_navigation_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const AppNavigationBar(
        title: 'Profile',
        showAddButton: false,
      ),
      child: const Center(
        child: Text('Profile Screen'),
      ),
    );
  }
}