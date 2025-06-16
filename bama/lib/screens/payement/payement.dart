import 'package:bama/components/appbar.dart';
import 'package:bama/models/ticket_model.dart';
import 'package:bama/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class PayementView extends StatefulWidget {
  final String eventId;
  final String ticketType;
  final String userId;
  const PayementView({
    super.key,
    required this.eventId,
    required this.ticketType,
    required this.userId,
  });

  @override
  State<PayementView> createState() => _PayementViewState();
}

class _PayementViewState extends State<PayementView> {
  // 4️⃣ CRÉATION DE TICKET APRÈS ACHAT
  Future<void> buyTicket({
    required String eventId,
    required String ticketType,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    final id = FirebaseFirestore.instance.collection('tickets').doc().id;
    final ticket = TicketModel(
      ticketId: id,
      eventId: eventId,
      userId: user!.uid,
      eventTitle: '',
      ticketType: ticketType,
      qrCode: id,
      purchasedAt: DateTime.now().toIso8601String(),
      isUsed: false,
    );
    await FirebaseFirestore.instance
        .collection('tickets')
        .doc(id)
        .set(ticket.toJson());
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => TicketView(ticket: response.data),
    //   ),
    // );
  }

  // 5️⃣ SCANNER ET VÉRIFIER UN TICKET
  // Future<String> scanAndVerifyTicket(String currentEventId) async {
  //   final scannedId = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.QR);

  //   if (scannedId == '-1') return 'Scan annulé';

  //   final doc = await FirebaseFirestore.instance.collection('tickets').doc(scannedId).get();
  //   if (!doc.exists) return '❌ Ticket invalide';

  //   final ticket = TicketModel.fromJson(doc.data()!);
  //   if (ticket.eventId != currentEventId) return '❌ Mauvais événement';
  //   if (ticket.isUsed) return '⚠️ Déjà utilisé';

  //   await FirebaseFirestore.instance.collection('tickets').doc(ticket.ticketId).update({"is_used": true});
  //   return '✅ Ticket validé';
  // }

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
              BuildAppBar(title: "Mode de payement", bouttonAction: true),
            ],
          ),
        ),
      ),
    );
  }
}
