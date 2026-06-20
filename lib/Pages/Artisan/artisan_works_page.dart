import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemasterapp/Pages/Artisan/add_new_work_page.dart';
import 'package:housemasterapp/Pages/Artisan/artisan_work_details.dart';

class ArtisanWorksPage extends StatefulWidget {
  const ArtisanWorksPage({super.key});

  @override
  State<ArtisanWorksPage> createState() => _ArtisanWorksPageState();
}

class _ArtisanWorksPageState extends State<ArtisanWorksPage> {
  User? user = FirebaseAuth.instance.currentUser;
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
              child: Column(
                children: [
                  FadeInUp(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                            left: 20.0,
                            right: 20.0,
                          ),
                          child: Text(
                            "Your works",
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
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("works")
                        .where("uid", isEqualTo: user?.uid)
                        .orderBy("datecreated", descending: true)
                        .snapshots(),
                    builder: (context, asyncsnapshot) {
                      if (!asyncsnapshot.hasData) {
                        return Text("...");
                      }
                      return Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: asyncsnapshot.data!.docs.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 2 / 3,
                                crossAxisCount: 3,
                              ),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Get.to(
                                  () => ArtisanWorkDetails(
                                    id: asyncsnapshot.data!.docs[index]["id"],
                                    image: asyncsnapshot
                                        .data!
                                        .docs[index]["image"],
                                    daycreated: asyncsnapshot
                                        .data!
                                        .docs[index]["daycreated"],
                                    monthcreated: asyncsnapshot
                                        .data!
                                        .docs[index]["monthcreated"],
                                    yearcreated: asyncsnapshot
                                        .data!
                                        .docs[index]["yearcreated"],
                                  ),
                                );
                              },
                              child: Container(
                                height: 0.30 * height,
                                width: 0.25 * width,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AdvImageCache(
                                      asyncsnapshot.data!.docs[index]["image"],
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        backgroundColor: Colors.amber,
        onPressed: () {
          Get.to(() => AddNewWorkPage());
        },
        label: Text(
          "Add new",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
