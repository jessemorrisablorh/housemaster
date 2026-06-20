import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemasterapp/Pages/sign_up_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int page = 0;
  late PageController pageController;
  void goToPrev() {
    if (pageController.page != 0) {
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void goToNext() {
    if (slides.length == pageController.page!.toInt() + 1) {
      Get.to(() => SignUpPage());
    } else {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  List slides = [
    {
      "image": "images/plumber.png",
      "title": "Find the best Artisan for the perfect job",
      "content":
          "Connect with skilled, trusted artisans ready to deliver quality work, right when you need it.",
    },
    {
      "image": "images/one.png",
      "title": "Choose the best artisan for your project",
      "content":
          "Skilled, verified artisans ready to bring your project to life.",
    },
    {
      "image": "images/two.png",
      "title": "Quality workmanship you can rely on",
      "content": "Professional service built on skill, trust, and experience.",
    },
  ];
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[50]
          : Colors.grey[900],
      body: Stack(
        children: [
          PageView.builder(
            onPageChanged: (value) {
              setState(() {
                page = value;
              });
            },
            physics: NeverScrollableScrollPhysics(),
            controller: pageController,
            itemCount: slides.length,
            itemBuilder: (context, index) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 80.0),
                            child: Text(
                              "HOUSE\nMASTER",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.white.withAlpha(30),
                                fontSize: 80,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: FadeInUp(
                            child: Image.asset(
                              slides[index]["image"],
                              height: 0.45 * height,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 30.0),
                          child: Text(
                            "#",
                            style: GoogleFonts.poppins(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black.withAlpha(30)
                                  : Colors.white.withAlpha(30),
                              fontSize: 50,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 350),
                          child: Icon(
                            Icons.gps_fixed_sharp,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                ? Colors.black.withAlpha(30)
                                : Colors.white.withAlpha(30),
                            size: 50,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 20.0,
                              top: 350,
                            ),
                            child: Text(
                              "#",
                              style: GoogleFonts.poppins(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.black.withAlpha(30)
                                    : Colors.white.withAlpha(30),
                                fontSize: 50,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    FadeInUp(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 35.0, right: 35.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                slides[index]["title"],
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poppins(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    FadeInUp(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 35.0,
                          right: 35.0,
                          top: 15.0,
                        ),
                        child: Text(
                          slides[index]["content"],
                          textAlign: TextAlign.left,
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
                  ],
                ),
              );
            },
          ),
          SafeArea(
            child: InkWell(
              onTap: () {
                Get.to(() => SignUpPage());
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0, top: 50.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(12),
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
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 12.0, 15.0, 12.0),
                    child: Text(
                      "Skip",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: page >= 1,
                child: InkWell(
                  onTap: () {
                    goToPrev();
                  },
                  child: FadeInUp(
                    duration: Duration(milliseconds: 800),
                    child: Container(
                      height: 0.062 * height,
                      width: page == 0 ? 0.01 * width : 0.14 * width,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(15),
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
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),

              Flexible(
                child: InkWell(
                  onTap: () {
                    goToNext();
                  },
                  child: AnimatedContainer(
                    height: 0.062 * height,
                    width: page + 1 == slides.length
                        ? 0.65 * width
                        : page == 0
                        ? 0.83 * width
                        : 0.14 * width,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(15),
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
                    alignment: Alignment.center,
                    duration: Duration(milliseconds: 500),
                    child: page + 1 == slides.length
                        ? Text(
                            "Next",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          )
                        : page == 0
                        ? Text(
                            "Get started",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          )
                        : Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.black,
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
}
