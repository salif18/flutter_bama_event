import 'package:bama/components/appbar.dart';
import 'package:bama/routes.dart';
import 'package:bama/screens/payement/payement.dart';
import 'package:bama/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AbonnementPage extends StatefulWidget {
  const AbonnementPage({super.key});

  @override
  State<AbonnementPage> createState() => _AbonnementPageState();
}

class _AbonnementPageState extends State<AbonnementPage> {
  bool hasTried = false;
  bool isLoading = false; // Pour afficher un loader pendant un paiement

  // Fonction pour activer un abonnement premium pendant 90 jours
  Future<void> activerEssay(BuildContext context) async {
    setState(() => isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      final finAbonnement = DateTime.now().add(Duration(days: 7));

      // ⚠️ À décommenter si tu veux enregistrer dans Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
            'isPremium': true,
            'role': "organisateur",
            'subscriptionUntil': finAbonnement.toIso8601String(),
            'startTrial': DateTime.now().toIso8601String(),
          });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Abonnement activé jusqu’au ${finAbonnement.day}/${finAbonnement.month}/${finAbonnement.year}",
          ),
        ),
      );
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Routes()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur : $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfUserHasTried();
  }

  // verification si le essay est epuise pour interdire certaine truc
  Future<void> checkIfUserHasTried() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final data = doc.data();

    if (data != null && data['startTrial'] != null) {
      setState(() {
        hasTried = true; // utilisateur a déjà activé un essai
        isLoading = false;
      });
    } else {
      setState(() {
        hasTried = false; // pas encore essayé
        isLoading = false;
      });
    }
  }

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
                        "Organisateur premium",
                        style: GoogleFonts.poppins(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "✅ Créez un nombre illimité d'événements\n"
                        "✅ Suivi des ventes et des revenus\n"
                        "✅ Statistiques avancées\n"
                        "✅ Priorité dans l'affichage",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "Tarif : 10 000 FCFA / mois",
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          color: ColorApp.titleColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 200.h),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PayementView(
                              eventId: "",
                              eventTitle: "",
                              ticketType: "Abonnement",
                              userId: "",
                              organiserId: "",
                              amount: 10000,
                              PayOf: "abonnement",
                            ),
                          ),
                        ),
                        icon: Icon(
                          Icons.lock_open,
                          size: 24.sp,
                          color: Colors.white,
                        ),
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
                      SizedBox(height: 16.h),
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : (!hasTried
                                ? ElevatedButton.icon(
                                    onPressed: () => activerEssay(context),
                                    icon: Icon(
                                      Icons.lock_open,
                                      size: 24.sp,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      "Mode d’Essai 7 jour",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14.r,
                                      ),
                                      minimumSize: Size.fromHeight(50.r),
                                    ),
                                  )
                                : SizedBox()), // bouton caché si déjà essayé
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
