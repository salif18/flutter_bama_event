import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildWelcomMessage extends StatelessWidget {
  const BuildWelcomMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 16.r, vertical: 8.r),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Salut, Salif !",
                  style: GoogleFonts.roboto(
                    fontSize: 20.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Explore ce qui se pointe à proximité",
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    color: const Color.fromARGB(255, 219, 217, 217),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
             Expanded(
               child: CircleAvatar(
                radius: 20.r,
                child: ClipOval(
                  child: Image.asset(
                    "assets/images/profil_default.webp", 
                     fit: BoxFit.cover,
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
