import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildMyEventBtn extends StatelessWidget {
  const BuildMyEventBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 2.r),
      sliver: SliverToBoxAdapter(
        child: Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[500]!))
          ),
          child: ListTile(
            onTap: () {
            
            },
            leading: Icon(Icons.event_available_sharp, size: 22.sp, color: Colors.grey[200]),
            title: Text(
              "Mes événements",
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey[200],
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18.sp,
              color: Colors.grey[200],
            ),
          ),
        ),
      ),
    );
  }
}
