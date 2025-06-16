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
        body: SafeArea(child: Container(
          color: ColorApp.backgroundApp,
          child: CustomScrollView(
            slivers: [
              BuildAppBarHome(),
              BuildWelcomMessage(),
              _buildTitle(context, "Les plus proches"),
              ImageSlider(),
              _buildTitle(context, "Catégories"),
              BuildCategoriList(),
              _buildTitle(context, "Evènements à venir"),
              BuildEvenList()
            ],
          ),
        )),
    );
  }

  Widget _buildTitle(BuildContext context, title){
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.r ,vertical: 8.r),
      sliver: SliverToBoxAdapter( 
        child: Text(title, style: GoogleFonts.roboto(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: Colors.amber
        ),),
      ),
      ) ;
  }
}