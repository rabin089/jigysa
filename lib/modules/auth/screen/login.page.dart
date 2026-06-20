import 'package:flutter/material.dart';
import 'package:jigyasa/constant/sizedbox/sized_box.constants.dart';
import 'package:jigyasa/modules/auth/repository/auth.service.dart';
import 'package:jigyasa/modules/auth/screen/sign_up.page.dart';
import 'package:jigyasa/modules/home/screens/home_shell.page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isSubmitting = false;
  bool _rememberMe = false;
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      await authService.login(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged in successfully')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeShellPage()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _onGoogleLogin() async {
    setState(() => _isSubmitting = true);
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();
      final String? idToken = googleUser.authentication.idToken;
      
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final String? firebaseIdToken = await userCredential.user?.getIdToken();
      
      if (firebaseIdToken != null) {
        await authService.googleLogin(firebaseIdToken);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged in with Google successfully')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeShellPage()),
        );
      } else {
        throw Exception('Failed to get Firebase ID token.');
      }
    } on GoogleSignInException catch (e) {
      if (!mounted) return;
      if (e.code != 'canceled' && e.code != 'interrupted') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google Login failed: ${e.code}')),
        );
      }
      try {
        await GoogleSignIn.instance.signOut();
        await FirebaseAuth.instance.signOut();
      } catch (_) {}
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Login failed: $e')),
      );
      try {
        await GoogleSignIn.instance.signOut();
        await FirebaseAuth.instance.signOut();
      } catch (_) {}
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF4FF),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.lightbulb_outline, color: Color(0xFF3B82F6), size: 30),
                    ),
                  ),
                  sboxH20,
                  const Text(
                    'Welcome to Jigyasa',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Share ideas, collaborate, and discover new possibilities.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  sboxH20,

                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Email Field
                            const Text(
                              'Email',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: 'name@example.com',
                                prefixIcon: const Icon(Icons.email_outlined),
                                filled: true,
                                fillColor: const Color(0xFFF5F7FB),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Color(0xFF3B82F6)),
                                ),
                              ),
                              validator: (v) {
                                final value = (v ?? '').trim();
                                if (value.isEmpty) return 'Email is required';
                                final valid = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value);
                                if (!valid) return 'Enter a valid email';
                                return null;
                              },
                            ),

                            sboxH20,

                            //Password Field
                            const Text(
                              'Password',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _passwordCtrl,
                              obscureText: _obscure,
                              decoration: InputDecoration(
                                hintText: '••••••••',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  onPressed: () => setState(() => _obscure = !_obscure),
                                  icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF5F7FB),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Color(0xFF3B82F6)),
                                ),
                              ),
                              validator: (v) {
                                if ((v ?? '').isEmpty) return 'Password is required';
                                if ((v ?? '').length < 6) return 'At least 6 characters';
                                return null;
                              },
                            ),

                            sboxH10,

                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (val) => setState(() => _rememberMe = val ?? false),
                                  activeColor: const Color(0xFF3B82F6),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                const Text('Remember me'),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    // Navigator.push(context, MaterialPageRoute(builder: (context)=> Password))
                                  },
                                  child: const Text(
                                    'Forgot password?',
                                    style: TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),

                            sboxH10,

                            //  Login Button
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton.icon(
                                onPressed: _isSubmitting ? null : _onLogin,
                                icon: const Icon(Icons.login, color: Colors.white),
                                label: _isSubmitting
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : const Text(
                                        'Sign In',
                                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3B82F6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  elevation: 3,
                                ),
                              ),
                            ),

                            sboxH20,

                            Row(
                              children: const [
                                Expanded(child: Divider()),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text('or continue with', style: TextStyle(color: Colors.grey)),
                                ),
                                Expanded(child: Divider()),
                              ],
                            ),

                            sboxH20,

                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.code, color: Colors.black87),
                                    label: const Text('GitHub', style: TextStyle(color: Colors.black87)),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      backgroundColor: const Color(0xFFF5F7FB),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: _isSubmitting ? null : _onGoogleLogin,
                                    icon: const Icon(Icons.g_mobiledata, color: Colors.black87),
                                    label: const Text('Google', style: TextStyle(color: Colors.black87)),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      backgroundColor: const Color(0xFFF5F7FB),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            sboxH20,

                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.qr_code, color: Colors.black87),
                                label: const Text('Continue with OTP', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  sboxH20,

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('New to Jigyasa? ', style: TextStyle(fontSize: 14)),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SignUpPage()),
                            );
                          },
                          child: const Text(
                            'Create an account',
                            style: TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
