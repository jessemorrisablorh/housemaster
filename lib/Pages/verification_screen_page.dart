import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemasterapp/Pages/Artisan/artisan_home_page.dart';
import 'package:housemasterapp/Pages/Client/client_home_page.dart';
import 'package:housemasterapp/Pages/welcome_page.dart';
import 'package:otp/otp.dart';

class VerificationScreenPage extends StatefulWidget {
  const VerificationScreenPage({super.key});

  @override
  State<VerificationScreenPage> createState() => _VerificationScreenPageState();
}

class _VerificationScreenPageState extends State<VerificationScreenPage> {
  TextEditingController otpController = TextEditingController();
  bool loading = false;

  bool verifyCode(String secret, String code) {
    final currentCode = OTP.generateTOTPCodeString(
      secret,
      DateTime.now().millisecondsSinceEpoch,
      interval: 30,
      length: 6,
      algorithm: Algorithm.SHA1,
      isGoogle: true,
    );

    return currentCode == code;
  }

  Future<void> verifyOtp() async {
    setState(() => loading = true);

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();

    final secret = doc.data()?['secrete'];

    if (verifyCode(secret, otpController.text.trim())) {
      if (doc["role"] == "client") {
        Get.offAll(() => ClientHomePage());
      } else if (doc["role"] == "artisan") {
        Get.offAll(() => ArtisanHomePage());
      }
    } else {
      Get.snackbar(
        "",
        "",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,

        titleText: Text(
          "Error!",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        messageText: Text(
          "Invalid code",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: SingleChildScrollView(
          child: FadeInUp(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 80.0,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Enter 6-digit code from Authenticator",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 20.0,
                  ),
                  child: Container(
                    height: 0.060 * height,
                    width: width,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: TextField(
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        cursorColor: Colors.black,
                        cursorErrorColor: Colors.black,
                        cursorHeight: 13,
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterStyle: TextStyle(fontSize: 0.01),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 0.0,
                  ),
                  child: InkWell(
                    onTap: () async {
                      await verifyOtp();
                    },
                    child: Container(
                      height: 0.065 * height,
                      width: width,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10),
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
                              "Verify",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 15.0,
                  ),
                  child: Row(
                    children: [
                      InkWell(
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
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            color: Colors.amber.withAlpha(100),
                                          ),
                                          child: Icon(
                                            Icons.exit_to_app_outlined,
                                            color: Colors.amber,
                                            size: 45,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          "You are about signing out, do you want to proceed",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),

                                        InkWell(
                                          onTap: () async {
                                            if (loading == false) {
                                              setState(() {
                                                loading = true;
                                              });
                                            }
                                            try {
                                              await FirebaseAuth.instance
                                                  .signOut()
                                                  .then((value) {
                                                    Get.offAll(
                                                      () => WelcomePage(),
                                                    );
                                                  });
                                            } catch (e) {
                                              setState(() {
                                                loading = false;
                                              });
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 20.0,
                                              right: 20.0,
                                              top: 20.0,
                                              bottom: 30.0,
                                            ),
                                            child: Container(
                                              height: 0.060 * height,
                                              width: width,
                                              decoration: BoxDecoration(
                                                color: Colors.amber,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Proceed",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
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
                                );
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Sign out",
                          style: GoogleFonts.poppins(
                            color: Colors.amber,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
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
    );
  }
}
