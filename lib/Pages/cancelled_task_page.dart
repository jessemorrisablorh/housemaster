import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CancelledTaskPage extends StatefulWidget {
  final String connectid;
  final String who;
  const CancelledTaskPage({
    super.key,
    required this.connectid,
    required this.who,
  });

  @override
  State<CancelledTaskPage> createState() => _CancelledTaskPageState();
}

class _CancelledTaskPageState extends State<CancelledTaskPage> {
  final formatCurrency = NumberFormat.currency(symbol: " ");
  bool loading = false;
  bool started = false;
  bool hidedirections = false;
  bool showstartingnow = false;
  bool showgetstarted = false;
  bool completework = false;
  TextEditingController fourpin = TextEditingController();
  String randomNumber = "----";
  String status = "pending";

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("connects")
          .doc(widget.connectid)
          .snapshots(),
      builder: (context, asyncSnapshot) {
        if (!asyncSnapshot.hasData) {
          return Scaffold(
            backgroundColor: Theme.of(context).brightness == Brightness.light
                ? Colors.grey[50]
                : Colors.grey[900],
          );
        }
        Timestamp timestamp = asyncSnapshot.data?['datecancelled'];
        DateTime date = timestamp.toDate();
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
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                          top: 20.0,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Date created",
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
                                Text(
                                  "${asyncSnapshot.data?["daycreated"]} - ${asyncSnapshot.data?["monthcreated"]} - ${asyncSnapshot.data?["yearcreated"]}",
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
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Date cancelled",
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
                                Text(
                                  "${date.day} - ${date.month} - ${date.year}",
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
                            SizedBox(height: 10.0),
                            Row(
                              children: [
                                Text(
                                  widget.who == "client"
                                      ? "Artisan details"
                                      : "Client details",
                                  style: GoogleFonts.poppins(
                                    color: Colors.amber,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Container(
                              height: 0.30 * height,
                              width: width,
                              decoration: BoxDecoration(
                                color: Colors.white,
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
                                image: widget.who == "client"
                                    ? DecorationImage(
                                        image:
                                            asyncSnapshot
                                                    .data?["artisanimage"] ==
                                                ""
                                            ? AssetImage("images/empty.jpg")
                                            : AdvImageCache(
                                                asyncSnapshot
                                                    .data?["artisanimage"],
                                              ),
                                        fit: BoxFit.cover,
                                      )
                                    : DecorationImage(
                                        image:
                                            asyncSnapshot
                                                    .data?["clientimage"] ==
                                                ""
                                            ? AssetImage("images/empty.jpg")
                                            : AdvImageCache(
                                                asyncSnapshot
                                                    .data?["clientimage"],
                                              ),

                                        fit: BoxFit.cover,
                                      ),
                              ),
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 0.10 * height,
                                width: width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.who == "client"
                                            ? "${asyncSnapshot.data?["artisanname"].toString().capitalizeFirst}"
                                            : "${asyncSnapshot.data?["clientname"].toString().capitalizeFirst}",
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: Colors.amber,
                                            size: 14,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            widget.who == "client"
                                                ? "${asyncSnapshot.data?["artisanplacename"].toString().capitalizeFirst}"
                                                : "${asyncSnapshot.data?["clientplacename"].toString().capitalizeFirst}",

                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
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
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                          top: 30.0,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Services",
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
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: asyncSnapshot.data?["services"].length,
                          itemBuilder: (context, index) {
                            return Row(
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
                                    borderRadius: BorderRadius.circular(10),
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
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      asyncSnapshot
                                          .data?["services"][index]["service"],
                                      style: GoogleFonts.poppins(
                                        color:
                                            Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.black
                                            : Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      "GHS ${formatCurrency.format(asyncSnapshot.data?["services"][index]["amount"])}",
                                      style: GoogleFonts.poppins(
                                        color: Colors.amber,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(color: Colors.grey);
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
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                bottom: 15.0,
              ),
              child: Row(
                children: [
                  Text(
                    "Cancelled by",
                    style: GoogleFonts.poppins(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: widget.who == "artisan"
                        ? Text(
                            asyncSnapshot.data?["cancelledby"] == "artisan"
                                ? "You"
                                : asyncSnapshot.data?["clientname"],
                            textAlign: TextAlign.end,
                            style: GoogleFonts.poppins(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        : Text(
                            asyncSnapshot.data?["cancelledby"] == "client"
                                ? "You"
                                : "${asyncSnapshot.data?["artisanname"]}",
                            textAlign: TextAlign.end,
                            style: GoogleFonts.poppins(
                              color:
                                  Theme.of(context).brightness ==
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
            ),
          ),
        );
      },
    );
  }
}
