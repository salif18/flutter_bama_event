import 'package:bama/components/appbar.dart';
import 'package:bama/components/ticket_card.dart';
import 'package:bama/models/ticket_model.dart';
import 'package:bama/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TicketView extends StatefulWidget {
  const TicketView({super.key});

  @override
  State<TicketView> createState() => _TicketViewState();
}

class _TicketViewState extends State<TicketView> {
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
              BuildAppBar(title: "Tickets", bouttonAction: false),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((
                    BuildContext context,
                    index,
                  ) {
                    TicketModel item = TicketModel.generateFakeTickets()[index];
                    return TicketCard(ticket: item);
                  }, childCount: TicketModel.generateFakeTickets().length),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
