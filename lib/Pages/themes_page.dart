import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemasterapp/theme_controller.dart';

class ThemesPage extends StatefulWidget {
  const ThemesPage({super.key});

  @override
  State<ThemesPage> createState() => _ThemesPageState();
}

class _ThemesPageState extends State<ThemesPage> {
  final ThemeController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
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
                children: [
                  GetBuilder<ThemeController>(
                    builder: (_) {
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              controller.setTheme("light");
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 20.0,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_box,
                                    color: getSelected() == "light"
                                        ? Colors.amber
                                        : Colors.grey,
                                    size: 30,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Light Mode",
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
                          InkWell(
                            onTap: () {
                              controller.setTheme("dark");
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 20.0,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_box,
                                    color: getSelected() == "dark"
                                        ? Colors.amber
                                        : Colors.grey,
                                    size: 30,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Dark Mode",
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
                          InkWell(
                            onTap: () {
                              controller.setTheme("system");
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 20.0,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_box,
                                    color: getSelected() == "system"
                                        ? Colors.amber
                                        : Colors.grey,
                                    size: 30,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Default System",
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
                          // RadioListTile(
                          //   title: const Text("Light"),
                          //   value: "light",
                          //   groupValue: getSelected(),
                          //   onChanged: (value) {
                          //     print(getSelected());
                          //     controller.setTheme("light");
                          //   },
                          // ),

                          // RadioListTile(
                          //   title: const Text("Dark"),
                          //   value: "dark",
                          //   groupValue: getSelected(),
                          //   onChanged: (value) {
                          //     controller.setTheme("dark");
                          //   },
                          // ),

                          // RadioListTile(
                          //   title: const Text("System default"),
                          //   value: "system",
                          //   groupValue: getSelected(),
                          //   onChanged: (value) {
                          //     controller.setTheme("system");
                          //   },
                          // ),
                        ],
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

  String getSelected() {
    final mode = controller.themeMode;

    if (mode == ThemeMode.light) {
      return "light";
    } else if (mode == ThemeMode.dark) {
      return "dark";
    } else {
      return "system";
    }
  }
}
