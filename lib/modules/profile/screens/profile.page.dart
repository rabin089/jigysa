import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jigyasa/app_state.dart';
import 'package:jigyasa/modules/profile/cubit/profile.cubit.dart';
import 'package:jigyasa/modules/profile/repository/profile.repo.dart';
import 'package:jigyasa/modules/profile/widgets/ideas.card.dart';
import 'package:jigyasa/modules/profile/widgets/profile.card.dart';
import 'package:jigyasa/services/local_storage/local_storage.services.dart';
import 'package:jigyasa/services/navigator/navigator.dart';
import 'package:jigyasa/modules/auth/screen/login.page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => ProfileCubit(repository: ProfileRepository())..loadProfile(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
          // Logout menu
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'logout') {
                final confirmed = await _confirmLogout(context);
                if (confirmed == true) {
                  await _performLogout(context);
                }
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(value: 'logout', child: Text('Logout')),
                ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<ProfileCubit>().refreshProfile();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: 12),
              ProfileCard(),
              // Tabs (Saved / Likes / Create) are omitted for now per request
              MyIdeasCard(),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _confirmLogout(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Logout'),
              ),
            ],
          ),
    );
  }

  Future<void> _performLogout(BuildContext context) async {
    debugPrint('Starting logout process...');

    // Clear shared preferences keys and local storage
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('accessToken');
      await prefs.remove('refreshToken');
      await prefs.remove('userId');
      await prefs.remove('userEmail');
      await prefs.remove('userName');
      await prefs.remove('userProfile');
      await prefs.remove('isLoggedIn');
      await prefs.remove('lastLoginTime');
      await prefs.remove('userRole');
      await prefs.remove('userPermissions');
      debugPrint('SharedPreferences cleared successfully');
    } catch (e) {
      debugPrint('Error clearing SharedPreferences during logout: $e');
    }

    try {
      await storageInstance.clearAll();
      debugPrint('LocalStorage cleared successfully');
    } catch (e) {
      debugPrint('Error clearing storageInstance during logout: $e');
    }

    // Reset AppState if available
    try {
      if (AppNavigator.currentContext != null) {
        final appState = AppNavigator.currentContext!.read<AppState>();
        await appState.resetState();
        debugPrint('AppState reset successfully');
      }
    } catch (e) {
      debugPrint('Error resetting AppState during logout: $e');
    }

    debugPrint('Attempting navigation to login page...');

    // Try context navigation first as it's most reliable
    try {
      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
      debugPrint('Successfully navigated to login page using context');
      return;
    } catch (e) {
      debugPrint('Error navigating with context: $e');
    }

    // If context navigation fails, try with a root navigator
    try {
      await Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
      debugPrint('Successfully navigated using root navigator');
      return;
    } catch (e) {
      debugPrint('Error navigating with root navigator: $e');
    }

    // Last resort: try simple Navigator operations
    try {
      Navigator.of(context)
        ..popUntil((route) => route.isFirst)
        ..pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
      debugPrint('Successfully used basic navigation fallback');
    } catch (e) {
      debugPrint('All navigation attempts failed: $e');
      // Show a snackbar to inform the user something went wrong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error during logout. Please restart the app.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
