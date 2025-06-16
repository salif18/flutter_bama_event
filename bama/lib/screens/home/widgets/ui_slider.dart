import 'package:bama/models/event_model.dart';
import 'package:bama/screens/detail/detail.dart';
import 'package:bama/utils/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dots_indicator/dots_indicator.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({super.key});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int currentIndex = 0;

  final List<Event> _data = Event.getFakeEvents();
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 8.r),
      sliver: SliverToBoxAdapter(
        child: Stack(
          children: [
            CarouselSlider(
              items: _data.take(4).map((path) {
                return InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailView(item:path))),
                  child: AspectRatio(
                    aspectRatio: 2 / 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.network(
                        path.imageUrl, 
                        fit: BoxFit.cover,
                         errorBuilder: (context, error, stackTrace){
                 return Image.asset(
                    "assets/images/image_default.png",
                    fit: BoxFit.cover,
                  );
                }
                        ),
                    ),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                aspectRatio: 2,
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                viewportFraction: 0.9,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
            ),
            Positioned(
              bottom: 8.h,
              left: 100.r,
              right: 100.r,
              child: DotsIndicator(
                dotsCount: _data.take(5).length,
                position: currentIndex.toDouble(),
                decorator: DotsDecorator(
                  size: const Size(12.0, 12.0),
                  activeSize: const Size(40.0, 12.0),
                  color: Colors.grey[400]!,
                  activeColor: ColorApp.titleColor,
                  spacing: EdgeInsets.all(4.0.r),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
