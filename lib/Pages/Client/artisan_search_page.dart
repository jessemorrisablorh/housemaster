import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemasterapp/Pages/Client/artisan_by_occupation.dart';
import 'package:housemasterapp/Pages/Client/client_artisan_details_page.dart';

class ArtisanSearchPage extends StatefulWidget {
  const ArtisanSearchPage({super.key});

  @override
  State<ArtisanSearchPage> createState() => _ArtisanSearchPageState();
}

class _ArtisanSearchPageState extends State<ArtisanSearchPage> {
  User? mainuser = FirebaseAuth.instance.currentUser;
  List recentsearch = [];
  int minimumcharge = 0;
  TextEditingController searchController = TextEditingController();
  String searchText = '';
  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchText = searchController.text.trim();
      });
    });
  }

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
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Container(
                      height: 0.060 * height,
                      width: width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Row(
                          children: [
                            ImageIcon(
                              AssetImage("images/search.png"),
                              color: Colors.black,
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: TextField(
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                                cursorHeight: 13,
                                cursorColor: Colors.black,
                                controller: searchController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Search artisans",
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.black.withAlpha(90),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  searchText.isEmpty
                      ? SizedBox()
                      : StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .where("role", isEqualTo: "artisan")
                              .where(
                                'name',
                                isGreaterThanOrEqualTo: searchText
                                    .toString()
                                    .capitalizeFirst,
                              )
                              .where(
                                'name',
                                isLessThanOrEqualTo:
                                    '${searchText.toString().capitalizeFirst}\uf8ff',
                              )
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator(
                                color: Colors.amber,
                              );
                            }

                            final results = snapshot.data!.docs;

                            if (results.isEmpty) {
                              return Text(
                                "",
                                style: TextStyle(color: Colors.white),
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: results.length,
                              itemBuilder: (context, index) {
                                final user = results[index];
                                return InkWell(
                                  onTap: () {
                                    Get.to(
                                      () => ClientArtisanDetailsPage(
                                        name: user["name"],
                                        image: user["image"],
                                        startingamount: "$minimumcharge",
                                        occupation: user["occupation"],
                                        averagerating:
                                            user['ratingAverage'] == 0
                                            ? 0.0
                                            : user['ratingAverage'],
                                        clientid: "${mainuser?.uid}",
                                        artisanid: user["uid"],
                                        bio: user["bio"],
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 5.0,
                                      left: 20.0,
                                      right: 20.0,
                                    ),
                                    child: Container(
                                      height: 0.10 * height,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 0.10 * height,
                                            width: 0.27 * width,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: user["image"] == ""
                                                    ? AssetImage(
                                                        "images/empty.jpg",
                                                      )
                                                    : AdvImageCache(
                                                        user["image"],
                                                      ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 15),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Artisan's details",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.amber,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  user['name'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  user['occupation'],
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                  if (recentsearch.isNotEmpty)
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 30.0),
                          child: Text(
                            "Recent search",
                            style: GoogleFonts.poppins(
                              color: Colors.amber,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (recentsearch.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: recentsearch.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 0.060 * height,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    recentsearch[index],
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      recentsearch.remove(recentsearch[index]);
                                    });
                                  },
                                  child: Icon(Icons.close, color: Colors.red),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(color: Colors.grey.withAlpha(300));
                        },
                      ),
                    ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 30.0),
                        child: Text(
                          "Search by category",
                          style: GoogleFonts.poppins(
                            color: Colors.amber,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("artisans")
                        .snapshots(),
                    builder: (context, asyncsnapshot) {
                      if (!asyncsnapshot.hasData) {
                        return SizedBox();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: asyncsnapshot.data!.docs.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                              ),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Get.to(
                                  () => ArtisanByOccupation(
                                    occupation:
                                        asyncsnapshot.data!.docs[index]["name"],
                                  ),
                                );
                              },
                              child: Text(
                                asyncsnapshot.data!.docs[index]["name"],
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
    );
  }
}
