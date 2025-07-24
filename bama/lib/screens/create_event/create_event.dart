import 'dart:io';

import 'package:bama/components/appbar.dart';
import 'package:bama/maps/maps.dart';
import 'package:bama/models/categorie_model.dart';
import 'package:bama/screens/myevent/my_event.dart';
import 'package:bama/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class FormEvent extends StatefulWidget {
  const FormEvent({super.key});

  @override
  State<FormEvent> createState() => _FormEventState();
}

class _FormEventState extends State<FormEvent> {
  final _formKey = GlobalKey<FormState>();
  List<CategorieModel> categoriList = CategorieModel.getCategorie();
  // Contrôleurs
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();
  final TextEditingController dateCtrl = TextEditingController();
  final TextEditingController horaireCtrl = TextEditingController();
  final TextEditingController locationCtrl = TextEditingController();
  final TextEditingController imageUrlCtrl = TextEditingController();
  final TextEditingController latCtrl = TextEditingController();
  final TextEditingController longCtrl = TextEditingController();
  String? selectedCategory;
  DateTime? pickedDate; // ✅ variable pour stocker la vraie date

  // Ticket types
  List<Map<String, TextEditingController>> ticketTypeControllers = [];

  final ImagePicker _picker = ImagePicker();
  XFile? galleryImage; // Changé pour stocker une seule image (peut être null)

