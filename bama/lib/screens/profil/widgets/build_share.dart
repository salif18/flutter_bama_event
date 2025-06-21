import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

class BuildShareBtn extends StatelessWidget {
  const BuildShareBtn({super.key});

 

// fonction de partage
  Future<void> shareApp(BuildContext context) async {
    const appUrl =
        "https://play.google.com/store/apps/details?id=votre.package.name";
    const message =
        "Découvrez cette super application ! Téléchargez-la ici: $appUrl";

    try {
      // Pour partager uniquement du texte, utilisez Share.share .
      // ignore: deprecated_member_use
      await Share.share(
        message,
        subject: 'Découvrez cette application',
        sharePositionOrigin: Rect.fromLTWH(
          0, 0,
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 2
        ),
      );

    } catch (e) {
      debugPrint("Erreur lors du partage: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible de partager pour le moment")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.r,),
      sliver: SliverToBoxAdapter(
        child: Container(
          decoration: BoxDecoration(
            // border: Border(bottom: BorderSide(color: Colors.grey[500]!))
          ),
          child: ListTile(
            onTap: () {
              shareApp(context);
            },
            leading: Icon(Icons.share, size: 22.sp, color: Colors.grey[200]),
            title: Text(
              "Partager",
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
