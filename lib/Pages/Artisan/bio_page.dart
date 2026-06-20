import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemasterapp/theme_controller.dart';

class BioPage extends StatefulWidget {
  const BioPage({super.key});

  @override
  State<BioPage> createState() => _BioPageState();
}

class _BioPageState extends State<BioPage> {
  final ThemeController controller = Get.find();
  User? user = FirebaseAuth.instance.currentUser;
  bool loading = false;
  String state = "read";
  bool empty = false;
  TextEditingController bio = TextEditingController();
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
                    state == "read"
                        ? StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .doc(user?.uid)
                                .snapshots(),
                            builder: (context, asyncsnapshot) {
                              if (!asyncsnapshot.hasData) {
                                return Text("...");
                              }
                              return FadeInUp(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 50.0,
                                  ),
                                  child: Container(
                                    height: 0.30 * height,
                                    width: width,
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.grey[200]
                                          : Colors.black,
                                      border: Border.all(
                                        color: Colors.amber.withAlpha(90),
                                        width: 4,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: SingleChildScrollView(
                                        child: Text(
                                          asyncsnapshot.data?["bio"],
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
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : FadeInUp(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 50.0,
                              ),
                              child: Container(
                                height: 0.30 * height,
                                width: width,
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.grey[200]
                                      : Colors.black,
                                  border: Border.all(
                                    color: Colors.amber.withAlpha(90),
                                    width: 4,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: TextField(
                                    onTap: () {
                                      setState(() {
                                        empty = false;
                                      });
                                    },
                                    controller: bio,
                                    maxLines: 30,
                                    style: GoogleFonts.poppins(
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    cursorColor: Colors.white,
                                    cursorHeight: 13,
                                    decoration: InputDecoration(
                                      hintText: "Enter new bio",
                                      hintStyle: GoogleFonts.poppins(
                                        color:
                                            Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    if (empty == true)
                      FadeIn(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20.0,
                            top: 20.0,
                          ),
                          child: Container(
                            height: 0.060 * height,
                            width: width,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Bio can't be empty",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 10.0,
              left: 20.0,
              right: 20.0,
            ),
            child: state == "read"
                ? FadeInUp(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          state = "write";
                        });
                      },
                      child: Container(
                        height: 0.060 * height,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Edit bio",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : FadeInUp(
                    child: InkWell(
                      onTap: () async {
                        if (bio.text.isEmpty) {
                          setState(() {
                            empty = true;
                          });
                        } else {
                          await updateBio();
                        }
                      },
                      child: Container(
                        height: 0.060 * height,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: loading
                            ? SizedBox(
                                height: 13,
                                width: 13,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                  strokeWidth: 3,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Save new bio",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
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

  Future<void> updateBio() async {
    setState(() {
      loading = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user?.uid)
          .update({"bio": bio.text.trim()})
          .then((value) {
            setState(() {
              loading = false;
              state = "read";
            });
          });
    } catch (e) {
      setState(() {
        loading = false;
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
