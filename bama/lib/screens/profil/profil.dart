import 'package:bama/components/appbar.dart';
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
              BuildAppBar(title:"Profil",bouttonAction:false)
             ],
          ),
        )),
    );
  }
}