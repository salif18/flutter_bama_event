import 'package:bama/components/appbar.dart';
import 'package:bama/models/ticket_model.dart';
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
  const PayementView({
    super.key,
    required this.eventId,
    required this.eventTitle,
    required this.ticketType,
    required this.userId,
    required this.organiserId,
    required this.amount,
  });

  @override
  State<PayementView> createState() => _PayementViewState();
}

class _PayementViewState extends State<PayementView> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String selectedMethod = 'Orange Money';

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.amount.toString();
  }

  void _pay() {
    String phone = _phoneController.text.trim();
    String amount = _amountController.text.trim();

    if (phone.isEmpty || amount.isEmpty) {
      Fluttertoast.showToast(
        msg: "Veuillez remplir tous les champs",
        backgroundColor: Colors.deepOrange,
        textColor: Colors.white,
      );
      return;
    }

    // Simule un paiement
    Fluttertoast.showToast(
      msg: "Paiement de $amount FCFA via $selectedMethod en cours...",
      toastLength: Toast.LENGTH_LONG,
    );

    //Intégrer ici l’API Orange Money / MobiCash

    //declencher la fonction pour creer ticket apres avoir acheter
    // final user = FirebaseAuth.instance.currentUser;
    // final id = FirebaseFirestore.instance.collection('tickets').doc().id;

    const double commissionRate = 0.10; // 10%
    final int commission = (widget.amount * commissionRate).round();
    final int netRevenue = widget.amount - commission;

    buyTicket(
      eventId: widget.eventId,
      eventTitle: widget.eventTitle,
      ticketType: widget.ticketType,
      organiserId: widget.organiserId,
      commission: commission,
      netRevenue: netRevenue,
    );
  }

  // 4️⃣ CRÉATION DE TICKET APRÈS ACHAT
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
    await FirebaseFirestore.instance
        .collection('tickets')
        .doc(id)
        .set(ticket.toJson());

    print(ticket);

    // Enregistrer la commission dans une autre collection (facultatif mais recommandé)
    await FirebaseFirestore.instance.collection('commissions').add({
      'ticketId': id,
      'eventId': eventId,
      'userId': user.uid,
      'organiserId': organiserId,
      'commission': commission,
      'timestamp': DateTime.now(),
    });

    Navigator.push(context, MaterialPageRoute(builder: (_) => TicketView()));
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
                      SizedBox(height: 16.h),
                      TextField(
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: "Numéro de téléphone",
                          labelStyle: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.phone,
                            size: 20.sp,
                            color: Colors.white,
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 16.h),
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
                      ElevatedButton.icon(
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
                            borderRadius: BorderRadiusGeometry.circular(50),
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
