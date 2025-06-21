import 'package:bama/models/event_model.dart';
import 'package:bama/screens/detail/widgets/ui_detail_appbar.dart';
import 'package:bama/screens/detail/widgets/ui_infos.dart';
import 'package:bama/screens/payement/payement.dart';
import 'package:bama/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailView extends StatefulWidget {
  final Event item;
  const DetailView({super.key, required this.item});

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      backgroundColor: ColorApp.backgroundApp,
      body: SafeArea(
        child: Container(
          color: ColorApp.backgroundApp,
          child: CustomScrollView(
            slivers: [
              // Image en haut avec bouton retour transparent
              SliverPersistentHeader(
                pinned: true,
                delegate: EventImageHeader(
                  imageUrl: widget.item.imageUrl,
                  minExtentHeight: 100.h,
                  maxExtentHeight: 300.h,
                  onBack: () => Navigator.pop(context),
                ),
              ),
              BuildInfoEvent(item: widget.item),
            ],
          ),
        ),
      ),
      // Bouton achat
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.r),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          onPressed: () => _windowShow(context),
          child: Text(
            "Acheter un ticket",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void _windowShow(context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ColorApp.backgroundApp,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Choisissez votre ticket",
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 12.h),
              ...widget.item.ticketTypes.map((ticket) {
                return Card(
                  color: ColorApp.backgroundCard,
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  child: ListTile(
                    title: Text(
                      ticket.type,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorApp.titleColor,
                      ),
                    ),
                    subtitle: Text(
                      "Accès ${ticket.type}",
                      style: GoogleFonts.poppins(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    trailing: Text(
                      "${ticket.price.toString()} FCFA",
                      style: GoogleFonts.montserrat(
                        fontSize: 12.sp,
                        color: ColorApp.titleColor,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PayementView(
                            eventId: widget.item.id,
                            eventTitle: widget.item.title,
                            ticketType: ticket.type,
                            userId: "12b",
                            organiserId: widget.item.organiserId,
                            amount: ticket.price,
                            PayOf: '',
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
