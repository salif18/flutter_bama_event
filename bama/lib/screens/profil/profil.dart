import 'package:bama/components/appbar.dart';
import 'package:bama/screens/profil/widgets/buil_org_panel_btn.dart';
import 'package:bama/screens/profil/widgets/buil_panel_btn.dart';
import 'package:bama/screens/profil/widgets/build_about_btn.dart';
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
import 'package:flutter/material.dart';

class ProfilView extends StatefulWidget {
  const ProfilView({super.key});

  @override
  State<ProfilView> createState() => _ProfilViewState();
}

class _ProfilViewState extends State<ProfilView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: ColorApp.backgroundApp,
        body: SafeArea(child: Container(
          color: ColorApp.backgroundApp,
          child: CustomScrollView(
             slivers: [
              BuildAppBar(title:"Profil",bouttonAction:false),
              BuildProfil(),
              BuildPremiumBtn(),
              BuildMyEventBtn(),
              BuildCreateBtn(),
              BuildAdminPanelBtn(),
              BuildOrganiserPanelBtn(),
              BuildShareBtn(),
              BuildNotificationBtn(),
              BuildAboutBtn(),
              BuildAideBtn(),
              BuildSecurityBtn(),
              BuildDeleteCompte()
             ],
          ),
        )),
    );
  }
}