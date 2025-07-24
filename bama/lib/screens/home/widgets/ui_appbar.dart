import 'package:bama/screens/scan/scaner_ticket.dart';
import 'package:bama/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildAppBarHome extends StatefulWidget {
  const BuildAppBarHome({super.key});

  @override
  State<BuildAppBarHome> createState() => _BuildAppBarHomeState();
}

class _BuildAppBarHomeState extends State<BuildAppBarHome> {
  String? role;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserRole();
  }

  Future<void> fetchUserRole() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
        setState(() {
          role = doc.data()?['role'];
          isLoading = false;
        });
      }
    } catch (e) {
      print('Erreur récupération rôle: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: ColorApp.backgroundApp,
      pinned: true,
      floating: true,
      toolbarHeight: 50.h,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(color: ColorApp.backgroundApp),
        titlePadding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
        centerTitle: true,
        title: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
          child: Image.asset(
            "assets/logos/logo_principal.png",
            width: 140.w,
            height: 45.h,
            fit: BoxFit.cover,
          ),
        ),
      ),
      actions: [
        if (!isLoading && (role == "admin" || role == "organisateur"))
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ScanTicketPage()),
            ),
            icon: Icon(Icons.qr_code_scanner, size: 28.sp, color: const Color.fromARGB(255, 129, 98, 40)),
          ),
        SizedBox(width: 16.w),
      ],
    );
  }
}
