import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemasterapp/Pages/Client/client_artisan_details_page.dart';
import 'package:intl/intl.dart';

class AiResultsPage extends StatefulWidget {
  final String problem;
  final String artisancategory;
  const AiResultsPage({
    super.key,
    required this.problem,
    required this.artisancategory,
  });

  @override
  State<AiResultsPage> createState() => _AiResultsPageState();
}

class _AiResultsPageState extends State<AiResultsPage> {
  final formatCurrency = NumberFormat.currency(symbol: " ");
  int minimumcharge = 0;
  User? user = FirebaseAuth.instance.currentUser;
  Future<int?> getMinimumServiceAmount(String artisanId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('services')
        .where('artisanid', isEqualTo: artisanId)
        .orderBy('amount')
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null; // user has no services
    }

    return querySnapshot.docs.first['amount'] as int;
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
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Based on number of works completed, Highest number of rating and reviews, this is the best ${widget.artisancategory} for your problem",
                            style: GoogleFonts.poppins(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .where("role", isEqualTo: "artisan")
                          .where(
                            "occupation",
                            isEqualTo: widget.artisancategory,
                          )
                          .orderBy("ratingAverage", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return SizedBox();
                        }
                        return snapshot.data!.docs.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(top: 150.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search,
                                      color: Colors.black.withAlpha(90),
                                      size: 80,
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      "No artisan found at the moment",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SlideInUp(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: 1,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Get.to(
                                          () => ClientArtisanDetailsPage(
                                            name: snapshot
                                                .data!
                                                .docs[index]["name"],
                                            image: snapshot
                                                .data!
                                                .docs[index]["image"],
                                            occupation: snapshot
                                                .data!
                                                .docs[index]["occupation"],
                                            startingamount: "$minimumcharge",
                                            averagerating:
                                                snapshot
                                                        .data!
                                                        .docs[index]['ratingAverage'] ==
                                                    0
                                                ? 0.0
                                                : snapshot
                                                      .data!
                                                      .docs[index]['ratingAverage'],
                                            artisanid: snapshot
                                                .data!
                                                .docs[index]["uid"],
                                            clientid: "${user?.uid}",
                                            bio: snapshot
                                                .data!
                                                .docs[index]["bio"],
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 20.0,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 0.30 * height,
                                              width: width,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    snapshot
                                                        .data!
                                                        .docs[index]["image"],
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                                color: Colors.white,
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
                                                        left: 15.0,
                                                        right: 15.0,
                                                      ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        snapshot
                                                            .data!
                                                            .docs[index]["name"],
                                                        style:
                                                            GoogleFonts.poppins(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),
                                                      SizedBox(height: 2.0),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            snapshot
                                                                .data!
                                                                .docs[index]["occupation"],
                                                            style:
                                                                GoogleFonts.poppins(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 12,
                                                                ),
                                                          ),

                                                          FutureBuilder<int?>(
                                                            future: getMinimumServiceAmount(
                                                              snapshot
                                                                  .data!
                                                                  .docs[index]["uid"],
                                                            ),
                                                            builder: (context, snapshot) {
                                                              if (snapshot
                                                                      .connectionState ==
                                                                  ConnectionState
                                                                      .waiting) {
                                                                return const Text(
                                                                  "GHS ...",
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                );
                                                              }

                                                              if (!snapshot
                                                                      .hasData ||
                                                                  snapshot.data ==
                                                                      null) {
                                                                return const Text(
                                                                  "GHS 10",
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                );
                                                              }

                                                              return Text(
                                                                "GHS ${formatCurrency.format(snapshot.data)}",
                                                                style: GoogleFonts.poppins(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 2.0),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.star,
                                                            color: Colors.amber,
                                                            size: 15,
                                                          ),
                                                          Icon(
                                                            Icons.star,
                                                            color: Colors.amber,
                                                            size: 15,
                                                          ),
                                                          Icon(
                                                            Icons.star_half,
                                                            color: Colors.amber,
                                                            size: 15,
                                                          ),
                                                          SizedBox(width: 8),
                                                          Text(
                                                            snapshot
                                                                .data!
                                                                .docs[index]['ratingAverage']
                                                                .toStringAsFixed(
                                                                  1,
                                                                ),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
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
                    ),
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
