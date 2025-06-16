import 'package:bama/routes.dart';
import 'package:bama/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  
  // Définir la couleur et le style de la status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: ColorApp.backgroundApp,// 👈 ta couleur de fond souhaitée
      statusBarIconBrightness:
          Brightness.dark, // ou Brightness.dark si fond clair
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Bama Events',
          debugShowCheckedModeBanner: false,
          home: SafeArea(
            child: child!,
          ),
        );
      },
      child: Routes(),
    );
  }
}
