import 'package:bama/components/appbar.dart';
import 'package:bama/components/event_item_org.dart';
import 'package:bama/models/event_model.dart';
import 'package:bama/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventAdm extends StatelessWidget {
  const EventAdm({super.key});

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
              BuildAppBar(title: "Les évenements", bouttonAction: true),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
                sliver: SliverGrid(
                  gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 1,
                            childAspectRatio: 0.65,
                          ),
                      delegate: SliverChildBuilderDelegate((
                        BuildContext context,
                        int index,
                      ) {
                    Event item = Event.getFakeEvents()[index];
                    return EventItemOrg(item: item);
                  }, childCount:Event.getFakeEvents().length ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}