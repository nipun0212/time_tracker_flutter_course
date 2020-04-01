import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/owner/account/account_page.dart';
import 'package:time_tracker_flutter_course/app/owner/cupertino_home_scaffold.dart';
import 'package:time_tracker_flutter_course/app/owner/entries/entries_page.dart';
import 'package:time_tracker_flutter_course/app/owner/jobs/bill_page.dart';
import 'package:time_tracker_flutter_course/app/owner/tab_item.dart';

import 'jobs/bill_page.dart';

class OnwerHomePage extends StatefulWidget {
  @override
  _OnwerHomePageState createState() => _OnwerHomePageState();
}

class _OnwerHomePageState extends State<OnwerHomePage> {
  TabItem _currentTab = TabItem.jobs;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.jobs: GlobalKey<NavigatorState>(),
    TabItem.home_page: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.jobs: (_) => BillsPage(),
      TabItem.home_page: (context) => EntriesPage.create(context),
      TabItem.account: (_) => AccountPage(),
    };
  }

  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