  // ✅ Sélectionner une seule image depuis la galerie
  Future<void> _selectSingleImageFromGallery(BuildContext context) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800, // Optionnel: réduire la taille
        maxHeight: 1800, // Optionnel: réduire la taille
        imageQuality: 88, // Optionnel: qualité entre 0 et 100
      );

      if (pickedFile != null) {
        setState(() {
          galleryImage =
              pickedFile; // Stocke seulement la dernière image sélectionnée
        });
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur: ${e.toString()}")));
    }
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    descriptionCtrl.dispose();
    dateCtrl.dispose();
    horaireCtrl.dispose();
    locationCtrl.dispose();
    imageUrlCtrl.dispose();
    latCtrl.dispose();
    longCtrl.dispose();
    for (var map in ticketTypeControllers) {
      for (var c in map.values) {
        c.dispose();
      }
    }
    super.dispose();
  }

  void addTicketType() {
    setState(() {
      ticketTypeControllers.add({
        'type': TextEditingController(),
        'price': TextEditingController(),
        'available': TextEditingController(),
      });
    });
  }

  void removeTicketType(int index) {
    setState(() {
      ticketTypeControllers.removeAt(index);
    });
  }

  // vers firebase
  Future<String> uploadSingleImageToFirebase(XFile image) async {
    final FirebaseStorage storage = FirebaseStorage.instance;

    File file = File(image.path);

    // Référence unique pour l’image
    final Reference ref = storage.ref().child(
      'images/${DateTime.now().millisecondsSinceEpoch}_${image.name}',
    );

    final UploadTask uploadTask = ref.putFile(file);
    await uploadTask;

    final String downloadUrl = await ref.getDownloadURL();
    return downloadUrl; // ✅ retourne une seule URL
  }

  // vers cloudinary
  Future<String?> uploadSingleImageToCloudinary(XFile image) async {
    const cloudName = 'dm4qhqazr'; // ← Ton Cloudinary cloud name
    const uploadPreset = 'bama_event'; // ← Ton preset signé

    final dio = Dio();

    final file = await MultipartFile.fromFile(image.path, filename: image.name);

    final formData = FormData.fromMap({
      'file': file,
      'upload_preset': uploadPreset,
    });

    try {
      final response = await dio.post(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data['secure_url']; // ✅ retourne une seule URL
      } else {
        print('Erreur Cloudinary (${response.statusCode}): ${response.data}');
        return null;
      }
    } catch (e) {
      print('Erreur lors de l\'upload : $e');
      return null;
    }
  }

  void submit() async {
    final user = FirebaseAuth.instance.currentUser;
    if (_formKey.currentState!.validate()) {
      final imageUrl = await uploadSingleImageToCloudinary(galleryImage!);
      // final imageUrl = await uploadSingleImageToFirebase(galleryImage!);

      final eventData = {
        'organiserId': user!.uid,
        'title': titleCtrl.text,
        'categorie': selectedCategory,
        'description': descriptionCtrl.text,
        'date': pickedDate != null
            ? Timestamp.fromDate(pickedDate!)
            : null, // ✅ vrai format Timestamp
        'horaire': horaireCtrl.text,
        'location': locationCtrl.text,
        'lat': double.tryParse(latCtrl.text) ?? 0,
        'long': double.tryParse(longCtrl.text) ?? 0,
        'imageUrl': imageUrl,
        'ticketTypes': ticketTypeControllers.map((map) {
          return {
            'type': map['type']!.text,
            'price': int.tryParse(map['price']!.text) ?? 0,
            'available': int.tryParse(map['available']!.text) ?? 0,
            'sold': 0,
          };
        }).toList(),
      };

      final docRef = FirebaseFirestore.instance
          .collection('events')
          .doc(); // Génère un ID
      await docRef.set(eventData);

      // addEvent(eventData);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Événement enregistré avec succè.")),
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyEvent()),
      );
    }
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
              BuildAppBar(title: "Créer un évenemet", bouttonAction: true),
              _buildFormulaire(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormulaire(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
      sliver: SliverToBoxAdapter(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (galleryImage == null)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.r,
                    vertical: 8.r,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          SizedBox(height: 10.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 16.0.r,
                              horizontal: 16.r,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.photo_library_outlined,
                                size: 28.sp,
                              ),
                              onPressed: () {
                                _selectSingleImageFromGallery(context);
                              },
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            "Ajouter l'affice",
                            style: GoogleFonts.roboto(
                              fontSize: 12.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              if (galleryImage != null)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0.r),
                  child: SizedBox(
                    width: double.infinity,
                    height: 200.h,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.0.r,
                        horizontal: 8.r,
                      ),
                      child: Image.file(
                        File(galleryImage!.path),
                        width: 100.w,
                        height: 100.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

              TextFormField(
                controller: titleCtrl,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[100],
                ),
                decoration: InputDecoration(
                  labelText: "Titre",
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[100],
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
              ),
              GestureDetector(
                onTap: () {
                  _buildAlertCategorieDialog(context);
                },
                child: Container(
                  height: 45.h,
                  decoration: BoxDecoration(
                    color: ColorApp.backgroundApp,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[700]!),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedCategory ?? "Catégorie",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[100],
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down_outlined,
                        size: 24.sp,
                        color: Colors.grey[100],
                      ),
                    ],
                  ),
                ),
              ),

              TextFormField(
                controller: descriptionCtrl,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[100],
                ),
                decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[100],
                  ),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
              InkWell(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      pickedDate = picked; // ✅ stocker la vraie DateTime
                      dateCtrl.text = DateFormat(
                        'yyyy-MM-dd',
                      ).format(picked); // pour l'affichage
                    });
                  }
                },
                child: IgnorePointer(
                  child: TextFormField(
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[100],
                    ),
                    controller: dateCtrl,
                    decoration: InputDecoration(
                      labelText: "Date de l'événement",
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[100],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Pour l'heure :
              InkWell(
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    final now = DateTime.now();
                    final dt = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      picked.hour,
                      picked.minute,
                    );
                    String formatted = DateFormat('HH:mm').format(dt);
                    setState(() {
                      horaireCtrl.text = formatted;
                    });
                  }
                },
                child: IgnorePointer(
                  child: TextFormField(
                    controller: horaireCtrl,
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[100],
                    ),
                    decoration: InputDecoration(
                      labelText: "Heure de l'événement",
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[100],
                      ),
                    ),
                  ),
                ),
              ),
              TextFormField(
                controller: locationCtrl,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[100],
                ),
                decoration: InputDecoration(
                  labelText: "Lieu",
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[100],
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer le lieu';
                  }
                  return null;
                },
              ),
              InkWell(
                onTap: () async {
                  LatLng? selected = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapPickerPage()),
                  );
                  if (selected != null) {
                    setState(() {
                      latCtrl.text = selected.latitude.toString();
                      longCtrl.text = selected.longitude.toString();
                    });
                  }
                },
                child: IgnorePointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Sélectionner le lieu sur la carte",
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[100],
                      ),
                    ),
                    controller: latCtrl,
                  ),
                ),
              ),

              SizedBox(height: 20.h),
              const Divider(),
              Text(
                "Types de tickets",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 10.h),
              ...ticketTypeControllers.asMap().entries.map((entry) {
                final index = entry.key;
                final controllers = entry.value;
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.r),
                  color: ColorApp.backgroundCard,
                  child: Padding(
                    padding: EdgeInsets.all(8.r),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: controllers['type'],
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[100],
                          ),
                          decoration: InputDecoration(
                            labelText: 'Type',
                            labelStyle: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[100],
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: controllers['price'],
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[100],
                          ),
                          decoration: InputDecoration(
                            labelText: 'Prix',
                            labelStyle: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[100],
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        TextFormField(
                          controller: controllers['available'],
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[100],
                          ),
                          decoration: InputDecoration(
                            labelText: 'Disponible',
                            labelStyle: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[100],
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () => removeTicketType(index),
                            icon: Icon(
                              Icons.delete,
                              size: 20.sp,
                              color: Colors.purpleAccent,
                            ),
                            label: Text(
                              "Supprimer",
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[100],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorApp.titleColor,
                ),
                onPressed: addTicketType,
                icon: Icon(Icons.add, size: 20.sp, color: Colors.white),
                label: Text(
                  "Ajouter un ticket",
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[100],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorApp.backgroundCard,
                ),
                onPressed: submit,
                child: Text(
                  "Enregistrer",
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[100],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildAlertCategorieDialog(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(
              context,
            ).viewInsets.bottom, // ajuste selon le clavier
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
            height: 450.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorApp.backgroundCard,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                topRight: Radius.circular(10.r),
              ),
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: ColorApp.backgroundApp,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.r,
                    vertical: 16.r,
                  ),
                  child: Text(
                    "Séléctionner une catégorie",
                    style: GoogleFonts.roboto(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: categoriList.map((item) {
                        return TextButton.icon(
                          onPressed: () {
                            setState(() {
                              selectedCategory = item.title;
                            });
                            Navigator.pop(context);
                          },
                          label: Text(
                            item.title.toString(),
                            style: GoogleFonts.roboto(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          icon: Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(100.r),
                            ),
                            child: Icon(
                              item.icon,
                              size: 20.sp,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
