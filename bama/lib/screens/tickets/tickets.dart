import 'package:bama/components/appbar.dart';
import 'package:bama/components/ticket_card.dart';
import 'package:bama/models/ticket_model.dart';
import 'package:bama/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TicketView extends StatefulWidget {
  const TicketView({super.key});

  @override
  State<TicketView> createState() => _TicketViewState();
}

class _TicketViewState extends State<TicketView> {
  Future<List<TicketModel>> fetchTickets({bool isUsed = false}) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return [];
 try {
    final snapshot = await FirebaseFirestore.instance
        .collection('tickets')
        .where('user_id', isEqualTo: user.uid)
        .where('is_used', isEqualTo: isUsed)
        .get();

    return snapshot.docs.map((doc) {
      return TicketModel.fromJson(doc.data());
    }).toList();
    } catch (e) {
    debugPrint('Erreur de parsing ticket: $e');
    return [];
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
          child: DefaultTabController(
            length: 2,
            child: CustomScrollView(
              slivers: [
                BuildAppBar(title: "Mes tickets", bouttonAction: false),
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.r,
                    vertical: 18.r,
                  ),
                  sliver: SliverPersistentHeader(
                    pinned: true,
                    floating: true,
                    delegate: _SliverAppBarDelegate(
                      child: _buildContainer(context),
                    ),
                  ),
                ),
                SliverFillRemaining(
                  child: TabBarView(
                    children: [
                      CustomScrollView(
                        slivers: [
                          FutureBuilder<List<TicketModel>>(
                            future: fetchTickets(isUsed: false),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SliverFillRemaining(
                                  child: Center(
                                    child: CircularProgressIndicator(color: Colors.orange.shade700,),
                                  ),
                                );
                              }

                              if (snapshot.hasError) {
                                return SliverFillRemaining(
                                  child: Center(
                                    child: Text("Erreur de chargement",style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.white),),
                                  ),
                                );
                              }

                              final tickets = snapshot.data ?? [];

                              if (tickets.isEmpty) {
                                return SliverFillRemaining(
                                  child: Center(
                                    child: Text("Aucun ticket en cours",style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.white),),
                                  ),
                                );
                              }

                              return SliverList(
                                delegate: SliverChildBuilderDelegate((
                                  context,
                                  index,
                                ) {
                                  return TicketCard(ticket: tickets[index]);
                                }, childCount: tickets.length),
                              );
                            },
                          ),
                        ],
                      ),
                      CustomScrollView(
                        slivers: [
                          FutureBuilder<List<TicketModel>>(
                            future: fetchTickets(isUsed: true),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SliverFillRemaining(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              if (snapshot.hasError) {
                                return SliverFillRemaining(
                                  child: Center(
                                    child: Text("Erreur de chargement",style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.white),),
                                  ),
                                );
                              }

                              final tickets = snapshot.data ?? [];

                              if (tickets.isEmpty) {
                                return SliverFillRemaining(
                                  child: Center(
                                    child: Text("Aucun ticket épuisé",style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.white),),
                                  ),
                                );
                              }

                              return SliverList(
                                delegate: SliverChildBuilderDelegate((
                                  context,
                                  index,
                                ) {
                                  return TicketCard(ticket: tickets[index]);
                                }, childCount: tickets.length),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildContainer(BuildContext context) {
  return Container(
    decoration: BoxDecoration(color: ColorApp.backgroundApp),
    child: Padding(
      padding: EdgeInsets.only(left: 8.r, right: 8.r),
      child: Material(
        color: ColorApp.backgroundCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(2.r),
            right: Radius.circular(2.r),
          ),
        ),
        child: TabBar(
          indicator: BoxDecoration(
            color: const Color.fromARGB(255, 173, 117, 44),
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(2.r),
              right: Radius.circular(2.r),
            ),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent, // 👈 empêche le petit trait du bas
          labelColor: Colors.white,
          unselectedLabelColor: ColorApp.titleColor,
          tabs: [
            Tab(
              child: Text(
                "En cours",
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Tab(
              child: Text(
                "Épuisés",
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverAppBarDelegate({required this.child});

  @override
  double get minExtent => kToolbarHeight;
  @override
  double get maxExtent => kToolbarHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
