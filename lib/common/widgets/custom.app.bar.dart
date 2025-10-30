import 'package:flutter/material.dart';

import '../../constant/style/app.style.constant.dart';
import '../../services/local_storage/local_storage.services.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {

  final VoidCallback? onLogoTap;
  const CustomAppBar({super.key, this.onLogoTap});


  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  String _profileUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final localStorage = LocalStorageService();
    final photo = await localStorage.getData(key: 'photoUrl');

    setState(() {
      _profileUrl = photo ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      leading: InkWell(
        onTap: widget.onLogoTap,
        child: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: SizedBox(
            height: 20,
            width: 20,
            child: Image.asset("asset/images/logo.png"),
          ),
        ),
      ),
      title: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Doc',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              'Prep',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                  )
            )
          ],
        ),
      ),
      centerTitle: true,
      backgroundColor: AppTheme.backgroundColor,
      actions: [
        InkWell(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const ProfileScreen()),
            // );
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: _profileUrl.isNotEmpty
                  ? Image.network(
                _profileUrl,
                height: 36,
                width: 36,
                fit: BoxFit.cover,
              )
                  : Image.asset(
                'asset/images/profile.png',
                height: 36,
                width: 36,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
