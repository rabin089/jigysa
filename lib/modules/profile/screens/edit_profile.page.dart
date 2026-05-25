import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jigyasa/modules/profile/cubit/profile.cubit.dart';
import 'package:jigyasa/modules/profile/cubit/profile.state.dart';
import 'package:jigyasa/modules/profile/model/user.profile.model.dart';
import '../widgets/profile_header.dart';
import '../widgets/basic_info_card.dart';
import '../widgets/contact_card.dart';
import '../widgets/action_bar.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final fullName = TextEditingController();
  final username = TextEditingController();
  final bio = TextEditingController();
  final role = TextEditingController();
  final location = TextEditingController();
  final email = TextEditingController();
  final website = TextEditingController();

  // Original values snapshot to detect changes
  User? _originalUser;
  String _initBio = '';
  String _initLocation = '';
  String _initWebsite = '';

  bool get _hasChanges {
    final u = _originalUser;
    if (u == null) return false; // until data is loaded
    return fullName.text != u.name ||
        username.text != u.username ||
        role.text != u.role ||
        email.text != u.email ||
        bio.text != _initBio ||
        location.text != _initLocation ||
        website.text != _initWebsite;
  }

  @override
  void initState() {
    super.initState();
    // Rebuild on any field change to toggle action buttons
    for (final c in [fullName, username, bio, role, location, email, website]) {
      c.addListener(() {
        if (mounted) setState(() {});
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileCubit>().loadProfile();
      }
    });
  }

  @override
  void dispose() {
    fullName.dispose();
    username.dispose();
    bio.dispose();
    role.dispose();
    location.dispose();
    email.dispose();
    website.dispose();
    super.dispose();
  }

  void onSave() {
    if (!_hasChanges) return;
    final payload = <String, dynamic>{};
    final u = _originalUser;
    if (u != null) {
      if (fullName.text.trim() != u.name) payload['name'] = fullName.text.trim();
      if (username.text.trim() != u.username) payload['username'] = username.text.trim();
      if (role.text.trim() != u.role) payload['role'] = role.text.trim();
      if (email.text.trim() != u.email) payload['email'] = email.text.trim();
    }
    if (bio.text.trim() != _initBio) payload['bio'] = bio.text.trim();
    if (location.text.trim() != _initLocation) payload['location'] = location.text.trim();
    if (website.text.trim() != _initWebsite) payload['website'] = website.text.trim();

    if (payload.isEmpty) return;
    context.read<ProfileCubit>().updateProfile(data: payload);
  }
  void onDiscard() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SafeArea(
        child: BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoaded) {
              _originalUser = state.user;
              fullName.text = state.user.name;
              username.text = state.user.username;
              role.text = state.user.role;
              email.text = state.user.email;
              // Snapshot optional fields initial values
              _initBio = bio.text;
              _initLocation = location.text;
              _initWebsite = website.text;
              if (mounted) setState(() {});
            }
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ProfileHeader(
                name: fullName.text,
                subtitle: 'Tap to update your photo',
                onChangePhoto: () {
                  
                },
              ),
              const SizedBox(height: 12),
              BasicInfoCard(
                fullName: fullName,
                username: username,
                bio: bio,
                role: role,
                location: location,
              ),
              ContactCard(email: email, website: website),
              if (_hasChanges)
                ActionBar(
                  onSave: onSave,
                  onDiscard: () {
                    final u = _originalUser;
                    if (u != null) {
                      fullName.text = u.name;
                      username.text = u.username;
                      role.text = u.role;
                      email.text = u.email;
                    }
                    bio.text = _initBio;
                    location.text = _initLocation;
                    website.text = _initWebsite;
                    if (mounted) setState(() {});
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
