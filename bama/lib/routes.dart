import 'package:bama/screens/create_event/create_event.dart';
import 'package:bama/screens/home/home.dart';
import 'package:bama/screens/profil/profil.dart';
import 'package:bama/screens/tickets/tickets.dart';
import 'package:bama/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class Routes extends StatefulWidget {
  const Routes({super.key});

  @override
  State<Routes> createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: [HomeView(), TicketView(), FormEvent()][_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GNav(
      selectedIndex: _currentIndex,
      onTabChange: (index) => setState(() => _currentIndex = index),

      // Layout & animation
      mainAxisAlignment: MainAxisAlignment.center,
      padding: EdgeInsets.all(8.r),
      tabMargin: EdgeInsets.all(8.r),
      gap: 5.r,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,

      // Thème dynamique
      backgroundColor: isDark ? Colors.black : ColorApp.backgroundApp,
      tabBackgroundColor: isDark
          ? Colors.grey[900]!
          : const Color.fromARGB(255, 4, 13, 15),
      activeColor: const Color(0xFFFFC200),
      textStyle: GoogleFonts.roboto(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: isDark ? Colors.white : ColorApp.titleColor,
      ),

      // Onglets
      tabs: [
        GButton(
          icon: Icons.home_rounded,
          text: "Evenements",
          iconColor: Colors.white,
          iconSize: 24.sp,
        ),
        GButton(
          icon: LineIcons.alternateTicket,
          text: "Tickets",
          iconSize: 24.sp,
          iconColor: Colors.white,
          leading: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(LineIcons.alternateTicket, size: 24.sp, color: Colors.white),
              Positioned(
                right: -6,
                top: -2,
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "5", // nombre de notifications
                    style: TextStyle(fontSize: 10.sp, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),

        GButton(
          icon: Icons.person_outline_outlined,
          text: "Profil",
          iconColor: Colors.white,
          iconSize: 24.sp,
        ),
      ],
    );
  }
}
