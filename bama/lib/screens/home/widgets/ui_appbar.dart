import 'package:bama/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildAppBarHome extends StatelessWidget {
  const BuildAppBarHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: ColorApp.backgroundApp, // Couleur opaque
      pinned: true,
      floating: true,
      toolbarHeight: 45.h,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(color: ColorApp.backgroundApp,),
        titlePadding: EdgeInsets.symmetric(horizontal: 16.r,vertical:8.r),
        // centerTitle: true,
        title:Image.asset("assets/logos/logo1.png",
         width: 140.w,
          height: 60.h,
          fit: BoxFit.cover,) 
        // RichText(
        //   text: TextSpan(
        //     children: [
        //       TextSpan(
        //         text: "bama",
        //         style: GoogleFonts.abel(
        //           fontSize: 24.sp,
        //           fontWeight: FontWeight.w600,
        //           color: ColorApp.titleColor
        //         ),
        //       ),
        //       TextSpan(
        //         text: "E",
        //         style: GoogleFonts.abel(
        //          fontSize: 24.sp,
        //           fontWeight: FontWeight.w600,
        //           color: Colors.white,
        //         ),
        //       ),
        //       TextSpan(
        //         text: "VENTS",
        //         style: GoogleFonts.abel(
        //           fontSize: 24.sp,
        //           fontWeight: FontWeight.w600,
        //          color: ColorApp.titleColor
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
