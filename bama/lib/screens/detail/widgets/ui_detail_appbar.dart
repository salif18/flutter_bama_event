import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventImageHeader extends SliverPersistentHeaderDelegate {
  final String imageUrl;
  final double minExtentHeight;
  final double maxExtentHeight;
  final VoidCallback onBack;

  EventImageHeader({
    required this.imageUrl,
    required this.minExtentHeight,
    required this.maxExtentHeight,
    required this.onBack,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              "assets/images/image_default.png",
              fit: BoxFit.cover,
            );
          },
        ),
        Container(
          // ignore: deprecated_member_use
          color: Colors.black.withOpacity(shrinkOffset / maxExtentHeight * 0.5),
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Align(
              alignment: Alignment.topLeft,
              child: CircleAvatar(
                // ignore: deprecated_member_use
                backgroundColor: Colors.black.withOpacity(0.4),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: onBack,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => maxExtentHeight;

  @override
  double get minExtent => minExtentHeight;

  @override
  bool shouldRebuild(EventImageHeader oldDelegate) {
    return imageUrl != oldDelegate.imageUrl;
  }
}
