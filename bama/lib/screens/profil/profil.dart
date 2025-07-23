import 'package:bama/components/appbar.dart';
import 'package:bama/screens/profil/widgets/buil_org_panel_btn.dart';
import 'package:bama/screens/profil/widgets/buil_admin_panel_btn.dart';
import 'package:bama/screens/profil/widgets/build_about_btn.dart';
import 'package:bama/screens/profil/widgets/build_adm_event_btn..dart';
import 'package:bama/screens/profil/widgets/build_aide.dart';
import 'package:bama/screens/profil/widgets/build_create_btn.dart';
import 'package:bama/screens/profil/widgets/build_delete_compte.dart';
import 'package:bama/screens/profil/widgets/build_mes_event_btn.dart';
import 'package:bama/screens/profil/widgets/build_notification.dart';
import 'package:bama/screens/profil/widgets/build_organ_btn.dart';
import 'package:bama/screens/profil/widgets/build_profil.dart';
import 'package:bama/screens/profil/widgets/build_security_btn.dart';
import 'package:bama/screens/profil/widgets/build_share.dart';
import 'package:bama/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilView extends StatefulWidget {
  const ProfilView({super.key});

  @override
  State<ProfilView> createState() => _ProfilViewState();
}


class _ProfilViewState extends State<ProfilView> {
  String? userRole;
  bool isLoading = true;
  Stream<User?>? _authStream;

  @override
  void initState() {
    super.initState();
    _authStream = FirebaseAuth.instance.authStateChanges();
    _authStream!.listen((user) {
      if (user != null) {
        fetchUserRole(user.uid);
      } else {
        setState(() {
          userRole = null;
          isLoading = false;
        });
      }
    });
  }

  Future<void> fetchUserRole(String uid) async {
    setState(() => isLoading = true);
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    setState(() {
      userRole = doc.data()?['role'] ?? 'utilisateur';
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorApp.backgroundApp,
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator(color: Colors.orange.shade700,))
            : CustomScrollView(
                slivers: [
                  BuildAppBar(title: "Profil", bouttonAction: false),
                  BuildProfil(),
                  if(userRole != null)
                  BuildPremiumBtn(),
                  if (userRole == "admin" || userRole == "organisateur")
                    BuildMyEventBtn(),
                  if (userRole == "admin")
                    BuildAdmEventBtn(),
                  if (userRole == "admin" || userRole == "organisateur")
                    BuildCreateBtn(),
                  if (userRole == "admin")
                    BuildAdminPanelBtn(),
                  if (userRole == "admin" || userRole == "organisateur")
                    BuildOrganiserPanelBtn(),
                  BuildShareBtn(),
                  BuildNotificationBtn(),
                  BuildAboutBtn(),
                  BuildAideBtn(),
                  BuildSecurityBtn(),
                  BuildDeleteCompte()
                ],
              ),
      ),
    );
  }
}
