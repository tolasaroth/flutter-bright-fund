import 'package:flutter/cupertino.dart';
import 'package:gofundme/widgets/app_navigation_bar.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const AppNavigationBar(
        title: 'Settings',
        showAddButton: false,
      ),
      child: const Center(
        child: Text('Settings Screen'),
      ),
    );
  }
}