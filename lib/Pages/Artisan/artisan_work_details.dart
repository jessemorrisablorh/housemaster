import 'dart:io';

import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemasterapp/theme_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ArtisanWorkDetails extends StatefulWidget {
  final String id;
  final String image;
  final int daycreated;
  final int monthcreated;
  final int yearcreated;
  const ArtisanWorkDetails({
    super.key,
    required this.id,
    required this.image,
    required this.daycreated,
    required this.monthcreated,
    required this.yearcreated,
  });

  @override
  State<ArtisanWorkDetails> createState() => _ArtisanWorkDetailsState();
}

class _ArtisanWorkDetailsState extends State<ArtisanWorkDetails> {
  final ThemeController controller = Get.find();
  bool deleting = false;
  String state = "read";
  User? user = FirebaseAuth.instance.currentUser;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;
  String? imageUrl;
  bool loading = false;
  bool imageselected = false;
  File? imageFile;
  String? fileName;
  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (pickedFile == null) return;

    setState(() {
      imageselected = true;
      imageFile = File(pickedFile.path);
      fileName = const Uuid().v4();
    });
  }

  Future<void> uploadImageToFirebase() async {
    setState(() {
      isLoading = true;
      loading = true;
    });
    try {
      // Upload to Firebase Storage
      final ref = FirebaseStorage.instance.ref().child(
        'profile_images/$fileName.jpg',
      );

      await ref.putFile(imageFile!);

      // Get download URL
      String downloadUrl = await ref.getDownloadURL();

      // Save URL to Firestore
      await FirebaseFirestore.instance
          .collection("works")
          .doc(widget.id)
          .update({"image": downloadUrl})
          .then((value) {
            setState(() {
              loading = false;
            });
            Get.back();
          });
      setState(() {
        imageUrl = downloadUrl;
      });
    } catch (e) {
      debugPrint("Upload failed: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: state != "write",
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (state == "write") {
          setState(() {
            state = "read";
          });
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.grey[50]
            : Colors.grey[900],
        body: Column(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  top: 20.0,
                  right: 20.0,
                ),
                child: InkWell(
                  onTap: () {
                    if (state == "write") {
                      setState(() {
                        state = "read";
                      });
                    } else {
                      Get.back();
                    }
                  },
                  child: Row(
                    children: [
                      Container(
                        height: 0.060 * height,
                        width: 0.40 * width,
                        decoration: BoxDecoration(
                          color: Colors.amber.withAlpha(60),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            SlideInRight(
                              duration: Duration(milliseconds: 900),
                              child: Container(
                                height: 0.060 * height,
                                width: 0.14 * width,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.amber,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Icon(Icons.arrow_back),
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Text(
                              "Back",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    state == "read"
                        ? FadeInUp(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 30.0,
                              ),
                              child: Container(
                                height: 0.50 * height,
                                width: width,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AdvImageCache(widget.image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 80),
                              Container(
                                height: 0.27 * height,
                                width: 0.55 * width,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  image: DecorationImage(
                                    image: imageselected == false
                                        ? AssetImage("images/empty.jpg")
                                        : FileImage(imageFile!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (imageselected == true) {
                                    uploadImageToFirebase();
                                  } else {
                                    showModalBottomSheet(
                                      backgroundColor: Colors.black,
                                      context: context,
                                      builder: (_) => SafeArea(
                                        child: Wrap(
                                          children: [
                                            ListTile(
                                              leading: const Icon(
                                                Icons.camera_alt,
                                                color: Colors.amber,
                                              ),
                                              title: Text(
                                                "Take Photo",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);
                                                pickImage(ImageSource.camera);
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(
                                                Icons.photo_library,
                                                color: Colors.amber,
                                              ),
                                              title: Text(
                                                "Choose from Gallery",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);
                                                pickImage(ImageSource.gallery);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    30.0,
                                    40.0,
                                    30.0,
                                    20.0,
                                  ),
                                  child: Container(
                                    height: 0.055 * height,
                                    width: width,
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    alignment: Alignment.center,
                                    child: imageselected
                                        ? loading
                                              ? SizedBox(
                                                  height: 13,
                                                  width: 13,
                                                  child:
                                                      CircularProgressIndicator(
                                                        color: Colors.black,
                                                        strokeWidth: 3,
                                                      ),
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .cloud_upload_rounded,
                                                      color: Colors.black,
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      "Upload Image",
                                                      style:
                                                          GoogleFonts.poppins(
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                  ],
                                                )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add,
                                                color: Colors.black,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "Select image",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                              if (imageselected == true)
                                FadeIn(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            showModalBottomSheet(
                                              backgroundColor: Colors.black,
                                              context: context,
                                              builder: (_) => SafeArea(
                                                child: Wrap(
                                                  children: [
                                                    ListTile(
                                                      leading: const Icon(
                                                        Icons.camera_alt,
                                                        color: Colors.amber,
                                                      ),
                                                      title: Text(
                                                        "Take Photo",
                                                        style:
                                                            GoogleFonts.poppins(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        pickImage(
                                                          ImageSource.camera,
                                                        );
                                                      },
                                                    ),
                                                    ListTile(
                                                      leading: const Icon(
                                                        Icons.photo_library,
                                                        color: Colors.amber,
                                                      ),
                                                      title: Text(
                                                        "Choose from Gallery",
                                                        style:
                                                            GoogleFonts.poppins(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        pickImage(
                                                          ImageSource.gallery,
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: 0.065 * height,
                                            width: 0.18 * width,
                                            decoration: BoxDecoration(
                                              color: Colors.amber.withAlpha(90),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.refresh_outlined,
                                              color: Colors.amber,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        InkWell(
                                          onTap: () {
                                            Get.back();
                                          },
                                          child: Container(
                                            height: 0.0650 * height,
                                            width: 0.18 * width,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                    if (state == "read")
                      FadeInUp(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20.0,
                            top: 20.0,
                          ),
                          child: Row(
                            children: [
                              Text(
                                "${widget.daycreated} - ${widget.monthcreated} - ${widget.yearcreated}",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Visibility(
          visible: state == "read",
          child: SafeArea(
            child: FadeInUp(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
                  height: 0.060 * height,
                  decoration: BoxDecoration(color: Colors.amber),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              state = "write";
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit, color: Colors.black, size: 20),
                              SizedBox(width: 10),
                              Text(
                                "Edit",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 0.030 * height,
                        width: 2,
                        color: Colors.grey[900],
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.dialog(
                              StatefulBuilder(
                                builder: (context, setState) {
                                  return Dialog(
                                    backgroundColor: Colors.grey[900],
                                    child: Container(
                                      width: width,
                                      height: 0.40 * height,
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 30),
                                          Container(
                                            height: 0.11 * height,
                                            width: 0.25 * width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.amber.withAlpha(
                                                100,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.delete_forever_outlined,
                                              color: Colors.amber,
                                              size: 45,
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Text(
                                            "Deleting selected work image",
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          Text(
                                            "Do you want to proceed?",
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          InkWell(
                                            onTap: () async {
                                              await deleteWork();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 20.0,
                                                right: 20.0,
                                              ),
                                              child: Container(
                                                height: 0.055 * height,
                                                width: width,
                                                decoration: BoxDecoration(
                                                  color: Colors.amber,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                alignment: Alignment.center,
                                                child: deleting
                                                    ? SizedBox(
                                                        height: 13,
                                                        width: 13,
                                                        child:
                                                            CircularProgressIndicator(
                                                              color:
                                                                  Colors.black,
                                                              strokeWidth: 3,
                                                            ),
                                                      )
                                                    : Text(
                                                        "Delete work image",
                                                        style:
                                                            GoogleFonts.poppins(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 30),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete, color: Colors.red, size: 20),
                              SizedBox(width: 10),
                              Text(
                                "Delete",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> deleteWork() async {
    setState(() {
      deleting = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection("works")
          .doc(widget.id)
          .delete()
          .then((value) {
            setState(() {
              deleting = false;
            });
            Get.close(1);
            Get.back();
          });
    } catch (e) {
      setState(() {
        deleting = false;
      });
      Get.snackbar(
        "",
        "",
        backgroundColor: Colors.red,
        titleText: Text(
          "Error!",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        messageText: Text(
          "Try again later",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }
}
