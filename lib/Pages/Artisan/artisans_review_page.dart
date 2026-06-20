import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ArtisansReviewPage extends StatefulWidget {
  const ArtisansReviewPage({super.key});

  @override
  State<ArtisansReviewPage> createState() => _ArtisansReviewPageState();
}

class _ArtisansReviewPageState extends State<ArtisansReviewPage> {
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
                              "Reviews",
                              style: GoogleFonts.poppins(
                                color: Colors.amber,
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
                          .collection("reviews")
                          .where("artisanid", isEqualTo: user?.uid)
                          .snapshots(),
                      builder: (context, asyncsnapshot) {
                        if (!asyncsnapshot.hasData) {
                          return FadeInUp(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 150.0),
                                  child: Icon(
                                    Icons.circle_outlined,
                                    size: 130,
                                    color: Colors.amber.withAlpha(90),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "There are no reviews for you, get some good work done to receive reviews from clients",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return asyncsnapshot.data!.docs.isEmpty
                            ? FadeInUp(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 150.0,
                                      ),
                                      child: Icon(
                                        Icons.circle_outlined,
                                        size: 130,
                                        color: Colors.amber.withAlpha(90),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      "There are no reviews for you, get some good work done to receive reviews from clients",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: asyncsnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  Timestamp timestamp = asyncsnapshot
                                      .data!
                                      .docs[index]['datecreated'];
                                  DateTime date = timestamp.toDate();
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            StreamBuilder(
                                              stream: FirebaseFirestore.instance
                                                  .collection("users")
                                                  .doc(
                                                    asyncsnapshot
                                                        .data!
                                                        .docs[index]["clientid"],
                                                  )
                                                  .snapshots(),
                                              builder: (context, usersnapshot) {
                                                if (!usersnapshot.hasData) {
                                                  return SizedBox();
                                                }
                                                return Row(
                                                  children: [
                                                    Container(
                                                      height: 0.055 * height,
                                                      width: 0.13 * width,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                        image: DecorationImage(
                                                          image:
                                                              usersnapshot
                                                                      .data?["image"] ==
                                                                  ""
                                                              ? AssetImage(
                                                                  "images/empty.jpg",
                                                                )
                                                              : AdvImageCache(
                                                                  usersnapshot
                                                                      .data?["image"],
                                                                ),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      usersnapshot
                                                          .data?["name"],
                                                      style: GoogleFonts.poppins(
                                                        color:
                                                            Theme.of(
                                                                  context,
                                                                ).brightness ==
                                                                Brightness.light
                                                            ? Colors.black
                                                            : Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                            Text(
                                              "${date.day} - ${date.month} - ${date.year} ",
                                              style: GoogleFonts.poppins(
                                                color:
                                                    Theme.of(
                                                          context,
                                                        ).brightness ==
                                                        Brightness.light
                                                    ? Colors.black
                                                    : Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 15.0),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                asyncsnapshot
                                                    .data!
                                                    .docs[index]["review"],
                                                style: GoogleFonts.poppins(
                                                  color:
                                                      Theme.of(
                                                            context,
                                                          ).brightness ==
                                                          Brightness.light
                                                      ? Colors.black
                                                      : Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20.0,
                                          right: 20.0,
                                          bottom: 15.0,
                                          top: 20.0,
                                        ),
                                        child: Divider(color: Colors.amber),
                                      );
                                    },
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
