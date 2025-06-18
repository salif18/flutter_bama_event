import 'package:bama/screens/auth/login.dart';
import 'package:bama/screens/auth/organisateur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  bool isLoading = false;

  // 🔐 Création avec Email + Mot de passe
  Future<void> _registerWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    try {
      final userCred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCred.user!.uid)
          .set({
        'uid': userCred.user!.uid,
        'name': nameCtrl.text.trim(),
        'phone': phoneCtrl.text.trim(),
        'email': emailCtrl.text.trim(),
        'createdAt': DateTime.now().toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Compte créé avec succès ✅")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: ${e.toString()}")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  // 🔐 Inscription via Google
  Future<void> _registerWithGoogle() async {
    setState(() => isLoading = true);
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred =
          await FirebaseAuth.instance.signInWithCredential(credential);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCred.user!.uid)
          .set({
        'uid': userCred.user!.uid,
        'name': userCred.user!.displayName ?? '',
        'phone': '',
        'email': userCred.user!.email,
        'createdAt': DateTime.now().toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Compte Google connecté ✅")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: ${e.toString()}")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      body: SafeArea(
        child: CustomScrollView(
          slivers:[ SliverFillRemaining(
            child: Padding(
              padding: EdgeInsets.all(20.r),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    SizedBox(height: 40.h),
                    Text(
                      "Créer un compte",
                      style: GoogleFonts.poppins(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 30.h),
            
                    TextFormField(
                      controller: nameCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Nom complet",
                        labelStyle:  GoogleFonts.poppins(
                        fontSize: 16.sp,             
                        color: Colors.white,
                      ),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val != null && val.length > 2 ? null : "Nom trop court",
                    ),
                    SizedBox(height: 16.h),
            
                    TextFormField(
                      controller: phoneCtrl,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Téléphone",
                        labelStyle: GoogleFonts.poppins(
                        fontSize: 16.sp,             
                        color: Colors.white,
                      ),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val != null && val.length >= 8 ? null : "Numéro invalide",
                    ),
                    SizedBox(height: 16.h),
            
                    TextFormField(
                      controller: emailCtrl,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: GoogleFonts.poppins(
                        fontSize: 16.sp,             
                        color: Colors.white,
                      ),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val != null && val.contains('@') ? null : "Email invalide",
                    ),
                    SizedBox(height: 16.h),
            
                    TextFormField(
                      controller: passwordCtrl,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Mot de passe",
                        labelStyle:GoogleFonts.poppins(
                        fontSize: 16.sp,             
                        color: Colors.white,
                      ),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val != null && val.length >= 6 ? null : "6 caractères min.",
                    ),
                    SizedBox(height: 24.h),
            
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                            children: [
                              ElevatedButton.icon(
                                onPressed: _registerWithEmail,
                                label: Text("S'inscrire", style: GoogleFonts.poppins(
                        fontSize: 16.sp,             
                        color: Colors.black,
                      ),),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  padding: EdgeInsets.symmetric(vertical: 14.r),
                                  minimumSize: Size.fromHeight(50.r),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              OutlinedButton.icon(
                                onPressed: _registerWithGoogle,
                                icon: Image.asset("assets/logos/google.jpg", height: 24.h),
                                label: Text("Continuer avec Google", style: GoogleFonts.poppins(
                        fontSize: 14.sp,             
                        color: Colors.white,
                      ),),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white54),
                                  padding: EdgeInsets.symmetric(vertical: 14.r),
                                  minimumSize: Size.fromHeight(50.r),
                                ),
                              ),
                              SizedBox(height: 16.h),
                               SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed:()=>Navigator.push(context, MaterialPageRoute(builder: (context)=> OrganisateurView())),
                                    label: Text(
                                      "Devenir organisateur",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueGrey,
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
                                  Text("Vous avez déjà un compte ? ",
                                      style: GoogleFonts.roboto(color: Colors.white70)),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,MaterialPageRoute(builder: (context)=> LoginView()));
                                      },
                                      child: Text(
                                        "Se connecter",
                                        style: GoogleFonts.roboto(
                                          color: Colors.orangeAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
       ] ),
      ),
    );
  }
}
