import 'package:bama/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerPage extends StatefulWidget {
  const MapPickerPage({super.key});

  @override
  _MapPickerPageState createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  LatLng? selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      backgroundColor: ColorApp.backgroundApp,
      appBar: AppBar(
        title: Text(
          "Sélectionner un lieu",
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
            color: Colors.grey[100],
          ),
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: const LatLng(12.6392, -7.9856), // par défaut Bamako
          zoom: 14,
        ),
        onTap: (LatLng position) {
          setState(() {
            selectedLocation = position;
          });
        },
        markers: selectedLocation != null
            ? {
                Marker(
                  markerId: MarkerId("selected"),
                  position: selectedLocation!,
                ),
              }
            : {},
      ),
      floatingActionButton: selectedLocation != null
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.pop(context, selectedLocation);
              },
              label: Text(
                "Choisir ce lieu",
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[100],
                ),
              ),
              icon: Icon(Icons.check, size: 24.sp),
            )
          : null,
    );
  }
}
