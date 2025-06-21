import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';

class CategorieModel {
  final IconData icon;
  final String title;
  final Color color;

  CategorieModel({
    required this.icon,
    required this.title,
    required this.color,
  });

  static List<CategorieModel> getCategorie() {
    return [
      CategorieModel(
        icon: Mdi.partyPopper,
        title: 'Concert',
        color: Colors.grey[100]!,
      ),
      CategorieModel(
        icon: Mdi.food,
        title: 'Diné',
        color: Colors.deepOrange,
      ),
      CategorieModel(
        icon: Mdi.theater,
        title: 'Festival',
        color: Colors.purpleAccent,
      ),
      CategorieModel(
        icon: Mdi.shopping,
        title: 'Foire',
        color: Colors.pinkAccent,
      ),
      CategorieModel(
        icon: Mdi.emoticonHappyOutline,
        title: 'Soirée',
        color: Colors.orangeAccent,
      ),
      CategorieModel(
        icon: Mdi.movieOpenOutline,
        title: 'Cinema',
        color: Colors.blueAccent,
      ),
      CategorieModel(
        icon: Mdi.emoticonExcitedOutline,
        title: 'Humour',
        color: Colors.tealAccent,
      ),
      CategorieModel(
        icon: Mdi.hospital,
        title: 'Santé',
        color: Colors.redAccent,
      ),
      CategorieModel(
        icon: Mdi.soccer,
        title: 'Sports',
        color: Colors.greenAccent,
      ),
      CategorieModel(
        icon: Mdi.car,
        title: 'Voyage',
        color: Colors.blue,
      ),
    ];
  }
}
