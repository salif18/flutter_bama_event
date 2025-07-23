import 'package:bama/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanTicketPage extends StatefulWidget {
  const ScanTicketPage({Key? key}) : super(key: key);

  @override
  State<ScanTicketPage> createState() => _ScanTicketPageState();
}

class _ScanTicketPageState extends State<ScanTicketPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String? scannedCode;
  bool isProcessing = false;

  void _handleDetection(BarcodeCapture capture) async {
    final Barcode? barcode = capture.barcodes.isNotEmpty
        ? capture.barcodes.first
        : null;
    final String? code = barcode?.rawValue;

    if (code != null && !isProcessing) {
      setState(() {
        scannedCode = code;
        isProcessing = true;
      });

      await _verifyTicket(code);

      await Future.delayed(const Duration(seconds: 2));
      setState(() => isProcessing = false);
    }
  }

  Future<void> _verifyTicket(String code) async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('tickets')
          .where('qr_code', isEqualTo: code)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        _showDialog(
          "Ticket invalide ❌",
          "Ce QR code ne correspond à aucun ticket.",
        );
        return;
      }

      final ticket = query.docs.first;
      final bool isUsed = ticket['is_used'] == true;

      if (isUsed) {
        _showDialog("Déjà utilisé ⚠️", "Ce ticket a déjà été utilisé.");
      } else {
        // Marquer comme utilisé
        await ticket.reference.update({'is_used': true});
        _showDialog("Ticket valide ✅", "Accès autorisé à l'événement.");
      }
    } catch (e) {
      _showDialog("Erreur", "Une erreur est survenue : $e");
      print(e.toString());
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            child: const Text("OK", style: TextStyle(color: Colors.amber)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorApp.backgroundApp,
      appBar: AppBar(
        backgroundColor: ColorApp.backgroundApp,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 18.sp,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Scanner ticket",
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: ColorApp.backgroundApp,
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: MobileScanner(onDetect: _handleDetection),
              ),
              if (scannedCode != null)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Code détecté : $scannedCode',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white70,
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
