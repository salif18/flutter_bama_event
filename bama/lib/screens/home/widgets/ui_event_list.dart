import 'package:bama/components/event_item.dart';
import 'package:bama/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildEvenList extends StatelessWidget {
   BuildEvenList({super.key});

  final List<Event> _data = Event.getFakeEvents();


  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, index) {
          final Event item = _data[index];
          return EventItem(item:item);
        }, childCount: _data.length),
      ),
    );
  }
}
