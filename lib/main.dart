import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Explicitly initialize GoogleSignIn with the Web Client ID (serverClientId)
    // to ensure it requests the ID token properly on Android, bypassing any
    // cache issues with google-services.json.
    await GoogleSignIn.instance.initialize(
      serverClientId: '435028376050-q0hs82s8lrvqtkrlfjbeedchllg81qc7.apps.googleusercontent.com',
    );
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }
  runApp(const App());
}

