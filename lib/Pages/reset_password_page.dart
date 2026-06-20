import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController email = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool loading = false;
  String emailtext = "Email";
  bool emailerror = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Form(
        key: formkey,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FadeInUp(
                  child: Container(
                    height: 0.15 * height,
                    width: 0.30 * width,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Image.asset("images/password.png"),
                    ),
                  ),
                ),
                FadeInUp(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 30.0,
                      right: 30.0,
                      top: 20.0,
                    ),
                    child: Text(
                      "Input your email below, a password reset link will be sent to the provided email.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                FadeInUp(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 30.0,
                      right: 30.0,
                      top: 20.0,
                    ),
                    child: Container(
                      height: 0.065 * height,
                      width: width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Row(
                          children: [
                            ImageIcon(AssetImage("images/email.png")),
                            SizedBox(width: 15.0),
                            Expanded(
                              child: TextFormField(
                                onTap: () {
                                  if (emailerror) {
                                    setState(() {
                                      email.clear();
                                      emailtext = "Email";
                                      emailerror = false;
                                    });
                                  }
                                },
                                controller: email,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                cursorHeight: 13,
                                cursorColor: Colors.black,
                                cursorErrorColor: Colors.black,
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(fontSize: 0.01),
                                  hintText: emailtext,
                                  hintStyle: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: emailerror
                                        ? Colors.red
                                        : Colors.black,
                                  ),
                                  border: InputBorder.none,
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    setState(() {
                                      email.clear();
                                      emailerror = true;
                                      emailtext = "Required";
                                    });
                                    return "Required";
                                  } else if (email.text.isEmail == false) {
                                    setState(() {
                                      email.clear();
                                      emailerror = true;
                                      emailtext = "Invalid email";
                                    });
                                    return "Invalid email";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                FadeInUp(
                  child: InkWell(
                    onTap: () {
                      if (formkey.currentState!.validate()) {
                        resetPassWord();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 40.0,
                        right: 40.0,
                        top: 20.0,
                        bottom: 20.0,
                      ),
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
                                "Send reset link",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Row(
                    children: [
                      Container(
                        height: 0.065 * height,
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
                                height: 0.065 * height,
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
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: FadeIn(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              "HOUSE MASTER",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void resetPassWord() async {
    try {
      setState(() {
        loading = true;
      });
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email.text.trim())
          .then((value) {
            setState(() {
              loading = false;
            });
            Get.back();
            Get.snackbar(
              "",
              "",
              backgroundColor: Colors.green,
              snackPosition: SnackPosition.BOTTOM,
              titleText: Text(
                "Success!",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              messageText: Text(
                "Reset password link sent to the provided email",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          });
    } catch (e) {
      setState(() {
        loading = false;
      });
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
          "Try again later",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }
}
