import 'package:bama/components/appbar.dart';
import 'package:bama/utils/colors.dart';
import 'package:flutter/material.dart';

class Category extends StatelessWidget {
  final String categorie;
  const Category({super.key, required this.categorie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: ColorApp.backgroundApp,
        body: SafeArea(child: Container(
          color: ColorApp.backgroundApp,
          child: CustomScrollView(
             slivers: [
              BuildAppBar(title:categorie,bouttonAction:true)
             ],
          ),
        )),
    );
  }
}