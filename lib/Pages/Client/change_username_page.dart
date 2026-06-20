import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangeUsernamePage extends StatefulWidget {
  const ChangeUsernamePage({super.key});

  @override
  State<ChangeUsernamePage> createState() => _ChangeUsernamePageState();
}

class _ChangeUsernamePageState extends State<ChangeUsernamePage> {
  User? user = FirebaseAuth.instance.currentUser;
  bool loading = false;
  TextEditingController name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
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
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    FadeInUp(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Text(
                              "Username",
                              style: GoogleFonts.poppins(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(user?.uid)
                          .snapshots(),
                      builder: (context, asyncSnapshot) {
                        if (!asyncSnapshot.hasData) {
                          return FadeInUp(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 30.0),
                                  child: Text(
                                    "...",
                                    style: GoogleFonts.poppins(
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return FadeInUp(
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child: Text(
                                  asyncSnapshot.data?["name"],
                                  style: GoogleFonts.poppins(
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: FadeInUp(
          child: InkWell(
            onTap: () {
              Get.dialog(
                StatefulBuilder(
                  builder: (context, setState) {
                    return Dialog(
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.light
                          ? Colors.white
                          : Colors.grey[900],
                      child: Container(
                        width: width,
                        height: 0.40 * height,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 30),
                            Container(
                              height: 0.11 * height,
                              width: 0.25 * width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.amber
                                    : Colors.amber.withAlpha(100),
                              ),
                              child: Icon(
                                Icons.edit,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.black
                                    : Colors.amber,
                                size: 45,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Change username",
                              style: GoogleFonts.poppins(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
                              ),
                              child: Container(
                                height: 0.060 * height,
                                width: width,
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.grey[300]
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                  ),
                                  child: TextField(
                                    controller: name,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    cursorColor: Colors.black,
                                    cursorErrorColor: Colors.black,
                                    cursorHeight: 13,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Username",
                                      hintStyle: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 20),
                            InkWell(
                              onTap: () async {
                                if (name.text != "") {
                                  if (loading == false) {
                                    setState(() {
                                      loading = true;
                                    });
                                  }
                                  await updateUsername();
                                } else {}
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
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  alignment: Alignment.center,
                                  child: loading
                                      ? SizedBox(
                                          height: 13,
                                          width: 13,
                                          child: CircularProgressIndicator(
                                            color: Colors.black,
                                            strokeWidth: 3,
                                          ),
                                        )
                                      : Text(
                                          "Save new username",
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
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
                      color: Theme.of(context).brightness == Brightness.light
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
                      "Edit username",
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
    );
  }

  Future<void> updateUsername() async {
    setState(() {
      loading = true;
    });
    try {
      FirebaseFirestore.instance
          .collection("users")
          .doc(user?.uid)
          .update({"name": name.text.trim()})
          .then((value) {
            setState(() {
              loading = false;
            });
            Get.close(1);
          });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }
}
