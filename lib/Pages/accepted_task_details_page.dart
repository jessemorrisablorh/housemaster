import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AcceptedTaskDetailsPage extends StatefulWidget {
  final String connectid;
  final String who;
  const AcceptedTaskDetailsPage({
    super.key,
    required this.connectid,
    required this.who,
  });

  @override
  State<AcceptedTaskDetailsPage> createState() =>
      _AcceptedTaskDetailsPageState();
}

class _AcceptedTaskDetailsPageState extends State<AcceptedTaskDetailsPage> {
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
          return Scaffold(backgroundColor: Colors.grey[900]);
        }
        Timestamp timestamp = asyncSnapshot.data?['dateaccepted'];
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
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Date accepted",
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
            child: FadeInUp(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: SizedBox(
                  height: 0.15 * height,
                  width: width,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                          top: 30.0,
                          bottom: 15.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total",
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
                              "GHS ${formatCurrency.format(asyncSnapshot.data?["artisanservicecharge"])}",
                              style: GoogleFonts.poppins(
                                color: Colors.amber,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: asyncSnapshot.data?["started"] == false,
                              child: InkWell(
                                onTap: () {
                                  Get.dialog(
                                    barrierDismissible: false,
                                    StatefulBuilder(
                                      builder: (context, setState) {
                                        return AlertDialog(
                                          backgroundColor: Colors.grey[900],
                                          title: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 30),
                                              Icon(
                                                Icons.directions,
                                                color: Colors.amber,
                                                size: 85,
                                              ),
                                              SizedBox(height: 20),
                                              Text(
                                                "Get dirctions to client's location",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                "Tap on the button below to get directions to client's location",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              InkWell(
                                                onTap: () async {
                                                  await updateToHeading();
                                                  openGoogleMaps(
                                                    asyncSnapshot
                                                        .data?["clientlat"],
                                                    asyncSnapshot
                                                        .data?["clientlng"],
                                                  );
                                                },
                                                child: Container(
                                                  height: 0.060 * height,
                                                  width: width,
                                                  decoration: BoxDecoration(
                                                    color: Colors.amber,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black26,
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
                                                          child:
                                                              CircularProgressIndicator(
                                                                color: Colors
                                                                    .black,
                                                                strokeWidth: 3,
                                                              ),
                                                        )
                                                      : Text(
                                                          "Get derections",
                                                          style:
                                                              GoogleFonts.poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 12,
                                                              ),
                                                        ),
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              InkWell(
                                                onTap: () {
                                                  Get.close(1);
                                                },
                                                child: Text(
                                                  "Close",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.red,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 30),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 35.0,
                                    right: 35.0,
                                    top: 10.0,
                                  ),
                                  child: Container(
                                    height: 0.060 * height,
                                    width: width,
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 7,
                                          offset: Offset(1, 2),
                                        ),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Get started",
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

                            Visibility(
                              visible:
                                  asyncSnapshot.data?["heading"] == true &&
                                  asyncSnapshot.data?["started"] == true &&
                                  asyncSnapshot.data?["arrived"] == false,
                              child: InkWell(
                                onTap: () {
                                  Get.dialog(
                                    barrierDismissible: false,
                                    StatefulBuilder(
                                      builder: (context, setState) {
                                        return AlertDialog(
                                          backgroundColor: Colors.grey[900],
                                          title: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 30),
                                              Icon(
                                                Icons.location_on,
                                                color: Colors.amber,
                                                size: 85,
                                              ),
                                              SizedBox(height: 20),

                                              Text(
                                                "Have you arrived at the client's location?",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              InkWell(
                                                onTap: () async {
                                                  await updateToArrived();
                                                },
                                                child: Container(
                                                  height: 0.060 * height,
                                                  width: width,
                                                  decoration: BoxDecoration(
                                                    color: Colors.amber,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black26,
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
                                                          child:
                                                              CircularProgressIndicator(
                                                                color: Colors
                                                                    .white,
                                                                strokeWidth: 3,
                                                              ),
                                                        )
                                                      : Text(
                                                          "Yes, I have arrived",
                                                          style:
                                                              GoogleFonts.poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 12,
                                                              ),
                                                        ),
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              InkWell(
                                                onTap: () {
                                                  Get.close(1);
                                                },
                                                child: Text(
                                                  "Close",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.red,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 30),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 30.0,
                                    right: 30.0,
                                    top: 15.0,
                                  ),
                                  child: Container(
                                    height: 0.060 * height,
                                    width: width,
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 7,
                                          offset: Offset(1, 2),
                                        ),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "I have arrived at the location",
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

                            Visibility(
                              visible:
                                  asyncSnapshot.data?["heading"] == true &&
                                  asyncSnapshot.data?["started"] == true &&
                                  asyncSnapshot.data?["arrived"] == true &&
                                  asyncSnapshot.data?["starting"] == false,
                              child: InkWell(
                                onTap: () async {
                                  Get.dialog(
                                    barrierDismissible: false,
                                    StatefulBuilder(
                                      builder: (context, setState) {
                                        return AlertDialog(
                                          backgroundColor: Colors.grey[900],
                                          title: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 30),
                                              Icon(
                                                Icons.handshake,
                                                color: Colors.amber,
                                                size: 85,
                                              ),
                                              SizedBox(height: 20),
                                              Text(
                                                "Clients approval",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                "Request and input the four digits code that appears on client's screen",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              Container(
                                                height: 0.060 * height,
                                                width: width,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[600],
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 7,
                                                      offset: Offset(1, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 15.0,
                                                        right: 15.0,
                                                      ),
                                                  child: TextField(
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    cursorColor: Colors.black,
                                                    cursorErrorColor:
                                                        Colors.black,
                                                    cursorHeight: 13,
                                                    controller: fourpin,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    maxLength: 4,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      counterStyle: TextStyle(
                                                        fontSize: 0.01,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              InkWell(
                                                onTap: () async {
                                                  if (fourpin.text ==
                                                      asyncSnapshot
                                                          .data?["pin"]) {
                                                    await updateToStarting();
                                                  } else {
                                                    Get.snackbar(
                                                      "",
                                                      "",
                                                      backgroundColor:
                                                          Colors.red,
                                                      titleText: Text(
                                                        "Error",
                                                        style:
                                                            GoogleFonts.poppins(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),
                                                      messageText: Text(
                                                        "Invalid code",
                                                        style:
                                                            GoogleFonts.poppins(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  height: 0.060 * height,
                                                  width: width,
                                                  decoration: BoxDecoration(
                                                    color: Colors.amber,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black26,
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
                                                          child:
                                                              CircularProgressIndicator(
                                                                color: Colors
                                                                    .white,
                                                                strokeWidth: 3,
                                                              ),
                                                        )
                                                      : Text(
                                                          "Submit code",
                                                          style:
                                                              GoogleFonts.poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 12,
                                                              ),
                                                        ),
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              InkWell(
                                                onTap: () {
                                                  Get.close(1);
                                                },
                                                child: Text(
                                                  "Close",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.red,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 30),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 35.0,
                                    right: 35.0,
                                    top: 10.0,
                                  ),
                                  child: Container(
                                    height: 0.060 * height,
                                    width: width,
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 7,
                                          offset: Offset(1, 2),
                                        ),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Starting client's work now",
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
                            Visibility(
                              visible:
                                  asyncSnapshot.data?["heading"] == true &&
                                  asyncSnapshot.data?["started"] == true &&
                                  asyncSnapshot.data?["arrived"] == true &&
                                  asyncSnapshot.data?["starting"] == true,
                              child: InkWell(
                                onTap: () async {
                                  if (asyncSnapshot.data?["complete"] ==
                                      false) {
                                    Get.dialog(
                                      barrierDismissible: false,
                                      StatefulBuilder(
                                        builder: (context, setState) {
                                          return AlertDialog(
                                            backgroundColor: Colors.grey[900],
                                            title: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(height: 30),
                                                Icon(
                                                  Icons.handshake,
                                                  color: Colors.amber,
                                                  size: 85,
                                                ),
                                                SizedBox(height: 20),
                                                Text(
                                                  "Complete work",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  "Are you done completely with with artisan's request?",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                InkWell(
                                                  onTap: () async {
                                                    await updateToComplete();
                                                  },
                                                  child: Container(
                                                    height: 0.060 * height,
                                                    width: width,
                                                    decoration: BoxDecoration(
                                                      color: Colors.amber,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black26,
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
                                                            child:
                                                                CircularProgressIndicator(
                                                                  color: Colors
                                                                      .white,
                                                                  strokeWidth:
                                                                      3,
                                                                ),
                                                          )
                                                        : Text(
                                                            "Yes, I'm done",
                                                            style:
                                                                GoogleFonts.poppins(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 12,
                                                                ),
                                                          ),
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                InkWell(
                                                  onTap: () {
                                                    Get.close(1);
                                                  },
                                                  child: Text(
                                                    "Close",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.red,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 30),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  } else {}
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 35.0,
                                    right: 35.0,
                                    top: 10.0,
                                  ),
                                  child: Container(
                                    height: 0.060 * height,
                                    width: width,
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 7,
                                          offset: Offset(1, 2),
                                        ),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      asyncSnapshot.data?["complete"] == true
                                          ? "Waiting for client's response"
                                          : "I'm done",
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton: Visibility(
            visible:
                asyncSnapshot.data?["heading"] == true &&
                asyncSnapshot.data?["started"] == true &&
                asyncSnapshot.data?["arrived"] == false,
            child: FloatingActionButton.extended(
              onPressed: () {
                openGoogleMaps(
                  asyncSnapshot.data?["clientlat"],
                  asyncSnapshot.data?["clientlng"],
                );
              },
              backgroundColor: Colors.amber,
              icon: Icon(Icons.directions, color: Colors.black, size: 30),
              label: Text(
                "Get directions",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> acceptTask() async {
    setState(() {
      loading = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection("connects")
          .doc(widget.connectid)
          .update({
            "status": "accepted",
            "pending": true,
            "dateaccepted": DateTime.now(),
          });
    } catch (e) {
      setState(() {
        loading = false;
      });
      Get.snackbar(
        "",
        "",
        backgroundColor: Colors.red,
        titleText: Text(
          "Error!",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        messageText: Text(
          "Try again later",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }

  Future<void> cancelTask() async {
    setState(() {
      loading = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection("connects")
          .doc(widget.connectid)
          .update({
            "status": "cancelled",
            "datecancelled": DateTime.now(),
            "cancelledby": widget.who,
          });
    } catch (e) {
      setState(() {
        loading = false;
      });
      Get.snackbar(
        "",
        "",
        backgroundColor: Colors.red,
        titleText: Text(
          "Error!",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        messageText: Text(
          "Try again later",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }

  Future<void> openGoogleMaps(double lat, double lng) async {
    final Uri googleMapsUrl = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng",
    );

    await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
  }

  Future<void> updateToHeading() async {
    try {
      Get.close(1);
      await FirebaseFirestore.instance
          .collection("connects")
          .doc(widget.connectid)
          .update({
            "started": true,
            "heading": true,
            "dateheading": DateTime.now(),
          });
    } catch (e) {
      setState(() {
        loading = false;
      });
      Get.snackbar(
        "",
        "",
        backgroundColor: Colors.red,
        titleText: Text(
          "Error!",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        messageText: Text(
          "Try again later",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }

  Future<void> updateToArrived() async {
    try {
      Get.close(1);
      await FirebaseFirestore.instance
          .collection("connects")
          .doc(widget.connectid)
          .update({"arrived": true, "datearrived": DateTime.now()});
    } catch (e) {
      setState(() {
        loading = false;
      });
      Get.snackbar(
        "",
        "",
        backgroundColor: Colors.red,
        titleText: Text(
          "Error!",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        messageText: Text(
          "Try again later",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }

  Future<void> updateToStarting() async {
    try {
      Get.close(1);
      await FirebaseFirestore.instance
          .collection("connects")
          .doc(widget.connectid)
          .update({"starting": true, "datestarting": DateTime.now()});
    } catch (e) {
      setState(() {
        loading = false;
      });
      Get.snackbar(
        "",
        "",
        backgroundColor: Colors.red,
        titleText: Text(
          "Error!",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        messageText: Text(
          "Try again later",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }

  Future<void> updateToComplete() async {
    try {
      await FirebaseFirestore.instance
          .collection("connects")
          .doc(widget.connectid)
          .update({"complete": true, "datecomplete": DateTime.now()})
          .then((value) {
            Get.close(1);
          });
    } catch (e) {
      setState(() {
        loading = false;
      });
      Get.snackbar(
        "",
        "",
        backgroundColor: Colors.red,
        titleText: Text(
          "Error!",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        messageText: Text(
          "Try again later",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }
}
