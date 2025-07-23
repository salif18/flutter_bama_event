import 'package:bama/api/mobile_money_service.dart';
import 'package:bama/components/appbar.dart';
import 'package:bama/models/ticket_model.dart';
import 'package:bama/routes.dart';
import 'package:bama/screens/tickets/tickets.dart';
import 'package:bama/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class PayementView extends StatefulWidget {
  final String eventId;
  final String eventTitle;
  final String ticketType;
  final String userId;
  final String organiserId;
  final int amount;
  final String PayOf;
  const PayementView({
    super.key,
    required this.eventId,
    required this.eventTitle,
    required this.ticketType,
    required this.userId,
    required this.organiserId,
    required this.amount,
    required this.PayOf,
  });

  @override
  State<PayementView> createState() => _PayementViewState();
}

class _PayementViewState extends State<PayementView> {
  // Instances des services de paiement
  OrangeMoneyService _orangeApi = OrangeMoneyService();
  MobiCashService _mobicashApi = MobiCashService();

  bool isLoading = false; // Pour afficher un loader pendant un paiement
  final TextEditingController _amountController =
      TextEditingController(); // Champ montant
  String selectedMethod = 'Orange Money'; // Méthode de paiement par défaut

  // Initialisation
  @override
  void initState() {
    super.initState();
    _amountController.text = widget.amount
        .toString(); // Remplit le montant automatiquement
  }

  // Fonction principale de paiement
  void _pay() async {
    String amount = _amountController.text.trim();
    final user = FirebaseAuth.instance.currentUser;

    Fluttertoast.showToast(
      msg: "Paiement de $amount FCFA via $selectedMethod en cours...",
      backgroundColor: Colors.deepOrange,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
    );

    // Paiement selon la méthode choisie
    if (selectedMethod == 'Orange Money') {
      if (widget.PayOf == "abonnement") {
        await _orangeApi.payer(amount: widget.amount, orderId: user!.uid);
        activerAbonnement(amount); // Active l’abonnement
      }
      await _orangeApi.payer(amount: widget.amount, orderId: user!.uid);
    } else if (selectedMethod == "MobiCash") {
      if (widget.PayOf == "abonnement") {
        await _mobicashApi.payer(amount: widget.amount, orderId: user!.uid);
        activerAbonnement(amount);
      }
      await _mobicashApi.payer(amount: widget.amount, orderId: user!.uid);
    }

    // Calcul de la commission et du revenu net
    const double commissionRate = 0.10;
    final int commission = (widget.amount * commissionRate).round();
    final int netRevenue = widget.amount - commission;

    // Création du ticket après paiement
    buyTicket(
      eventId: widget.eventId,
      eventTitle: widget.eventTitle,
      ticketType: widget.ticketType,
      organiserId: widget.organiserId,
      commission: commission,
      netRevenue: netRevenue,
    );
  }

  // Fonction pour créer un ticket dans Firestore
  Future<void> buyTicket({
    required String eventId,
    required String eventTitle,
    required String ticketType,
    required String organiserId,
    required int commission,
    required int netRevenue,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    final id = FirebaseFirestore.instance.collection('tickets').doc().id;

    final ticket = TicketModel(
      ticketId: id,
      eventId: eventId,
      userId: user!.uid,
      eventTitle: eventTitle,
      ticketType: ticketType,
      organiserId: organiserId,
      commission: commission,
      netRevenue: netRevenue,
      qrCode: id,
      purchasedAt: DateTime.now().toIso8601String(),
      isUsed: false,
    );

    // Enregistre le ticket dans Firestore
    await FirebaseFirestore.instance
        .collection('tickets')
        .doc(id)
        .set(ticket.toJson());

    // Sauvegarde la commission pour des statistiques futures
    await FirebaseFirestore.instance.collection('commissions').add({
      'ticketId': id,
      'eventId': eventId,
      'userId': user.uid,
      'organiserId': organiserId,
      'commission': commission,
      'timestamp': DateTime.now(),
    });

    // Incrémente le nombre de tickets vendus
    await incrementSoldCount(
      eventId: widget.eventId,
      ticketType: widget.ticketType,
    );

    // Redirection vers la page des tickets
    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => TicketView()));
  }

  // Fonction pour activer un abonnement premium pendant 90 jours
  Future<void> activerAbonnement(amount) async {
    setState(() => isLoading = true);

    try {
      final finAbonnement = DateTime.now().add(Duration(days: 90));
      final user = FirebaseAuth.instance.currentUser;

      // ⚠️ À décommenter si tu veux enregistrer dans Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
            'isPremium': true,
            'subscriptionUntil': finAbonnement.toIso8601String(),
            'startTrial': DateTime.now().toIso8601String(),
          });

      await FirebaseFirestore.instance
      .collection('abonnements')
      .add({
        'montant':amount,
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
      print("Erreur abonnement : $e");
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur : $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> incrementSoldCount({
    required String eventId,
    required String ticketType,
  }) async {
    final docRef = FirebaseFirestore.instance.collection('events').doc(eventId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) return;

      List<dynamic> ticketTypes = snapshot.data()!['ticketTypes'];

      for (int i = 0; i < ticketTypes.length; i++) {
        final ticket = ticketTypes[i];

        if (ticket['type'].toString().trim() == ticketType.trim()) {
          int currentSold = ticket['sold'] ?? 0;
          ticket['sold'] = currentSold + 1;
          ticketTypes[i] = ticket;
          break;
        }
      }

      // Mise à jour de tout le tableau ticketTypes
      transaction.update(docRef, {'ticketTypes': ticketTypes});
    });
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
              BuildAppBar(
                title: "Ticket ${widget.ticketType}",
                bouttonAction: true,
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 16.r),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Choisissez une méthode de paiement",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      DropdownButtonFormField<String>(
                        isDense: false,
                        dropdownColor: ColorApp.backgroundCard,
                        value: selectedMethod,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: ['Orange Money', 'MobiCash'].map((method) {
                          return DropdownMenuItem(
                            value: method,
                            child: Row(
                              children: [
                                Image.asset(
                                  method == "Orange Money"
                                      ? "assets/logos/orange.jpg"
                                      : "assets/logos/moov.webp",
                                  width: 30.w,
                                  height: 30.h,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(width: 20.w),
                                Text(
                                  method,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedMethod = val!;
                          });
                        },
                      ),
                      TextField(
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        controller: _amountController,
                        decoration: InputDecoration(
                          labelText: "Montant (FCFA)",
                          labelStyle: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.money,
                            size: 20.sp,
                            color: Colors.white,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 20.h),
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton.icon(
                              onPressed: _pay,
                              icon: Icon(Icons.payment, color: Colors.white),
                              label: Text(
                                "Payer",
                                style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    50,
                                  ),
                                ),
                                minimumSize: Size(400.w, 40.h),
                                backgroundColor: Colors.deepOrange,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 30.r,
                                  vertical: 12.r,
                                ),
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
