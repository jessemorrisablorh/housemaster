import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemasterapp/Pages/Artisan/artisan_profile_page.dart';
import 'package:housemasterapp/Pages/Client/artisan_by_occupation.dart';
import 'package:housemasterapp/Pages/Client/artisan_search_page.dart';
import 'package:housemasterapp/Pages/Client/client_artisan_details_page.dart';
import 'package:housemasterapp/Pages/Client/client_artisan_tasks_page.dart';
import 'package:housemasterapp/Pages/Client/client_categories.dart';
import 'package:housemasterapp/Pages/house_master_ai_page.dart';
import 'package:housemasterapp/Widgets/loading_widget.dart';
import 'package:housemasterapp/main.dart';
import 'package:intl/intl.dart';

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key});

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  final formatCurrency = NumberFormat.currency(symbol: " ");
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController search = TextEditingController();
  bool locationloading = false;
  String? cityname;
  String? regionname;
  String? placename;
  double? latitude;
  double? longitude;
  String? selectedPlaceName;
  String? citynamenew;
  String? regionnamenew;
  double? lat;
  double? lng;
  String? clientcity;
  String? clientregion;
  String? useraddress;
  int minimumcharge = 0;
  String fcmtoken = "";

  Future<void> getToken() async {
    String token = box.read("fcmtoken") ?? "";

    fcmtoken = token;

    if (user != null && token.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .update({"token": token});
    }
  }

  @override
  void initState() {
    super.initState();
    getToken();
    getCurrentLocationDetails();
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
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(user?.uid)
          .snapshots(),
      builder: (context, asyncSnapshot) {
        if (!asyncSnapshot.hasData) {
          return LoadingWidget();
        }
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 0.060 * height,
                        width: 0.40 * width,
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).brightness == Brightness.light
                              ? Colors.amber
                              : Colors.amber.withAlpha(60),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 0.060 * height,
                              width: 0.14 * width,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.amber,
                                image: DecorationImage(
                                  image: asyncSnapshot.data?["image"] == ""
                                      ? AssetImage("images/empty.jpg")
                                      : AdvImageCache(
                                          asyncSnapshot.data?["image"],
                                        ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                "Hi ${asyncSnapshot.data?["name"].toString().capitalizeFirst}",
                                overflow: TextOverflow.ellipsis,
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
                            ),
                            SizedBox(width: 15),
                          ],
                        ),
                      ),

                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(() => ClientArtisanTasksPage());
                            },
                            child: Container(
                              height: 0.060 * height,
                              width: 0.13 * width,
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.amber
                                    : Colors.amber.withAlpha(60),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Icon(
                                  Icons.task_outlined,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.amber,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          InkWell(
                            onTap: () {
                              Get.to(() => ArtisanProfilePage());
                            },
                            child: Container(
                              height: 0.060 * height,
                              width: 0.13 * width,
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.amber
                                    : Colors.amber.withAlpha(60),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: ImageIcon(
                                  AssetImage("images/user.png"),
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.amber,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 25.0,
                ),
                child: InkWell(
                  onTap: () {
                    Get.to(() => ArtisanSearchPage());
                  },
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          height: 0.060 * height,
                          width: width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.black12
                                    : Colors.transparent,
                                blurRadius: 7,
                                offset: Offset(1, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 15.0,
                              right: 15.0,
                            ),
                            child: Row(
                              children: [
                                ImageIcon(
                                  AssetImage("images/search.png"),
                                  color: Colors.black,
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Text(
                                    "Search artisans",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black.withAlpha(90),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 0.060 * height,
                          width: width,
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Icon(Icons.tune, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          top: 20.0,
                          right: 20.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.amber
                                    : Colors.amber.withAlpha(180),
                                borderRadius: BorderRadius.circular(12),
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
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  "Categories",
                                  style: GoogleFonts.poppins(
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => ClientCategories());
                              },
                              child: Row(
                                children: [
                                  ImageIcon(
                                    AssetImage("images/menu.png"),
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors.amber,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "View all",
                                    style: GoogleFonts.mulish(
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      FadeInUp(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            top: 20.0,
                            right: 20.0,
                          ),
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("artisans")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return SizedBox(
                                  width: width,
                                  height: 0.30 * height,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 3,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          right: 20.0,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 0.25 * height,
                                              width: 0.50 * width,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[500],

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
                                            ),
                                            SizedBox(height: 10),
                                            Container(
                                              height: 0.030 * height,
                                              width: 0.30 * width,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[500],
                                                borderRadius:
                                                    BorderRadius.circular(5),
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
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                              return FadeInUp(
                                child: SizedBox(
                                  width: width,
                                  height: 0.30 * height,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          Get.to(
                                            () => ArtisanByOccupation(
                                              occupation: snapshot
                                                  .data!
                                                  .docs[index]["name"],
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 20.0,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 0.25 * height,
                                                width: 0.50 * width,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AdvImageCache(
                                                      snapshot
                                                          .data!
                                                          .docs[index]["image"],
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
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                snapshot
                                                    .data!
                                                    .docs[index]["name"],
                                                style: GoogleFonts.poppins(
                                                  color:
                                                      Theme.of(
                                                            context,
                                                          ).brightness ==
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
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      FadeInUp(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            top: 20.0,
                            right: 20.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.amber
                                      : Colors.amber.withAlpha(180),
                                  borderRadius: BorderRadius.circular(12),
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
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Text(
                                    "Artisans",
                                    style: GoogleFonts.poppins(
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                "Skilled Artisans",
                                style: GoogleFonts.mulish(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .where("role", isEqualTo: "artisan")
                              .snapshots(),
                          builder: (context, asyncsnapshot) {
                            if (!asyncsnapshot.hasData) {
                              return ListView.builder(
                                itemCount: 3,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Container(
                                        height: 0.30 * height,
                                        width: width,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[500],
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
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
                                      ),
                                    ],
                                  );
                                },
                              );
                            }

                            return SlideInUp(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: asyncsnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Get.to(
                                        () => ClientArtisanDetailsPage(
                                          name: asyncsnapshot
                                              .data!
                                              .docs[index]["name"],
                                          image: asyncsnapshot
                                              .data!
                                              .docs[index]["image"],
                                          occupation: asyncsnapshot
                                              .data!
                                              .docs[index]["occupation"],
                                          startingamount: "$minimumcharge",
                                          averagerating:
                                              asyncsnapshot
                                                      .data!
                                                      .docs[index]['ratingAverage'] ==
                                                  0
                                              ? 0.0
                                              : asyncsnapshot
                                                    .data!
                                                    .docs[index]['ratingAverage'],
                                          artisanid: asyncsnapshot
                                              .data!
                                              .docs[index]["uid"],
                                          clientid: "${user?.uid}",
                                          bio: asyncsnapshot
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
                                                image:
                                                    asyncsnapshot
                                                            .data!
                                                            .docs[index]["image"] !=
                                                        ""
                                                    ? AdvImageCache(
                                                        asyncsnapshot
                                                            .data!
                                                            .docs[index]["image"],
                                                      )
                                                    : AssetImage(
                                                        "images/empty.jpg",
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
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(
                                                    10,
                                                  ),
                                                  bottomRight: Radius.circular(
                                                    10,
                                                  ),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 15.0,
                                                  right: 15.0,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      asyncsnapshot
                                                          .data!
                                                          .docs[index]["name"],
                                                      style:
                                                          GoogleFonts.poppins(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                    SizedBox(height: 2.0),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          asyncsnapshot
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
                                                            asyncsnapshot
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
                                                          asyncsnapshot
                                                              .data!
                                                              .docs[index]['ratingAverage']
                                                              .toStringAsFixed(
                                                                1,
                                                              ),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
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
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                height: 0.050 * height,
                width: width,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey[50]
                      : Colors.grey[900],
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          useraddress ??
                              "Searching for your current location ...",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(() => HouseMasterAiPage());
            },
            backgroundColor: Colors.amber,
            child: Icon(Icons.auto_awesome, color: Colors.black),
          ),
        );
      },
    );
  }

  Future<void> getCurrentLocationDetails() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      lat = position.latitude;
      lng = position.longitude;

      final placemarks = await placemarkFromCoordinates(lat!, lng!);
      final placemark = placemarks.first;

      useraddress = placemark.name;
      clientcity = placemark.locality;
      clientregion = placemark.administrativeArea;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user?.uid)
          .update({
            "lat": lat,
            "lng": lng,
            "placename": placemark.name,
            "clientcity": placemark.locality,
            "clientregion": placemark.administrativeArea,
          });

      setState(() {
        locationloading = false;
      });
    } catch (e) {
      debugPrint("Location error: $e");
    }
  }
}
