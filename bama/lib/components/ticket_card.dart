import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/ticket_model.dart';
import '../utils/colors.dart';

class TicketCard extends StatelessWidget {
  final TicketModel ticket;

  const TicketCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: ColorApp.backgroundCard,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipPath(
        clipper: TicketClipper(),
        child: Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: ColorApp.backgroundCard,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bande colorée avec titre
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                  color: Colors.amber[600],
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Text(
                    '${ticket.ticketType.toUpperCase()} PASS',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Informations
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '🎟️ ID: ${ticket.ticketId.substring(0, 8)}',
                    style: GoogleFonts.poppins(fontSize: 12.sp, color: Colors.grey[300]),
                  ),
                  Text(
                    '👤 ${ticket.userId}',
                    style: GoogleFonts.poppins(fontSize: 12.sp, color: Colors.grey[300]),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Text(
                '📅 Acheté le: ${ticket.purchasedAt.split("T").first}',
                style: GoogleFonts.poppins(fontSize: 13.sp, color: ColorApp.titleColor),
              ),
              SizedBox(height: 20.h),

              // QR Code
              Center(
                child: QrImageView(
                  data: ticket.qrCode,
                  version: QrVersions.auto,
                  size: 130.w,
                  backgroundColor: Colors.white,
                  // ignore: deprecated_member_use
                  foregroundColor: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 🎯 Clippeur pour effet ticket (style découpe sur les bords)
class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final radius = 12.r;
    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(0, size.height * 0.3);
    path.arcToPoint(
      Offset(0, size.height * 0.7),
      radius: Radius.circular(radius),
      clockwise: false,
    );
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height * 0.7);
    path.arcToPoint(
      Offset(size.width, size.height * 0.3),
      radius: Radius.circular(radius),
      clockwise: false,
    );
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
