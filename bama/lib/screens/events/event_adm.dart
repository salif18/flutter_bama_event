import 'package:bama/components/appbar.dart';
import 'package:bama/components/event_item_org.dart';
import 'package:bama/models/event_model.dart';
import 'package:bama/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class EventAdm extends StatelessWidget {
  const EventAdm({super.key});

  Future<List<Event>> fetchEvents() async {
    final snapshot = await FirebaseFirestore.instance.collection('events').get();
    return snapshot.docs.map((doc) => Event.fromMap(doc.data(), doc.id)).toList();
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.backgroundApp,
      body: SafeArea(
        child: FutureBuilder<List<Event>>(
          future: fetchEvents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur : ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Aucun événement trouvé',style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),));
            }

            final events = snapshot.data!;

            return CustomScrollView(
              slivers: [
                BuildAppBar(title: "Les évenements", bouttonAction: true),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 4.r),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 1,
                      childAspectRatio: 0.62,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final event = events[index];
                        return EventItemOrg(item: event);
                      },
                      childCount: events.length,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}