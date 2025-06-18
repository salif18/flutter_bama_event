import 'package:bama/screens/home/widgets/ui_appbar.dart';
import 'package:bama/screens/home/widgets/ui_categories_list.dart';
import 'package:bama/screens/home/widgets/ui_event_list.dart';
import 'package:bama/screens/home/widgets/ui_slider.dart';
import 'package:bama/screens/home/widgets/ui_welcom_user.dart';
import 'package:bama/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
                BuildAppBarHome(),
                BuildWelcomMessage(),
                _buildTitle(context, "Les plus proches"),
                ImageSlider(),
                _buildTitle(context, "Catégories"),
                BuildCategoriList(),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 8.r,vertical: 18.r),
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
                          BuildEvenList(), // doit être un sliver, ex: SliverList ou SliverToBoxAdapter
                        ],
                      ),
                      CustomScrollView(
                        slivers: [
                          BuildEvenList(), // autre contenu
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

  Widget _buildTitle(BuildContext context, title) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
      sliver: SliverToBoxAdapter(
        child: Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.amber,
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
            left: Radius.circular(20.r),
            right: Radius.circular(20.r),
          ),
        ),
        child: TabBar(
          indicator: BoxDecoration(
            color: ColorApp.titleColor,
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(20.r),
              right: Radius.circular(20.r),
            ),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent, // 👈 empêche le petit trait du bas
          labelColor: Colors.black,
          unselectedLabelColor: ColorApp.titleColor,
          tabs: [
            Tab(
              child: Text(
                "Evènements à venir",
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Tab(
              child: Text(
                "Evènements passés",
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
