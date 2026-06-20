import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemasterapp/Pages/select_artisan_skills.dart';

class HouseMasterAiPage extends StatefulWidget {
  const HouseMasterAiPage({super.key});

  @override
  State<HouseMasterAiPage> createState() => _HouseMasterAiPageState();
}

class _HouseMasterAiPageState extends State<HouseMasterAiPage> {
  TextEditingController helptext = TextEditingController();
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
                            duration: Duration(milliseconds: 600),
                            child: Container(
                              height: 0.065 * height,
                              width: 0.14 * width,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.amber,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Icon(
                                  Icons.arrow_back,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                                ),
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
            child: Column(
              children: [
                SizedBox(height: 70),
                FadeInUp(
                  child: Icon(
                    Icons.auto_awesome,
                    color: Colors.amber,
                    size: 40,
                  ),
                ),
                SizedBox(height: 10),
                FadeInUp(
                  child: Text(
                    "Hello, I'm the House master AI,",
                    style: GoogleFonts.poppins(
                      color: Colors.amber,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                FadeInUp(
                  child: Text(
                    "I can help you find the perfect match..",

                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                FadeInUp(
                  child: Text(
                    "Tell me what the problem is",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                FadeInUp(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 20.0,
                      bottom: 30.0,
                    ),
                    child: Container(
                      height: 0.20 * height,
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[500]
                            : Colors.black,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextField(
                          cursorColor:
                              Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                          cursorHeight: 13,
                          style: GoogleFonts.poppins(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          controller: helptext,
                          maxLines: 20,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Tell it all..",
                            hintStyle: GoogleFonts.poppins(
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
                      ),
                    ),
                  ),
                ),
                FadeInUp(
                  child: InkWell(
                    onTap: () {
                      if (helptext.text == "") {
                        Get.snackbar(
                          margin: EdgeInsets.only(
                            bottom: 15,
                            left: 20.0,
                            right: 20.0,
                          ),
                          backgroundColor: Colors.red,
                          snackPosition: SnackPosition.BOTTOM,
                          "",
                          "",
                          titleText: Text(
                            "Field can't be empty",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          messageText: Text(
                            "House master AI can't help if feild is empty.",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      } else {
                        Get.to(
                          () => SelectArtisanSkills(problem: helptext.text),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Container(
                        width: width,
                        height: 0.060 * height,
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
                          "Submit",
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
    );
  }
}
