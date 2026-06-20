import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemasterapp/Pages/accepted_task_details_page.dart';
import 'package:intl/intl.dart';

class ArtisanAcceptedTask extends StatefulWidget {
  const ArtisanAcceptedTask({super.key});

  @override
  State<ArtisanAcceptedTask> createState() => _ArtisanAcceptedTaskState();
}

class _ArtisanAcceptedTaskState extends State<ArtisanAcceptedTask> {
  final formatCurrency = NumberFormat.currency(symbol: " ");
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
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("connects")
                        .where("artisanid", isEqualTo: user?.uid)
                        .where("status", isEqualTo: "accepted")
                        .orderBy("datecreated", descending: true)
                        .snapshots(),
                    builder: (context, asyncSnapshot) {
                      if (!asyncSnapshot.hasData) {
                        return SizedBox();
                      }
                      return asyncSnapshot.data!.docs.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 150),
                                Icon(
                                  Icons.circle_outlined,
                                  color: Colors.amber,
                                  size: 85,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "No task found",
                                  style: GoogleFonts.poppins(
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: asyncSnapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(
                                        asyncSnapshot
                                            .data!
                                            .docs[index]["clientid"],
                                      )
                                      .snapshots(),
                                  builder: (context, artisanSnapshot) {
                                    if (!artisanSnapshot.hasData) {
                                      return SizedBox();
                                    }
                                    return InkWell(
                                      onTap: () {
                                        Get.to(
                                          () => AcceptedTaskDetailsPage(
                                            connectid: asyncSnapshot
                                                .data!
                                                .docs[index]["id"],
                                            who: "artisan",
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20.0,
                                          right: 20.0,
                                          bottom: 10.0,
                                        ),
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 0.25 * height,
                                              width: width,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                image: DecorationImage(
                                                  image:
                                                      artisanSnapshot
                                                              .data?["image"] ==
                                                          ""
                                                      ? AssetImage(
                                                          "images/empty.jpg",
                                                        )
                                                      : AdvImageCache(
                                                          artisanSnapshot
                                                              .data?["image"],
                                                        ),
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:
                                                        Theme.of(
                                                              context,
                                                            ).brightness ==
                                                            Brightness.light
                                                        ? Colors.black26
                                                        : Colors.black,
                                                    blurRadius: 7,
                                                    offset: Offset(1, 2),
                                                  ),
                                                ],
                                              ),
                                              alignment: Alignment.bottomCenter,
                                              child: Container(
                                                height: 0.10 * height,
                                                width: width,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(10),
                                                      ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 20.0,
                                                        right: 20.0,
                                                      ),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              artisanSnapshot
                                                                  .data?["name"],
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: GoogleFonts.poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 13,
                                                              ),
                                                            ),

                                                            SizedBox(
                                                              height: 3.0,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .location_history,
                                                                  color: Colors
                                                                      .amber,
                                                                ),
                                                                SizedBox(
                                                                  width: 10.0,
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    artisanSnapshot
                                                                        .data?["placename"],
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts.poppins(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          13,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 0.060 * height,
                                              width: 0.35 * width,
                                              decoration: BoxDecoration(
                                                color: Colors.amber,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(
                                                    10.0,
                                                  ),
                                                ),
                                              ),
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 15.0,
                                                  right: 15.0,
                                                ),
                                                child: Text(
                                                  "GHS ${formatCurrency.format(asyncSnapshot.data!.docs[index]["artisanservicecharge"])}",

                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
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
