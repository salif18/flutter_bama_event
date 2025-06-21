import 'package:bama/components/appbar.dart';
import 'package:bama/screens/payement/payement.dart';
import 'package:bama/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AbonnementPage extends StatefulWidget {
  const AbonnementPage({super.key});

  @override
  State<AbonnementPage> createState() => _AbonnementPageState();
}

class _AbonnementPageState extends State<AbonnementPage> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorApp.backgroundApp,
      body: SafeArea(
        child: Container(
          color: ColorApp.backgroundApp,
          child: CustomScrollView(
            slivers: [
              BuildAppBar(title: "Abonnement premium", bouttonAction: true),
              SliverPadding(
                padding: EdgeInsets.all(16.r),
                sliver: SliverFillRemaining(
                   hasScrollBody: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Devenir organisateur premium",
                        style: GoogleFonts.poppins(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "✅ Créez un nombre illimité d'événements\n"
                        "✅ Suivi des ventes et des revenus\n"
                        "✅ Statistiques avancées\n"
                        "✅ Priorité dans l'affichage",
                        style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.white),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "Tarif : 10 000 FCFA / mois",
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          color: ColorApp.titleColor,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 200.h,),
                      ElevatedButton.icon(
                              onPressed:()=> Navigator.push(context, MaterialPageRoute(
                                builder: (context)=> 
                              PayementView(
                                eventId: "", 
                                eventTitle: "", 
                                ticketType: "Abonnement", 
                                userId: "", 
                                organiserId: "", 
                                amount: 10000, 
                                PayOf: "abonnement"))),
                              icon: Icon(Icons.lock_open, size: 24.sp, color: Colors.white,),
                              label: Text(
                                "Activer maintenant",
                                style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: EdgeInsets.symmetric(vertical: 14.r),
                                minimumSize: Size.fromHeight(50.r),
                              ),
                            ),
                    ],
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
