import 'package:bama/provider/notifcation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:bama/utils/colors.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Consumer<NotificationController>(
        builder: (context, controller, _) {
          return SwitchListTile(
            value: controller.isEnabled,
            title: Text(
              "Activer les notifications",
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey[200],
              ),
            ),
            activeColor: Colors.green,
            activeTrackColor: ColorApp.backgroundCard,
            inactiveThumbColor: ColorApp.backgroundApp,
            inactiveTrackColor: ColorApp.backgroundCard,
            onChanged: (value) {
              controller.toggleNotification(value);
            },
          );
        },
      ),
    );
  }
}
