import 'package:bama/components/event_item.dart';
import 'package:bama/models/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildEvenList extends StatelessWidget {
   BuildEvenList({super.key});

  //final List<Event> _data = Event.getFakeEvents();
  Future<List<Event>> fetchEvents() async {
  try {
    final snapshot = await FirebaseFirestore.instance.collection('events').get();
    return snapshot.docs.map((doc) {
      print('Document ID: ${doc.id}');
      print('Data: ${doc.data()}');
      return Event.fromMap(doc.data(), doc.id);
    }).toList();
  } catch (e) {
    print('Erreur fetchEvents: $e');
    rethrow;
  }
}


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Event>>(
      future: fetchEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverFillRemaining(
            child: Center(child: CircularProgressIndicator(color: Colors.orange.shade700,)),
          );
        }

        if (snapshot.hasError) {
          return SliverFillRemaining(
            child: Center(child: Text('Erreur de chargement',style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.white),)),
          );
        }

        final events = snapshot.data ?? [];

        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final item = events[index];
                return EventItem(item: item);
              },
              childCount: events.length,
            ),
          ),
        );
      },
    );
  }
}
