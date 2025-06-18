import 'package:bama/provider/notifcation_provider.dart';
import 'package:bama/screens/profil/notifcation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BuildNotificationBtn extends StatefulWidget {
  const BuildNotificationBtn({super.key});

  @override
  State<BuildNotificationBtn> createState() => _BuildNotificationBtnState();
}

class _BuildNotificationBtnState extends State<BuildNotificationBtn> {
  bool showNotificationPanel = false;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 2.r),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[500]!)),
              ),
              child: ListTile(
                onTap: () {
                  setState(() {
                    showNotificationPanel = !showNotificationPanel;
                  });
                },
                leading: Consumer<NotificationController>(
                  builder: (context, controller, _) {
                    return Icon(
                      controller.isEnabled
                          ? Icons.notifications_none
                          : Icons.notifications_off_outlined,
                      size: 22.sp,
                      color: Colors.grey[200],
                    );
                  },
                ),
                title: Text(
                  "Notification",
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[200],
                  ),
                ),
                trailing: Icon(
                  showNotificationPanel
                      ? Icons.keyboard_arrow_down_outlined
                      : Icons.arrow_forward_ios_rounded,
                  size: 18.sp,
                  color: Colors.grey[200],
                ),
              ),
            ),
            // Panneau notification visible seulement si activé
            if (showNotificationPanel) NotificationSettingsPage(),
          ],
        ),
      ),
    );
  }
}
