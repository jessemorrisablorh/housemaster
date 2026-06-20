import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemasterapp/Pages/ai_results_page.dart';

class SelectArtisanSkills extends StatefulWidget {
  final String problem;
  const SelectArtisanSkills({super.key, required this.problem});

  @override
  State<SelectArtisanSkills> createState() => _SelectArtisanSkillsState();
}

class _SelectArtisanSkillsState extends State<SelectArtisanSkills> {
  User? user = FirebaseAuth.instance.currentUser;
  String clientname = "";
  Future<void> getUserName() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user?.uid)
        .get()
        .then((value) {
          setState(() {
            clientname = value["name"];
          });
        });
  }

  @override
  void initState() {
    super.initState();
    getUserName();
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "$clientname, to get you the perfect artisan for your request, help me by selecting the artisan type needed",
                            style: GoogleFonts.poppins(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('artisans')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20.0,
                                    bottom: 5.0,
                                  ),
                                  child: Container(
                                    width: width,
                                    height: 0.080 * height,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Get.to(
                                () => AiResultsPage(
                                  problem: widget.problem,
                                  artisancategory:
                                      snapshot.data!.docs[index]["name"],
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20.0,
                                bottom: 5.0,
                              ),
                              child: FadeInUp(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10.0,
                                    bottom: 10.0,
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
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 7,
                                              offset: Offset(1, 2),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.circle_outlined,
                                          color:
                                              Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Colors.black
                                              : Colors.amber,
                                        ),
                                      ),
                                      SizedBox(width: 15.0),
                                      Expanded(
                                        child: Text(
                                          snapshot.data!.docs[index]["name"],
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
                                    ],
                                  ),
                                ),
                                // ),

                                // Container(
                                //   height: 0.06 * height,
                                //   width: width,
                                //   decoration: BoxDecoration(
                                //     color:
                                //         Theme.of(context).brightness ==
                                //             Brightness.light
                                //         ? Colors.white
                                //         : Colors.black,
                                //     boxShadow: [
                                //       BoxShadow(
                                //         color: Colors.black26,
                                //         blurRadius: 7,
                                //         offset: Offset(1, 2),
                                //       ),
                                //     ],
                                //   ),
                                //   alignment: Alignment.centerLeft,
                                //   child: Padding(
                                //     padding: const EdgeInsets.only(
                                //       left: 15.0,
                                //       right: 15.0,
                                //     ),
                                //     child: Text(
                                //       snapshot.data!.docs[index]["name"],
                                //       style: GoogleFonts.poppins(
                                //         fontSize: 13,
                                //         color:
                                //             Theme.of(context).brightness ==
                                //                 Brightness.light
                                //             ? Colors.black
                                //             : Colors.white,
                                //         fontWeight: FontWeight.w600,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return FadeInUp(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20.0,
                              ),
                              child: Divider(
                                color: Colors.amber.withAlpha(110),
                              ),
                            ),
                          );
                        },
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
