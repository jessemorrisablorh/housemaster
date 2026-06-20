import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemasterapp/Pages/Client/connect_artisan_page.dart';
import 'package:housemasterapp/Pages/Client/reviews_page.dart';
import 'package:housemasterapp/Pages/fullimagepage.dart';
import 'package:intl/intl.dart';

class ClientArtisanDetailsPage extends StatefulWidget {
  final String clientid;
  final String artisanid;
  final String name;
  final String image;
  final String occupation;
  final String startingamount;
  final String bio;
  final double averagerating;
  const ClientArtisanDetailsPage({
    super.key,
    required this.name,
    required this.image,
    required this.startingamount,
    required this.occupation,
    required this.averagerating,
    required this.clientid,
    required this.artisanid,
    required this.bio,
  });

  @override
  State<ClientArtisanDetailsPage> createState() =>
      _ClientArtisanDetailsPageState();
}

class _ClientArtisanDetailsPageState extends State<ClientArtisanDetailsPage> {
  final formatCurrency = NumberFormat.currency(symbol: " ");
  bool loading = false;

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                InkWell(
                  onTap: () {
                    Get.to(Fullimagepage(image: widget.image));
                  },
                  child: Container(
                    height: 0.30 * height,
                    width: width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AdvImageCache(widget.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
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
                                    color: Colors.white,
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
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 25.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.name,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Row(
                    children: [
                      Icon(Icons.star, size: 15, color: Colors.amber),
                      Icon(Icons.star, size: 15, color: Colors.amber),
                      Icon(
                        Icons.star_half_outlined,
                        size: 15,
                        color: Colors.amber,
                      ),
                      SizedBox(width: 10),
                      Text(
                        widget.averagerating.toStringAsFixed(1),
                        style: GoogleFonts.poppins(
                          color:
                              Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 25.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Starting from",
                    style: GoogleFonts.poppins(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  FutureBuilder<int?>(
                    future: getMinimumServiceAmount(widget.artisanid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(
                          "GHS ...",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data == null) {
                        return const Text(
                          "GHS 0",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        );
                      }

                      return Text(
                        "GHS ${formatCurrency.format(snapshot.data)}",
                        style: GoogleFonts.poppins(
                          color:
                              Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 20.0,
              ),
              child: Row(
                children: [
                  Text(
                    "About me",
                    style: GoogleFonts.poppins(
                      color: Colors.amber,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 20.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.bio,
                      style: GoogleFonts.poppins(
                        color: Theme.of(context).brightness == Brightness.light
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
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${widget.name}'s works",
                    style: GoogleFonts.poppins(
                      color: Colors.amber,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(Icons.swipe, color: Colors.amber),
                ],
              ),
            ),
            FadeInUp(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  top: 10.0,
                  right: 20.0,
                ),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("works")
                      .where("uid", isEqualTo: widget.artisanid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                        child: Container(
                          height: 0.25 * height,
                          width: width,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Portfolio is empty",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return snapshot.data!.docs.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(
                              top: 15.0,
                              bottom: 10.0,
                            ),
                            child: Container(
                              height: 0.25 * height,
                              width: width,
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.grey[400]
                                    : Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Portfolio is empty",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 0.25 * height,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Get.to(
                                      Fullimagepage(
                                        image:
                                            snapshot.data!.docs[index]["image"],
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
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
                                            borderRadius: BorderRadius.circular(
                                              5,
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
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Reviews",
                    style: GoogleFonts.poppins(
                      color: Colors.amber,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "",
                    style: GoogleFonts.poppins(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("reviews")
                  .where("artisanid", isEqualTo: widget.artisanid)
                  .limit(3)
                  .orderBy("datecreated", descending: true)
                  .snapshots(),
              builder: (context, asyncSnapshot) {
                if (!asyncSnapshot.hasData) {
                  return Container(
                    height: 0.25 * height,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            color: Colors.amber,
                            strokeWidth: 3,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Loading ${widget.name}'s reviews",
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

                return asyncSnapshot.data!.docs.isEmpty
                    ? Container(
                        height: 0.25 * height,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.circle_outlined,
                              size: 50,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 20),
                            Text(
                              "${widget.name} has no review at the moment",
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
                      )
                    : Column(
                        children: [
                          ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: asyncSnapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              Timestamp timestamp = asyncSnapshot
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
                                                asyncSnapshot
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
                                                  usersnapshot.data?["name"],
                                                  style: GoogleFonts.poppins(
                                                    color:
                                                        Theme.of(
                                                              context,
                                                            ).brightness ==
                                                            Brightness.light
                                                        ? Colors.black
                                                        : Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
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
                                                Theme.of(context).brightness ==
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
                                            asyncSnapshot
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
                                    child: Divider(),
                                  );
                                },
                          ),
                          SizedBox(height: 15),
                          InkWell(
                            onTap: () {
                              Get.to(
                                () => ReviewsPage(
                                  reviews: asyncSnapshot.data!.docs,
                                ),
                              );
                            },
                            child: Text(
                              "Tap to view all reviews",
                              style: GoogleFonts.poppins(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.grey
                                    : Colors.amber,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      );
              },
            ),
            SizedBox(height: 30.0),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: FadeInUp(
          child: InkWell(
            onTap: () {
              Get.to(
                () => ConnectArtisanPage(
                  artisanid: widget.artisanid,
                  clientid: widget.clientid,
                  artisanname: widget.name,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                bottom: 15.0,
              ),
              child: Container(
                height: 0.060 * height,
                width: width,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(10),
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
                alignment: Alignment.center,
                child: loading
                    ? SizedBox(
                        height: 13,
                        width: 13,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 3,
                        ),
                      )
                    : Text(
                        "Connect with artisan",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> connectWithArtisan() async {
    try {
      setState(() {
        loading = true;
      });
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("connects")
          .doc();
      await documentReference
          .set({
            "id": documentReference.id,
            "clientid": widget.clientid,
            "artisanid": widget.artisanid,
            "datecreated": DateTime.now(),
            "daycreated": DateTime.now().day,
            "monthcreated": DateTime.now().month,
            "yearcreated": DateTime.now().year,
            "servicecharge": 0,
            "appservicecharge": 0,
            "status": "pending",
            "paid": false,
            "complete": false,
          })
          .then((value) {
            setState(() {
              loading = false;
            });
          });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }
}
