import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddNewWorkPage extends StatefulWidget {
  const AddNewWorkPage({super.key});

  @override
  State<AddNewWorkPage> createState() => _AddNewWorkPageState();
}

class _AddNewWorkPageState extends State<AddNewWorkPage> {
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
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("works")
          .doc();
      await documentReference
          .set({
            "id": documentReference.id,
            "image": downloadUrl,
            "uid": user?.uid,
            "datecreated": DateTime.now(),
            "daycreated": DateTime.now().day,
            "monthcreated": DateTime.now().month,
            "yearcreated": DateTime.now().year,
          }, SetOptions(merge: true))
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
    return Scaffold(
      backgroundColor: Colors.grey[900],
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
                  Get.back();
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
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                                        child: CircularProgressIndicator(
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
                                            Icons.cloud_upload_rounded,
                                            color: Colors.black,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "Upload Image",
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add, color: Colors.black),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                },
                                child: Container(
                                  height: 0.065 * height,
                                  width: 0.18 * width,
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withAlpha(90),
                                    borderRadius: BorderRadius.circular(5),
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
                                    borderRadius: BorderRadius.circular(5),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
