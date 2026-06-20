import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemasterapp/Pages/Client/client_home_page.dart';

class ArtisanConnectedPage extends StatefulWidget {
  final String artisanname;
  const ArtisanConnectedPage({super.key, required this.artisanname});

  @override
  State<ArtisanConnectedPage> createState() => _ArtisanConnectedPageState();
}

class _ArtisanConnectedPageState extends State<ArtisanConnectedPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.grey[50]
            : Colors.grey[900],
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FadeInUp(
                  child: Container(
                    height: 0.15 * height,
                    width: 0.20 * width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.amber
                          : Colors.amber.withAlpha(90),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                      size: 50,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                FadeInUp(
                  child: Text(
                    "Artisan request successful",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 10),
                FadeInUp(
                  child: Text(
                    "We will notify you when ${widget.artisanname}\naccepts or rejects your request",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                FadeInUp(
                  child: InkWell(
                    onTap: () {
                      Get.offAll(() => ClientHomePage());
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 25.0,
                        right: 25.0,
                        top: 30.0,
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
                          "Ok Thank you",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
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
