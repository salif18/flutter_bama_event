import 'package:bama/screens/events/event_adm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildAdmEventBtn extends StatelessWidget {
  const BuildAdmEventBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.r),
      sliver: SliverToBoxAdapter(
        child: Container(
          decoration: BoxDecoration(
            // border: Border(bottom: BorderSide(color: Colors.grey[500]!))
          ),
          child: ListTile(
            onTap: () {
             Navigator.push(context, MaterialPageRoute(builder: (context)=> EventAdm()));
            },
            leading: Icon(Icons.event_available_sharp, size: 22.sp, color: Colors.grey[200]),
            title: Text(
              "Les événements",
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
