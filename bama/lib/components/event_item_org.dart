import 'package:bama/models/event_model.dart';
import 'package:bama/screens/detail/detail.dart';
import 'package:bama/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class EventItemOrg extends StatelessWidget {
  final Event item;
  const EventItemOrg({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailView(item: item)),
      ),
      child: Card(
        color: ColorApp.backgroundCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        elevation: 2,
        margin: EdgeInsets.only(bottom: 12.h),
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[200]!, // couleur de la bordure
                      width: 1.r, // épaisseur de la bordure
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      width: 100.w,
                      height: 100.h,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/images/image_default.png",
                          fit: BoxFit.cover,
                          width: 100.w,
                          height: 100.h,
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                item.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  color: Colors.amber,
                ),
              ),
              SizedBox(height: 4.h),
              Expanded(
                child: SizedBox(
                  height:
                      60.h, // Limite la hauteur pour ne pas dépasser la card
                  child: ListView.builder(
                    itemCount: item.ticketTypes.length,
                    itemBuilder: (context, index) {
                      final entry = item.ticketTypes[index];
                      return Row(
                        children: [
                          Icon(
                            Icons.confirmation_num,
                            size: 16.sp,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              "${entry.type}: ${entry.sold}/${entry.available}",
                              style: GoogleFonts.roboto(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
