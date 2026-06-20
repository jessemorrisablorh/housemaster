import 'dart:typed_data';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:base32/base32.dart';
import 'dart:math';

import 'package:qr_flutter/qr_flutter.dart';

class TwoFactorAuthenticationPage extends StatefulWidget {
  const TwoFactorAuthenticationPage({super.key});

  @override
  State<TwoFactorAuthenticationPage> createState() =>
      _TwoFactorAuthenticationPageState();
}

class _TwoFactorAuthenticationPageState
    extends State<TwoFactorAuthenticationPage> {
  String? secret;
  bool loading = false;
  String generateSecret() {
    final random = Random.secure();
    final bytes = List<int>.generate(20, (_) => random.nextInt(256));
    return base32.encode(Uint8List.fromList(bytes));
  }

  Future<void> enable2FA() async {
    setState(() => loading = true);

    final user = FirebaseAuth.instance.currentUser!;
    final newSecret = generateSecret();

    await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
      "secrete": newSecret,
      "authentication": true,
    });

    setState(() {
      secret = newSecret;
      loading = false;
    });
  }

  Future<void> disable2FA() async {
    setState(() {
      loading = true;
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({"authentication": false, "secrete": ""})
        .then((value) {
          setState(() {
            loading = false;
          });
          Get.close(1);
        });
  }

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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FadeInUp(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 80.0),
                      child: Image.asset(
                        "images/authentication.png",
                        color: Colors.amber,
                        height: 0.20 * height,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  FadeInUp(
                    child: Text(
                      "Two-Factor Authentication",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  FadeInUp(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Text(
                        "Two-Factor Authentication (2FA) adds an extra layer of security to your account by requiring two forms of verification — usually your password and a one-time code sent to your phone or email. Even if someone knows your password, they can’t access your account without the second verification step.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color:
                              Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .snapshots(),
                    builder: (context, asyncSnapshot) {
                      if (!asyncSnapshot.hasData) {
                        return SizedBox();
                      }
                      return FadeInUp(
                        child: InkWell(
                          onTap: () async {
                            if (asyncSnapshot.data?["authentication"] ==
                                false) {
                              await enable2FA();
                              Get.dialog(
                                Dialog(
                                  child: Container(
                                    height: 0.47 * height,
                                    width: width,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[900],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20.0,
                                            right: 20.0,
                                          ),
                                          child: Text(
                                            "Scan this QR code in Google Authenticator",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        QrImageView(
                                          data:
                                              "otpauth://totp/YourApp:${FirebaseAuth.instance.currentUser?.email}?secret=$secret&issuer=House master App",
                                          size: 200,
                                          // ignore: deprecated_member_use
                                          foregroundColor: Colors.white,
                                        ),
                                        const SizedBox(height: 20),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20.0,
                                            right: 20.0,
                                          ),
                                          child: SelectableText(
                                            "$secret",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              Get.dialog(
                                Dialog(
                                  child: Container(
                                    height: 0.65 * height,
                                    width: width,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[900],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20.0,
                                            right: 20.0,
                                          ),
                                          child: Text(
                                            "Disable Two-Factor Authentication",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Image.asset(
                                          "images/authentication.png",
                                          color: Colors.amber,
                                          height: 0.20 * height,
                                        ),
                                        const SizedBox(height: 20),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20.0,
                                            right: 20.0,
                                          ),
                                          child: SelectableText(
                                            "Disabling Two-Factor Authentication will reduce your account security. Without 2FA, anyone who gets your password can access your account. We strongly recommend keeping 2FA enabled to protect your personal data and prevent unauthorized access",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        InkWell(
                                          onTap: () async {
                                            await disable2FA();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Container(
                                              width: width,
                                              height: 0.060 * height,
                                              decoration: BoxDecoration(
                                                color: Colors.amber,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Disable Two-Factor Authentication (2FA)",
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
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                              top: 40.0,
                            ),
                            child: Container(
                              height: 0.060 * height,
                              width: width,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black26
                                        : Colors.black,
                                    blurRadius: 7,
                                    offset: Offset(1, 2),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                asyncSnapshot.data?["authentication"] == false
                                    ? "Enable Two-Factor Authentication (2FA)"
                                    : "Disable Two-Factor Authentication (2FA)",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
