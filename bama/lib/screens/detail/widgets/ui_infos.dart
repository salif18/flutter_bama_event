import 'package:bama/models/event_model.dart';
import 'package:bama/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildInfoEvent extends StatelessWidget {
  final Event item;
  const BuildInfoEvent({super.key,  required this.item});

  //partager la position dans googlemaps
 void shareEventLocation(BuildContext context) async {
  final double latitude = item.lat ?? 0;
  final double longitude = item.long ?? 0;
  final Uri shareUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

  if (await canLaunchUrl(shareUri)) {
    await launchUrl(shareUri, mode: LaunchMode.platformDefault); // Au lieu de externalApplication);
  } else {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Impossible d'ouvrir Google Maps.",
          style: GoogleFonts.roboto(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 16.r),
      sliver: // Détails de l'événement
      SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  Icons.calendar_month,
                  size: 24.sp,
                  color: ColorApp.titleColor,
                ),
                SizedBox(width: 8.w),
                Text(
                 item.date,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorApp.titleColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.access_time, size: 24.sp, color: Colors.white),
                SizedBox(width: 8.w),
                Text(
                 item.horaire,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            InkWell(
              onTap: () => shareEventLocation(context),
              child: Row(
                children: [
                  Icon(Icons.location_on, size: 24.sp, color: Colors.white),
                  SizedBox(width: 8.w),
                  Text(
                   item.location,
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'À propos de l’événement',
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.amber,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.r ,vertical: 8.r),
              decoration: BoxDecoration(
                color: ColorApp.backgroundCard,
                borderRadius: BorderRadius.circular(10.r)
              ),
              child: Text(
               item.description,
                style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.white),
              ),
            ),
            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }
}
