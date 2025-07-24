import 'package:bama/components/appbar.dart';
import 'package:bama/components/event_item.dart';
import 'package:bama/models/event_model.dart';
import 'package:bama/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Category extends StatelessWidget {
  final String categorie;
  const Category({super.key, required this.categorie});
  Future<List<Event>> fetchEventsByCategory() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('categorie', isEqualTo: categorie)
        .get();

    return snapshot.docs
        .map((doc) => Event.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorApp.backgroundApp,
      body: SafeArea(
        child: Container(
          color: ColorApp.backgroundApp,
          child: CustomScrollView(
            slivers: [
              BuildAppBar(title: categorie, bouttonAction: true),

              /// Sliver to show grid of events
              FutureBuilder<List<Event>>(
                future: fetchEventsByCategory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: Colors.orange.shade700,)));
                  } else if (snapshot.hasError) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Text("Erreur lors du chargement.",style:GoogleFonts.poppins(fontSize: 14.sp, color: Colors.white)),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Text("Aucun événement trouvé.",style:GoogleFonts.poppins(fontSize: 14.sp, color: Colors.white)),
                      ),
                    );
                  }
              
                  final events = snapshot.data!;
              
                  return SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.r,
                      vertical: 8.r,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((
                        BuildContext context,
                        int index,
                      ) {
                        final item = events[index];
                        return EventItem(item: item);
                      }, childCount: events.length),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
