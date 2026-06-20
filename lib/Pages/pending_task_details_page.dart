import 'dart:convert';

import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PendingTaskDetailsPage extends StatefulWidget {
  final String connectid;
  final String who;
  final String clientid;

  const PendingTaskDetailsPage({
    super.key,
    required this.connectid,
    required this.who,
    required this.clientid,
  });

  @override
  State<PendingTaskDetailsPage> createState() => _PendingTaskDetailsPageState();
}

class _PendingTaskDetailsPageState extends State<PendingTaskDetailsPage> {
  final formatCurrency = NumberFormat.currency(symbol: " ");
  bool loading = false;
  String status = "pending";
  String token = "";

  Future<void> getClientId() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.clientid)
        .get()
        .then((value) {
          setState(() {
            token = value["token"];
          });
        });
  }

  @override
  void initState() {
    super.initState();
    getClientId();
  }

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
                                    color: Colors.black26,
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
                            return Column(
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
          bottomNavigationBar: widget.who == "client"
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      bottom: 15.0,
                    ),
                    child: FadeInUp(
                      child: InkWell(
                        onTap: () {
                          Get.dialog(
                            barrierDismissible: false,
                            StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  backgroundColor:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Colors.grey[900],
                                  title: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 30),
                                      Icon(
                                        Icons.candlestick_chart_outlined,
                                        color: Colors.amber,
                                        size: 85,
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        "Cancel request",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Cancelling your request will change your request status and artisan will be notified",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          color:
                                              Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Colors.black
                                              : Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(height: 20),

                                      InkWell(
                                        onTap: () async {
                                          await cancelTask();
                                        },
                                        child: Container(
                                          height: 0.060 * height,
                                          width: width,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(
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
                                                        color: Colors.white,
                                                        strokeWidth: 3,
                                                      ),
                                                )
                                              : Text(
                                                  "Cancel request",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
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
                        child: Container(
                          height: 0.060 * height,
                          width: width,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Cancel request",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : FadeInUp(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: SizedBox(
                      height: 0.25 * height,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
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
                                                Icons.check,
                                                color: Colors.amber,
                                                size: 85,
                                              ),
                                              SizedBox(height: 20),
                                              Text(
                                                "Accepting this task will make you gain\nGHS ${formatCurrency.format(asyncSnapshot.data?["artisanservicecharge"])}, that's some cool cash",
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
                                                  await acceptTask();
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
                                                          "Accept task",
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
                                child: Column(
                                  children: [
                                    Container(
                                      height: 0.070 * height,
                                      width: 0.20 * width,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "Accept task",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
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
                                                Icons.close,
                                                color: Colors.amber,
                                                size: 85,
                                              ),
                                              SizedBox(height: 20),
                                              Text(
                                                "Reject task this task will make you lose\nGHS ${formatCurrency.format(asyncSnapshot.data?["artisanservicecharge"])}, do you still want to\nreject it?",
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
                                                  await cancelTask();
                                                },
                                                child: Container(
                                                  height: 0.060 * height,
                                                  width: width,
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
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
                                                          "Reject task",
                                                          style:
                                                              GoogleFonts.poppins(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
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
                                child: Column(
                                  children: [
                                    Container(
                                      height: 0.070 * height,
                                      width: 0.20 * width,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "Reject task",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
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
          })
          .then((value) async {
            setState(() {
              loading = false;
              status = "accepted";
            });
            await sendPushNotification(
              token,
              "Accepted request",
              "Artisan has accepted your request",
            );
            Get.close(1);
            Get.back();
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
          })
          .then((value) async {
            setState(() {
              loading = false;
            });
            await sendPushNotification(
              token,
              "Cancelled request",
              "Artisan has cancelled your request",
            );
            Get.close(1);
            Get.back();
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

  Future sendPushNotification(String token, String title, String body) async {
    const String serverKey = "YOUR_FIREBASE_SERVER_KEY";

    await http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "key=$serverKey",
      },
      body: jsonEncode({
        "to": token,
        "notification": {"title": title, "body": body},
        "data": {"click_action": "FLUTTER_NOTIFICATION_CLICK"},
      }),
    );
  }
}
