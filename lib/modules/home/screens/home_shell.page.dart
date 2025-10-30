import 'package:flutter/material.dart';
import 'package:jigyasa/modules/home/screens/homefeed.page.dart';
import 'package:jigyasa/modules/home/screens/favourites.page.dart';
import 'package:jigyasa/modules/profile/screens/profile.page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jigyasa/state/notifications_cubit.dart';
import 'package:jigyasa/state/notifications_state.dart';
import 'package:jigyasa/common/widgets/bottom_nav_bar.widget.dart';

class HomeShellPage extends StatefulWidget {
  const HomeShellPage({super.key});

  @override
  State<HomeShellPage> createState() => _HomeShellPageState();
}

class _HomeShellPageState extends State<HomeShellPage> {
  NavigationTab _currentTab = NavigationTab.home;

  // Ensure the pages list length matches NavigationTab.values.length
  // so IndexedStack index never goes out of range when user taps unused tabs.
  final _pages = <Widget>[
    const HomeFeedPage(), // home
    // explore (placeholder)
    const Center(child: Text('Explore - Coming soon')),
    // create (placeholder)
    const Center(child: Text('Create - Coming soon')),
    // collab (placeholder)
    const Center(child: Text('Collab - Coming soon')),
    const ProfilePage(), // profile
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationsCubit()..init(),
      child: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          return Scaffold(
            body: IndexedStack(index: _currentTab.index, children: _pages),
            bottomNavigationBar: BottomNavBar(
              currentTab: _currentTab,
              onTabSelected: (tab) => setState(() => _currentTab = tab),
            ),
          );
        },
      ),
    );
  }
}
