import 'package:flutter/material.dart';

enum TabItem { jobs, rewards, home_page, account }

class TabItemData {
  const TabItemData({@required this.title, @required this.icon});

  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.jobs: TabItemData(title: 'Bills', icon: Icons.work),
    TabItem.rewards: TabItemData(title: 'Rewards', icon: Icons.work),
    TabItem.home_page: TabItemData(title: 'Entries', icon: Icons.view_headline),
    TabItem.account: TabItemData(title: 'Account', icon: Icons.person),
  };
}
