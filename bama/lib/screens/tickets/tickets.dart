import 'package:bama/components/appbar.dart';
import 'package:bama/components/ticket_card.dart';
import 'package:bama/models/ticket_model.dart';
import 'package:bama/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TicketView extends StatefulWidget {
  const TicketView({super.key});

  @override
  State<TicketView> createState() => _TicketViewState();
}

class _TicketViewState extends State<TicketView> {
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
                          // doit être un sliver, ex: SliverList ou SliverToBoxAdapter
                          SliverPadding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.r,
                              vertical: 8.r,
                            ),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate((
                                BuildContext context,
                                index,
                              ) {
                                TicketModel item =
                                    TicketModel.generateFakeTickets()[index];
                                return TicketCard(ticket: item);
                              }, childCount: 1),
                            ),
                          ),
                        ],
                      ),
                      CustomScrollView(
                        slivers: [
                          // autre contenu
                          SliverPadding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.r,
                              vertical: 8.r,
                            ),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, index) {
                                  TicketModel item =
                                      TicketModel.generateFakeTickets()[index];
                                  return TicketCard(ticket: item);
                                },
                                childCount:
                                    TicketModel.generateFakeTickets().length,
                              ),
                            ),
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
