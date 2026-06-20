import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemasterapp/Pages/reset_password_page.dart';
import 'package:housemasterapp/Pages/screen_controller_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool loading = false;
  String emailtext = "Email";
  String passwordtext = "Passsword";
  bool emailerror = false;
  bool passworderror = false;
  bool hidepassword = true;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[50]
          : Colors.grey[900],
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
                      color: Colors.white,
                      image: DecorationImage(
                        image: AssetImage("images/app_icon.png"),
                      ),
                      shape: BoxShape.circle,
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
                      height: 0.060 * height,
                      width: width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 7,
                            offset: Offset(1, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Row(
                          children: [
                            ImageIcon(
                              AssetImage("images/email.png"),
                              color: Colors.black,
                            ),
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
                                  color: Colors.black,
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
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 30.0,
                      right: 30.0,
                      top: 20.0,
                    ),
                    child: Container(
                      height: 0.060 * height,
                      width: width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 7,
                            offset: Offset(1, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Row(
                          children: [
                            ImageIcon(
                              AssetImage("images/password.png"),
                              color: Colors.black,
                            ),
                            SizedBox(width: 15.0),
                            Expanded(
                              child: TextFormField(
                                obscureText: hidepassword,
                                onTap: () {
                                  if (passworderror) {
                                    setState(() {
                                      password.clear();
                                      passwordtext = "Password";
                                      passworderror = false;
                                    });
                                  }
                                },
                                controller: password,
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                cursorHeight: 13,
                                cursorColor: Colors.black,
                                cursorErrorColor: Colors.black,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 5.0),

                                  suffix: InkWell(
                                    onTap: () {
                                      if (hidepassword == true) {
                                        setState(() {
                                          hidepassword = false;
                                        });
                                      } else {
                                        if (hidepassword == false) {
                                          setState(() {
                                            hidepassword = true;
                                          });
                                        }
                                      }
                                    },
                                    child: Icon(
                                      hidepassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.black,
                                    ),
                                  ),
                                  errorStyle: TextStyle(fontSize: 0.01),
                                  hintText: passwordtext,
                                  hintStyle: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: passworderror
                                        ? Colors.red
                                        : Colors.black,
                                  ),
                                  border: InputBorder.none,
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    setState(() {
                                      password.clear();
                                      passworderror = true;
                                      passwordtext = "Required";
                                    });
                                    return "Required";
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
                        signIn();
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
                        height: 0.060 * height,
                        width: width,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
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
                            : Text(
                                "Sign in account",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                FadeInUp(
                  child: InkWell(
                    onTap: () {
                      Get.to(() => ResetPasswordPage());
                    },
                    child: Text(
                      "Reset password",
                      style: GoogleFonts.poppins(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: FadeInUp(
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Text(
                        "Create new account",
                        style: GoogleFonts.poppins(
                          color:
                              Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
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
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: FadeIn(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "HOUSE MASTER",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signIn() async {
    try {
      setState(() {
        loading = true;
      });

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      setState(() {
        loading = false;
      });

      Get.offAll(() => ScreenControllerPage());
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });

      String message = "Something went wrong";

      if (e.code == 'user-not-found') {
        message = "No user found with this email";
      } else if (e.code == 'wrong-password') {
        message = "Incorrect password";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email format";
      } else if (e.code == 'user-disabled') {
        message = "This account has been disabled";
      } else if (e.code == 'invalid-credential') {
        message = "Invalid email or password";
      }

      Get.snackbar(
        // "Login Error",
        // message,
        "",
        "",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        //colorText: Colors.white,
        titleText: Text(
          "Error!",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        messageText: Text(
          message,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
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
