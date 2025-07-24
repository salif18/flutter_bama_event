import 'package:bama/components/notification.dart';
import 'package:bama/provider/notifcation_provider.dart';
import 'package:bama/routes.dart';
import 'package:bama/globale.dart';
import 'package:bama/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

// Permet de declencher la notification en arriere plan meme si app est fermé
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Message reçu en arrière-plan complet : ${message.notification?.body}");
}

void main() async {
  // Définir la couleur et le style de la status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: ColorApp.backgroundApp, // 👈 ta couleur de fond souhaitée
      statusBarIconBrightness:
          Brightness.light, // ou Brightness.dark si fond clair
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.instance.subscribeToTopic('notify_all_users');

  // lire la notification en arriere plan
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  WidgetsFlutterBinding.ensureInitialized();
  // Initialiser les données locales pour 'fr_FR'
  await initializeDateFormatting('fr_FR', null);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  // Dans votre widget principal
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      NotificationService().initialize(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          navigatorKey:
              navigatorKey, // pour activation desactivation de notification soit pris en compte navigatorkey
          title: 'Bama Events',
          debugShowCheckedModeBanner: false,
          locale: Locale('fr', 'FR'), // Définir la locale par défaut
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [Locale('fr', 'FR')],
          home: SafeArea(child: child!),
        );
      },
      child: Routes(),
    );
  }
}


// 🛠 Résumé des commandes utiles :
// bash
// Copier
// Modifier
// # Obtenir SHA-1 :
// cd android
// ./gradlew signingReport
// bash
// Copier
// Modifier
// # Nettoyage et redémarrage
// flutter clean
// flutter pub get
// flutter run