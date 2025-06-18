import 'package:bama/screens/scan/scaner_ticket.dart';
import 'package:bama/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildAppBarHome extends StatelessWidget {
  const BuildAppBarHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: ColorApp.backgroundApp, // Couleur opaque
      pinned: true,
      floating: true,
      toolbarHeight:50.h,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(color: ColorApp.backgroundApp,),
        titlePadding: EdgeInsets.symmetric(horizontal: 16.r,vertical:8.r),
        centerTitle: true,
        title:Container(         
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r)
          ),
          child: Image.asset("assets/logos/logo_principal.png",
           width: 140.w,
            height: 45.h,
            fit: BoxFit.cover,),
        ) ,
      ),
      actions: [
        IconButton(
          onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => ScanTicketPage())),
          icon: Icon(Icons.qr_code_scanner, size: 28.sp,color: const Color.fromARGB(255, 129, 98, 40))),
        SizedBox(width: 16.w)
      ],
    );
  }
}
