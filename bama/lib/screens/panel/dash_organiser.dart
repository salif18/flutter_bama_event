import 'package:bama/components/appbar.dart';
import 'package:bama/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrganiserDashboard extends StatefulWidget {
  const OrganiserDashboard({super.key});

  @override
  State<OrganiserDashboard> createState() => _OrganiserDashboardState();
}

class _OrganiserDashboardState extends State<OrganiserDashboard> {
  Map<String, dynamic> stats = {
    'totalTickets': 0,
    'totalRevenue': 0,
    'totalCommission': 0,
    'netRevenue': 0,
  };

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('tickets')
        .where('organiserId', isEqualTo: userId)
        .get();

    int totalTickets = snapshot.docs.length;
    int totalRevenue = 0;
    int totalCommission = 0;

    // for (var doc in snapshot.docs) {
    //   totalRevenue += doc['price'] ?? 0;
    //   totalCommission += doc['commission'] ?? 0;
    // }

    setState(() {
      stats = {
        'totalTickets': totalTickets,
        'totalRevenue': totalRevenue,
        'totalCommission': totalCommission,
        'netRevenue': totalRevenue - totalCommission,
      };
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset: true,
      backgroundColor: ColorApp.backgroundApp,
      body: RefreshIndicator(
        onRefresh: _loadStats,
        child: SafeArea(
          child: Container(
               color: ColorApp.backgroundApp,
            child: CustomScrollView(
              slivers: [
                BuildAppBar(title: "Tableau de bord", bouttonAction: true),
                _buildCard("🎟️ Tickets vendus", stats['totalTickets'], Colors.indigo, Icons.confirmation_num),
                _buildCard("💰 Revenus totaux", stats['totalRevenue'], Colors.green, Icons.attach_money),
                _buildCard("💸 Commissions", stats['totalCommission'], Colors.orange, Icons.money_off),
                _buildCard("🧾 Revenus nets", stats['netRevenue'], Colors.blueGrey, Icons.receipt_long),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildCard(String title, int value, Color color, IconData icon) {
    return SliverToBoxAdapter(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: color,
        margin: EdgeInsets.symmetric(vertical: 8.r, horizontal: 16.r),
        child: ListTile(
          leading: Icon(icon, size: 32.sp, color: Colors.white),
          title: Text(title, style: const TextStyle(color: Colors.white)),
          trailing: Text("$value FCFA",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16.sp,
              )),
        ),
      ),
    );
  }
}
