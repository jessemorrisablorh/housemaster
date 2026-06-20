import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemasterapp/Pages/Artisan/artisan_change_image_page.dart';
import 'package:housemasterapp/Pages/Artisan/change_password_page.dart';
import 'package:housemasterapp/Pages/Client/change_username_page.dart';
import 'package:housemasterapp/Pages/delete_user_account_page.dart';
import 'package:housemasterapp/Pages/themes_page.dart';
import 'package:housemasterapp/Pages/two_factor_authentication_page.dart';
import 'package:housemasterapp/Pages/welcome_page.dart';
import 'package:housemasterapp/theme_controller.dart';

class ArtisanProfilePage extends StatefulWidget {
  const ArtisanProfilePage({super.key});

  @override
  State<ArtisanProfilePage> createState() => _ArtisanProfilePageState();
}

class _ArtisanProfilePageState extends State<ArtisanProfilePage> {
  final ThemeController controller = Get.find();
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
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.amber.withAlpha(150)
                            : Colors.amber.withAlpha(60),
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
                              "Profile",
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
                    FadeInUp(
                      child: InkWell(
                        onTap: () {
                          Get.to(() => ArtisanChangeImagePage());
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 30.0,
                            bottom: 20.0,
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 0.050 * height,
                                width: 0.11 * width,
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.amber
                                      : Colors.amber.withAlpha(100),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 7,
                                      offset: Offset(1, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.photo,

                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.amber,
                                ),
                              ),
                              SizedBox(width: 15.0),
                              Text(
                                "Profile image",
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    FadeInUp(
                      child: Divider(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[400]
                            : Colors.amber.withAlpha(110),
                      ),
                    ),
                    FadeInUp(
                      child: InkWell(
                        onTap: () {
                          Get.to(() => ChangeUsernamePage());
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 20.0,
                            bottom: 20.0,
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 0.050 * height,
                                width: 0.11 * width,
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.amber
                                      : Colors.amber.withAlpha(100),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.fourteen_mp_outlined,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.amber,
                                ),
                              ),
                              SizedBox(width: 15.0),
                              Text(
                                "Change Username",
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    FadeInUp(
                      child: Divider(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[400]
                            : Colors.amber.withAlpha(110),
                      ),
                    ),
                    FadeInUp(
                      child: InkWell(
                        onTap: () {
                          Get.to(() => ChangePasswordPage());
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 20.0,
                            bottom: 20.0,
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 0.050 * height,
                                width: 0.11 * width,
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.amber
                                      : Colors.amber.withAlpha(100),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 7,
                                      offset: Offset(1, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.password,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.amber,
                                ),
                              ),
                              SizedBox(width: 15.0),
                              Text(
                                "Change password",
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    FadeInUp(
                      child: Divider(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[400]
                            : Colors.amber.withAlpha(110),
                      ),
                    ),
                    FadeInUp(
                      child: InkWell(
                        onTap: () {
                          Get.to(() => ThemesPage());
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 20.0,
                            bottom: 20.0,
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 0.050 * height,
                                width: 0.11 * width,
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.amber
                                      : Colors.amber.withAlpha(100),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 7,
                                      offset: Offset(1, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.display_settings,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.amber,
                                ),
                              ),
                              SizedBox(width: 15.0),
                              Text(
                                "Theme settings",
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    FadeInUp(
                      child: Divider(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[400]
                            : Colors.amber.withAlpha(110),
                      ),
                    ),
                    FadeInUp(
                      child: InkWell(
                        onTap: () {
                          Get.to(() => TwoFactorAuthenticationPage());
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 20.0,
                            bottom: 20.0,
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 0.050 * height,
                                width: 0.11 * width,
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.amber
                                      : Colors.amber.withAlpha(100),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 7,
                                      offset: Offset(1, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.shield_moon_sharp,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.amber,
                                ),
                              ),
                              SizedBox(width: 15.0),
                              Text(
                                "Two-factor authentication",
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    FadeInUp(
                      child: Divider(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[400]
                            : Colors.amber.withAlpha(110),
                      ),
                    ),
                    FadeInUp(
                      child: InkWell(
                        onTap: () {
                          Get.to(() => DeleteUserAccountPage());
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 20.0,
                            bottom: 20.0,
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 0.050 * height,
                                width: 0.11 * width,
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.amber
                                      : Colors.amber.withAlpha(100),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 7,
                                      offset: Offset(1, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.delete_forever_outlined,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.amber,
                                ),
                              ),
                              SizedBox(width: 15.0),
                              Text(
                                "Delete acccount & my data",
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
                            ],
                          ),
                        ),
                      ),
                    ),

                    FadeInUp(
                      child: Divider(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[400]
                            : Colors.amber.withAlpha(110),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.dialog(
                          StatefulBuilder(
                            builder: (context, setState) {
                              return Dialog(
                                backgroundColor:
                                    Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.white
                                    : Colors.grey[900],
                                // backgroundColor: Colors.grey[900],
                                child: Container(
                                  width: width,
                                  height: 0.40 * height,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 7,
                                              offset: Offset(1, 2),
                                            ),
                                          ],
                                          color:
                                              Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Colors.amber
                                              : Colors.amber.withAlpha(100),
                                        ),
                                        child: Icon(
                                          Icons.exit_to_app_outlined,
                                          color:
                                              Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Colors.black
                                              : Colors.amber,
                                          size: 45,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20.0,
                                          right: 20.0,
                                        ),
                                        child: Text(
                                          "You are about signing out, do you want to proceed",
                                          textAlign: TextAlign.center,
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
                      child: FadeInUp(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 20.0,
                            bottom: 20.0,
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 0.050 * height,
                                width: 0.11 * width,
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.amber
                                      : Colors.amber.withAlpha(100),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 7,
                                      offset: Offset(1, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.exit_to_app_outlined,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.amber,
                                ),
                              ),
                              SizedBox(width: 15.0),
                              Text(
                                "Sign out",
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
                            ],
                          ),
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
      bottomNavigationBar: SizedBox(height: 50),
    );
  }
}
