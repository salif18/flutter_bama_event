import 'package:bama/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildAppBar extends StatelessWidget {
  final String title;
  final bool bouttonAction;
  const BuildAppBar({
    super.key,
    required this.title,
    required this.bouttonAction,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: ColorApp.backgroundApp, // Couleur opaque
      pinned: true,
      floating: true,
      toolbarHeight: 45.h,
      leading: bouttonAction
          ? IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                size: 18.sp,
                color: Colors.white,
              ),
            )
          : null,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(color: ColorApp.backgroundApp),
        titlePadding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
        centerTitle: true,
        title: Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
