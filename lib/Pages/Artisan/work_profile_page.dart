import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemasterapp/Pages/Artisan/artisan_works_page.dart';
import 'package:housemasterapp/Pages/Artisan/artisans_review_page.dart';
import 'package:housemasterapp/Pages/Artisan/bio_page.dart';
import 'package:housemasterapp/theme_controller.dart';

class WorkProfilePage extends StatefulWidget {
  const WorkProfilePage({super.key});

  @override
  State<WorkProfilePage> createState() => _WorkProfilePageState();
}

class _WorkProfilePageState extends State<WorkProfilePage> {
  final ThemeController controller = Get.find();
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
                              "Work profile",
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
                          Get.to(() => BioPage());
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
                                  Icons.text_snippet_outlined,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.amber,
                                ),
                              ),
                              SizedBox(width: 15.0),
                              Text(
                                "Bio",
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
                      child: Divider(color: Colors.amber.withAlpha(110)),
                    ),
                    FadeInUp(
                      child: InkWell(
                        onTap: () {
                          Get.to(() => ArtisanWorksPage());
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
                                  Icons.grid_4x4,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.amber,
                                ),
                              ),
                              SizedBox(width: 15.0),
                              Text(
                                "Your works",
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
                      child: Divider(color: Colors.amber.withAlpha(110)),
                    ),
                    FadeInUp(
                      child: InkWell(
                        onTap: () {
                          Get.to(() => ArtisansReviewPage());
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
                                  Icons.message_outlined,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.amber,
                                ),
                              ),
                              SizedBox(width: 15.0),
                              Text(
                                "Reviews",
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

                    // FadeInUp(
                    //   child: Divider(color: Colors.amber.withAlpha(110)),
                    // ),
                    // FadeInUp(
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                    //     child: Row(
                    //       children: [
                    //         Container(
                    //           height: 0.050 * height,
                    //           width: 0.11 * width,
                    //           decoration: BoxDecoration(
                    //             color: Colors.amber.withAlpha(100),
                    //             borderRadius: BorderRadius.circular(10),
                    //           ),
                    //           child: Icon(
                    //             Icons.contact_emergency_outlined,
                    //             color: Colors.amber,
                    //           ),
                    //         ),
                    //         SizedBox(width: 15.0),
                    //         Text(
                    //           "Verification",
                    //           style: GoogleFonts.poppins(
                    //             color: Colors.white,
                    //             fontSize: 13,
                    //             fontWeight: FontWeight.w600,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
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
