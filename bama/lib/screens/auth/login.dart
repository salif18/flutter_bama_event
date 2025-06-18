import 'package:bama/screens/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool isLoading = false;

  // 🔐 Connexion avec email/mot de passe
  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Connexion réussie ✅")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur: ${e.toString()}")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  // 🔐 Connexion avec Google
  Future<void> _signInWithGoogle() async {
    setState(() => isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Connexion Google réussie ✅")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur Google: ${e.toString()}")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  // 🔒 Réinitialisation du mot de passe
  void _resetPassword() async {
    final email = emailCtrl.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Entrez un email valide")));
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email de réinitialisation envoyé ✅")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur: ${e.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: Padding(
                padding: EdgeInsets.all(20.r),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      SizedBox(height: 40.h),
                      Text(
                        "Connexion",
                        style: GoogleFonts.poppins(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      TextFormField(
                        controller: emailCtrl,
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => val != null && val.contains('@')
                            ? null
                            : "Email invalide",
                      ),
                      SizedBox(height: 20.h),
                      TextFormField(
                        controller: passwordCtrl,
                        obscureText: true,
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          labelText: "Mot de passe",
                          labelStyle: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => val != null && val.length >= 6
                            ? null
                            : "6 caractères min.",
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _resetPassword,
                          child: Text(
                            "Mot de passe oublié ?",
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                      ),
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: _signInWithEmail,
                                    label: Text(
                                      "Se connecter",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16.sp,
                                        color: Colors.black,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.amber,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14.r,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: _signInWithGoogle,
                                    icon: Image.asset(
                                      "assets/logos/google.jpg",
                                      fit: BoxFit.cover,
                                      height: 24.h,
                                    ),
                                    label: Text(
                                      "Continuer avec Google",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      side: const BorderSide(
                                        color: Colors.white54,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14.r,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Vous n'avez pas de compte ? ",
                                      style: GoogleFonts.roboto(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          // Naviguer vers la page d’inscription
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RegisterView(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Créer un compte",
                                          style: GoogleFonts.roboto(
                                            color: Colors.orangeAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
