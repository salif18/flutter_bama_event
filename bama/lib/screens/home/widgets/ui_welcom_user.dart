import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BuildWelcomMessage extends StatefulWidget {
  const BuildWelcomMessage({super.key});

  @override
  State<BuildWelcomMessage> createState() => _BuildWelcomMessageState();
}

class _BuildWelcomMessageState extends State<BuildWelcomMessage> {
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
    String? photoURL = user?.photoURL;

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    userDoc != null && userDoc!["name"] != null ?
                  "Salut, ${userDoc!["name"] ??'' }" :  "Salut, " ,
                  style: GoogleFonts.roboto(
                    fontSize: 20.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Découvrir ce qui se pointe à proximité",
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    color: const Color.fromARGB(255, 219, 217, 217),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            CircleAvatar(
              radius: 22.r,
              backgroundColor: Colors.white,
              backgroundImage: photoURL != null
                  ? NetworkImage(photoURL)
                  : const AssetImage("assets/images/profil_default.webp")
                      as ImageProvider,
            ),
          ],
        ),
      ),
    );
  }
}
