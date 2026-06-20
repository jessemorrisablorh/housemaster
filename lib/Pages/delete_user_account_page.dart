import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemasterapp/Pages/welcome_page.dart';

class DeleteUserAccountPage extends StatefulWidget {
  const DeleteUserAccountPage({super.key});

  @override
  State<DeleteUserAccountPage> createState() => _DeleteUserAccountPageState();
}

class _DeleteUserAccountPageState extends State<DeleteUserAccountPage> {
  User? user = FirebaseAuth.instance.currentUser;
  bool loading = false;
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 80.0),
                    child: Container(
                      height: 0.11 * height,
                      width: 0.25 * width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.amber
                            : Colors.amber.withAlpha(100),
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
                      child: Icon(
                        Icons.warning_amber_outlined,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.amber,
                        size: 45,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Permanent action",
                    style: GoogleFonts.poppins(
                      color: Colors.red,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                    child: Text(
                      "This action will permanently delete your account and all personal data saved on the house master app",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
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
        child: FadeInUp(
          child: InkWell(
            onTap: () async {
              await deleteAccount();
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.delete, color: Colors.black, size: 20),
                          SizedBox(width: 10),
                          Text(
                            "Delete my account and data",
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

  Future<void> deleteAccount() async {
    setState(() {
      loading = true;
    });
    try {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("deleteaccount")
          .doc();
      documentReference
          .set({
            "uid": user?.uid,
            "datecreated": DateTime.now(),
            "daycreated": DateTime.now(),
            "monthcreated": DateTime.now(),
            "yearcreated": DateTime.now(),
          })
          .then((value) {
            FirebaseAuth.instance.signOut().then((value) {
              Get.offAll(() => WelcomePage());
            });
          });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }
}
