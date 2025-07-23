import 'package:bama/models/event_model.dart';
import 'package:bama/screens/detail/detail.dart';
import 'package:bama/utils/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:google_fonts/google_fonts.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({super.key});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int currentIndex = 0;

  // final List<Event> _data = Event.getFakeEvents();
  List<Event> _data = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      final events = await fetchTopEvents();
      setState(() {
        _data = events;
        _isLoading = false;
      });
    } catch (e) {
      print("Erreur de chargement des événements : $e");
      setState(() => _isLoading = false);
    }
  }

  Future<List<Event>> fetchTopEvents() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('events')
      .orderBy('date') // ou un autre critère de tri pertinent
      .limit(4)
      .get();

  return snapshot.docs.map((doc) {
    return Event.fromMap(doc.data(), doc.id);
  }).toList();
}

  @override
  Widget build(BuildContext context) {

     if (_isLoading) {
      return SliverFillRemaining(
        child: Center(child: CircularProgressIndicator(color: Colors.orange.shade700,)),
      );
    }

    if (_data.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(child: Text("Aucun événement disponible.",style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.white),)),
      );
    }
    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 8.r),
      sliver: SliverToBoxAdapter(
        child: Stack(
          children: [
            CarouselSlider(
              items: _data.map((event) {
                return InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailView(item: event)),
                  ),
                  child: AspectRatio(
                    aspectRatio: 2 / 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.network(
                        event.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            "assets/images/image_default.png",
                            fit: BoxFit.cover,
                          );
                        },
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
                  setState(() => currentIndex = index);
                },
              ),
            ),
            Positioned(
              bottom: 8.h,
              left: 100.r,
              right: 100.r,
              child: DotsIndicator(
                dotsCount: _data.length,
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
