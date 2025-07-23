import 'package:bama/screens/auth/login.dart';
import 'package:bama/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildProfil extends StatefulWidget {
  const BuildProfil({super.key});

  @override
  State<BuildProfil> createState() => _BuildProfilState();
}

class _BuildProfilState extends State<BuildProfil> {
  Map<String, dynamic>? userDoc;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserDoc();
  }

  Future<void> getUserDoc() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        userDoc = doc.data();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
      sliver: SliverToBoxAdapter(
        child: SizedBox(
          height: 80.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: ColorApp.titleColor,
                radius: 30.r,
                child: ClipOval(
                  child:
                      user != null &&
                          user.photoURL != null &&
                          user.photoURL!.isNotEmpty
                      ? Image.network(
                          user.photoURL!,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset("assets/images/profil_default.webp"),
                        )
                      : Image.asset("assets/images/profil_default.webp"),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userDoc != null && userDoc!["name"] != null
                          ? userDoc!["name"]
                          : "user name",
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      user != null ? user.email ?? "" : "",
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: ColorApp.backgroundCard,
                          ),
                          onPressed: () async {
                            if (user != null) {
                              // Déconnexion
                              await FirebaseAuth.instance.signOut();

                              setState(() {
                                userDoc = null; // <--- Vider les données utilisateur
                              });

                              getUserDoc();
                            } else {
                              // Aller à la page de connexion
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginView(),
                                ),
                              );
                              if (result) {
                                getUserDoc();
                              }
                              ;
                            }
                          },
                          child: Text(
                            user != null ? "Déconnexion" : "Connexion",
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
