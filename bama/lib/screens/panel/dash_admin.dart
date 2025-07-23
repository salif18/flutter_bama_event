import 'package:bama/components/appbar.dart';
import 'package:bama/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Map<String, dynamic> stats = {
    'totalTickets': 0,
    'totalRevenue': 0,
    'totalCommission': 0,
  };

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('tickets')
        .get();

    int totalTickets = snapshot.docs.length;
    int totalRevenue = 0;
    int totalCommission = 0;

    for (var doc in snapshot.docs) {
      totalRevenue += doc['netRevenue'] as int ;
      totalCommission += doc['commission']as int ;
    }

    setState(() {
      stats = {
        'totalTickets': totalTickets,
        'totalRevenue': totalRevenue,
        'totalCommission': totalCommission,
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
                BuildAppBar(
                  title: "Statistiques globales",
                  bouttonAction: true,
                ),
                _buildCard(
                  "🎟️ Total tickets vendus",
                  stats['totalTickets'],
                  Colors.purple,
                  Icons.confirmation_num,
                ),
                _buildCard(
                  "💰 Revenus totaux",
                  stats['totalRevenue'],
                  Colors.teal,
                  Icons.attach_money,
                ),
                _buildCard(
                  "🏛️ Commissions plateforme",
                  stats['totalCommission'],
                  Colors.redAccent,
                  Icons.account_balance_wallet,
                ),
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
          trailing: Text(
            "$value FCFA",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }
}
