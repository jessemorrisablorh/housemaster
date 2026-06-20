import 'dart:io';

import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ArtisanChangeImagePage extends StatefulWidget {
  const ArtisanChangeImagePage({super.key});

  @override
  State<ArtisanChangeImagePage> createState() => _ArtisanChangeImagePageState();
}

class _ArtisanChangeImagePageState extends State<ArtisanChangeImagePage> {
  User? user = FirebaseAuth.instance.currentUser;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;
  String? imageUrl;
  bool loading = false;
  bool imageselected = false;
  File? imageFile;
  String? fileName;
  String state = "read";
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
          .collection("users")
          .doc(user?.uid)
          .update({"image": downloadUrl})
          .then((value) {
            setState(() {
              loading = false;
              state = "read";
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
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.black
                                    : Colors.white,
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
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(user?.uid)
                          .snapshots(),
                      builder: (context, asyncsnapshot) {
                        if (!asyncsnapshot.hasData) {
                          return Text("...");
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (state == "read")
                              Padding(
                                padding: const EdgeInsets.only(top: 70.0),
                                child: Container(
                                  height: 0.33 * height,
                                  width: 0.70 * width,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.black26
                                            : Colors.black,
                                      ),
                                    ],
                                    image: DecorationImage(
                                      image: asyncsnapshot.data?["image"] == ""
                                          ? AssetImage("images/empty.jpg")
                                          : AdvImageCache(
                                              asyncsnapshot.data?["image"],
                                            ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            if (state == "write")
                              Padding(
                                padding: const EdgeInsets.only(top: 70.0),
                                child: Container(
                                  height: 0.33 * height,
                                  width: 0.70 * width,
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
                              ),
                            if (state == "write")
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
                                    50.0,
                                    30.0,
                                    20.0,
                                  ),
                                  child: Container(
                                    height: 0.060 * height,
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
                            if (imageselected == true && state == "write")
                              FadeIn(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 20.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                                            color: Colors.white,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w600,
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
                                                            color: Colors.white,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w600,
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
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
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
                                          setState(() {
                                            state = "read";
                                          });
                                        },
                                        child: Container(
                                          height: 0.0650 * height,
                                          width: 0.18 * width,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
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
                        );
                      },
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
              child: InkWell(
                onTap: () {
                  setState(() {
                    state = "write";
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    bottom: 10.0,
                  ),
                  child: Container(
                    height: 0.065 * height,
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Theme.of(context).brightness == Brightness.light
                              ? Colors.black26
                              : Colors.black,
                          blurRadius: 7,
                          offset: Offset(1, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.edit, color: Colors.black, size: 20),
                        SizedBox(width: 10),
                        Text(
                          "Edit image",
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
            ),
          ),
        ),
      ),
    );
  }
}
