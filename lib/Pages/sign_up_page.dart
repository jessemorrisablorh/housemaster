import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemasterapp/Pages/artisan_sign_up_page.dart';
import 'package:housemasterapp/Pages/client_sign_up_page.dart';
import 'package:housemasterapp/Pages/sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
          Row(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 50.0),
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
          Expanded(
            child: Column(
              children: [
                FadeIn(
                  duration: Duration(milliseconds: 4000),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, top: 50.0),
                        child: Text(
                          "Create account as",
                          style: GoogleFonts.poppins(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Hero(
                  tag: 'my-hero', // <-- Must match on second page
                  child: FadeInUp(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 30.0,
                        right: 30.0,
                        top: 20.0,
                      ),
                      child: InkWell(
                        onTap: () {
                          Get.to(() => ClientSignUpPage());
                        },
                        child: Container(
                          height: 0.25 * height,
                          width: width,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            image: DecorationImage(
                              image: AssetImage("images/client.jpg"),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 0.060 * height,
                            width: width,

                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black26
                                      : Colors.black,
                                  blurRadius: 7,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                "Create account as client",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Hero(
                  tag: "artisan",
                  child: FadeInUp(
                    duration: Duration(milliseconds: 500),
                    child: InkWell(
                      onTap: () {
                        Get.to(() => ArtisanSignUpPage());
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 30.0,
                          right: 30.0,
                          top: 20.0,
                        ),
                        child: Container(
                          height: 0.25 * height,
                          width: width,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            image: DecorationImage(
                              image: AssetImage("images/artisan.jpg"),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.black26
                                    : Colors.black,
                                blurRadius: 7,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 0.060 * height,
                            width: width,

                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                "Create account as artisan",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                FadeInUp(
                  duration: Duration(milliseconds: 500),
                  child: InkWell(
                    onTap: () {
                      Get.to(() => SignInPage());
                    },
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
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 7,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Sign in account",
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
          ),
        ],
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
}
