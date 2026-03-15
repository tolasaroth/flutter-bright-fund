import 'package:flutter/cupertino.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gofundme/screens/campaigns/browse_campaign_screen.dart';
import 'package:gofundme/screens/campaigns/my_campaign_screen.dart';
import 'package:gofundme/screens/setting/notification_screen.dart';
import 'package:gofundme/screens/setting/profile_screen.dart';
import 'package:gofundme/screens/setting/setting_screen.dart';

class MenuBar extends StatelessWidget {
  const MenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        height: 95,
        activeColor: CupertinoColors.activeBlue,
        inactiveColor: CupertinoColors.systemGrey,
        backgroundColor: CupertinoColors.white,
        border: Border(
          top: BorderSide(
            color: CupertinoColors.systemGrey,
            width: 0.4,
          ),
        ),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.search),
                Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 15),
                  child: Text('Browse', style: TextStyle(fontSize: 13)),
                ),
              ],
            ),
            // label: '', // empty string so the default label doesn't render
          ),
          BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.building2),
                Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 15),
                  child: Text('Campaigns', style: TextStyle(fontSize: 13)),
                ),
              ],
            ),
            // label: '', // empty string so the default label doesn't render
          ),
          BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.bell),
                Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 15),
                  child: Text('Notifications', style: TextStyle(fontSize: 13)),
                ),
              ],
            ),
            // label: '', // empty string so the default label doesn't render
          ),
          BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.settings),
                Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 15),
                  child: Text('Settings', style: TextStyle(fontSize: 13)),
                ),
              ],
            ),
            // label: '', // empty string so the default label doesn't render
          ),
          BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.userCircle2),
                Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 15),
                  child: Text('Profile', style: TextStyle(fontSize: 13)),
                ),
              ],
            ),
            // label: '', // empty string so the default label doesn't render
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            switch (index) {
              case 0:
                return const BrowseCampaignScreen();
              case 1:
                return const MyCampaignScreen();
              case 2:
                return const NotificationScreen();
              case 3:
                return const SettingScreen();
              case 4:
                return const ProfileScreen();
              default:
                return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }
}
