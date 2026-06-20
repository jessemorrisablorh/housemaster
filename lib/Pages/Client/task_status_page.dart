import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemasterapp/Pages/payment.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class TaskStatusPage extends StatefulWidget {
  final String artisanid;
  final String taskid;
  const TaskStatusPage({
    super.key,
    required this.artisanid,
    required this.taskid,
  });

  @override
  State<TaskStatusPage> createState() => _TaskStatusPageState();
}

class _TaskStatusPageState extends State<TaskStatusPage> {
  bool loading = false;
  String paymentapi = "";
  Future<void> getPaymentApi() async {
    FirebaseFirestore.instance
        .collection("settings")
        .doc("paymentapi")
        .get()
        .then((value) {
          setState(() {
            paymentapi = value["testkey"];
          });
        });
  }

  @override
  void initState() {
    super.initState();
    getPaymentApi();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("connects")
          .doc(widget.taskid)
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
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Text(
                          "verification code",
                          style: GoogleFonts.poppins(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        asyncSnapshot.data?["pin"],
                        style: GoogleFonts.poppins(
                          color:
                              Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                          top: 20.0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                              top: 20.0,
                              bottom: 20.0,
                            ),
                            child: Text(
                              "Only give this code to the artisan when he/she is about starting work",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
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
                            Container(
                              height: 0.060 * height,
                              width: 0.10 * width,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,

                                color: asyncSnapshot.data?["pending"] == true
                                    ? Colors.amber.withAlpha(80)
                                    : Colors.grey.withAlpha(80),
                                border: Border.all(
                                  color: asyncSnapshot.data?["pending"] == true
                                      ? Colors.amber
                                      : Colors.grey,
                                  width: 3,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "1",
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
                            SizedBox(width: 20),
                            Expanded(
                              child: Container(
                                height: 0.090 * height,
                                width: width,
                                decoration: BoxDecoration(
                                  color: asyncSnapshot.data?["pending"] == true
                                      ? Colors.amber
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.centerLeft,
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
                                        "Artisan has accepted your request.",
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        "We'll update you when artisan is heading to your location",
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
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
                            Container(
                              height: 0.060 * height,
                              width: 0.10 * width,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: asyncSnapshot.data?["heading"] == true
                                    ? Colors.amber.withAlpha(80)
                                    : Colors.grey.withAlpha(80),
                                border: Border.all(
                                  color: asyncSnapshot.data?["heading"] == true
                                      ? Colors.amber
                                      : Colors.grey,
                                  width: 3,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "2",
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
                            SizedBox(width: 20),
                            Expanded(
                              child: Container(
                                height: 0.090 * height,
                                width: width,
                                decoration: BoxDecoration(
                                  color: asyncSnapshot.data?["heading"] == true
                                      ? Colors.amber
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.centerLeft,
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
                                        "Artisan is heading to your location.",
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        "Artisan will soon get to your location",
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
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
                            Container(
                              height: 0.060 * height,
                              width: 0.10 * width,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: asyncSnapshot.data?["arrived"] == true
                                    ? Colors.amber.withAlpha(80)
                                    : Colors.grey.withAlpha(80),
                                border: Border.all(
                                  color: asyncSnapshot.data?["arrived"] == true
                                      ? Colors.amber
                                      : Colors.grey,
                                  width: 3,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "3",
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
                            SizedBox(width: 20),
                            Expanded(
                              child: Container(
                                height: 0.090 * height,
                                width: width,
                                decoration: BoxDecoration(
                                  color: asyncSnapshot.data?["arrived"] == true
                                      ? Colors.amber
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.centerLeft,
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
                                        "Artisan has arrived at your location",
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        "Artisan is at your exact location",
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
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
                            Container(
                              height: 0.060 * height,
                              width: 0.10 * width,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: asyncSnapshot.data?["starting"] == true
                                    ? Colors.amber.withAlpha(80)
                                    : Colors.grey.withAlpha(80),
                                border: Border.all(
                                  color: asyncSnapshot.data?["starting"] == true
                                      ? Colors.amber
                                      : Colors.grey,
                                  width: 3,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "4",
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
                            SizedBox(width: 20),
                            Expanded(
                              child: Container(
                                height: 0.090 * height,
                                width: width,
                                decoration: BoxDecoration(
                                  color: asyncSnapshot.data?["starting"] == true
                                      ? Colors.amber
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.centerLeft,
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
                                        "Artisan has started working",
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        "Ensure artisan does the exact work you requested for",
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
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
                            Container(
                              height: 0.060 * height,
                              width: 0.10 * width,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: asyncSnapshot.data?["complete"] == true
                                    ? Colors.amber.withAlpha(80)
                                    : Colors.grey.withAlpha(80),
                                border: Border.all(
                                  color: asyncSnapshot.data?["complete"] == true
                                      ? Colors.amber
                                      : Colors.grey,
                                  width: 3,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "5",
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
                            SizedBox(width: 20),
                            Expanded(
                              child: Container(
                                height: 0.090 * height,
                                width: width,
                                decoration: BoxDecoration(
                                  color: asyncSnapshot.data?["complete"] == true
                                      ? Colors.amber
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.centerLeft,
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
                                        "Artisan has completed the task",
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        "Inspect the work to be sure you like it before confirming",
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),

          bottomNavigationBar:
              asyncSnapshot.data?["complete"] == true &&
                  asyncSnapshot.data?["completed"] == false &&
                  asyncSnapshot.data?["paid"] == false
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      bottom: 10.0,
                    ),
                    child: InkWell(
                      onTap: () {
                        Get.dialog(
                          barrierDismissible: false,
                          StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                backgroundColor: Colors.grey[900],
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 30),
                                    Icon(
                                      Icons.check_box,
                                      color: Colors.amber,
                                      size: 85,
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      "Artisan has completed",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "Inspect the work to be sure it's done properly before confirming.",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    InkWell(
                                      onTap: () async {
                                        if (loading == false) {
                                          setState(() {
                                            loading = true;
                                          });
                                        }
                                        Future<void> updateToCompleted() async {
                                          try {
                                            await FirebaseFirestore.instance
                                                .collection("connects")
                                                .doc(asyncSnapshot.data?["id"])
                                                .update({
                                                  "completed": true,
                                                  "datecompleted":
                                                      DateTime.now(),
                                                })
                                                .then((value) async {
                                                  Future<void>
                                                  makePayment() async {
                                                    setState(() {
                                                      loading = true;
                                                    });

                                                    var uuid = const Uuid();

                                                    try {
                                                      final response = await http.post(
                                                        Uri.parse(
                                                          'https://api.paystack.co/transaction/initialize',
                                                        ),
                                                        headers: {
                                                          'Authorization':
                                                              'Bearer $paymentapi',
                                                          'Content-Type':
                                                              'application/json',
                                                        },
                                                        body: jsonEncode({
                                                          "callback_url":
                                                              "https://google.com",
                                                          "email": FirebaseAuth
                                                              .instance
                                                              .currentUser
                                                              ?.email,
                                                          "amount":
                                                              asyncSnapshot
                                                                  .data?["totalcharge"] *
                                                              100, // Paystack uses kobo
                                                          "reference": uuid
                                                              .v4(),
                                                        }),
                                                      );

                                                      final data = jsonDecode(
                                                        response.body,
                                                      );

                                                      if (response.statusCode ==
                                                              200 &&
                                                          data["status"] ==
                                                              true) {
                                                        String
                                                        authorizationUrl =
                                                            data["data"]["authorization_url"];
                                                        String reference =
                                                            data["data"]["reference"];

                                                        setState(() {
                                                          loading = false;
                                                        });
                                                        Get.close(1);
                                                        Get.to(
                                                          () => Payment(
                                                            uid: FirebaseAuth
                                                                .instance
                                                                .currentUser
                                                                ?.uid,
                                                            link:
                                                                authorizationUrl,
                                                            references:
                                                                reference,
                                                            amount: asyncSnapshot
                                                                .data?["totalcharge"],
                                                            artisanid: asyncSnapshot
                                                                .data?["artisanid"],
                                                            connectid:
                                                                asyncSnapshot
                                                                    .data?["id"],
                                                            artisancharge:
                                                                asyncSnapshot
                                                                    .data?["artisanservicecharge"],
                                                          ),
                                                        );

                                                        if (kDebugMode) {
                                                          print(
                                                            "Payment URL: $authorizationUrl",
                                                          );
                                                          print(
                                                            "Reference: $reference",
                                                          );
                                                        }
                                                      } else {
                                                        setState(() {
                                                          loading = false;
                                                        });

                                                        if (kDebugMode) {
                                                          print(
                                                            "Error: ${data["message"]}",
                                                          );
                                                        }
                                                      }
                                                    } catch (e) {
                                                      setState(() {
                                                        loading = false;
                                                      });

                                                      if (kDebugMode) {
                                                        print("Exception: $e");
                                                      }
                                                    }
                                                  }

                                                  await makePayment();
                                                });
                                          } catch (e) {
                                            setState(() {});
                                          }
                                        }

                                        await updateToCompleted();
                                      },
                                      child: Container(
                                        height: 0.060 * height,
                                        width: width,
                                        decoration: BoxDecoration(
                                          color: Colors.amber,
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
                                                      color: Colors.black,
                                                      strokeWidth: 3,
                                                    ),
                                              )
                                            : Text(
                                                "Confirm",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
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
                          "Confirm complete work",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : asyncSnapshot.data?["complete"] == true &&
                    asyncSnapshot.data?["completed"] == true &&
                    asyncSnapshot.data?["paid"] == false
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      bottom: 10.0,
                    ),
                    child: InkWell(
                      onTap: () async {
                        Future<void> makePayment() async {
                          setState(() {
                            loading = true;
                          });

                          var uuid = const Uuid();

                          try {
                            final response = await http.post(
                              Uri.parse(
                                'https://api.paystack.co/transaction/initialize',
                              ),
                              headers: {
                                'Authorization': 'Bearer $paymentapi',
                                'Content-Type': 'application/json',
                              },
                              body: jsonEncode({
                                "callback_url": "https://google.com",
                                "email":
                                    FirebaseAuth.instance.currentUser?.email,
                                "amount":
                                    asyncSnapshot.data?["totalcharge"] *
                                    100, // Paystack uses kobo
                                "reference": uuid.v4(),
                              }),
                            );

                            final data = jsonDecode(response.body);

                            if (response.statusCode == 200 &&
                                data["status"] == true) {
                              String authorizationUrl =
                                  data["data"]["authorization_url"];
                              String reference = data["data"]["reference"];

                              setState(() {
                                loading = false;
                              });

                              Get.to(
                                () => Payment(
                                  uid: FirebaseAuth.instance.currentUser?.uid,
                                  link: authorizationUrl,
                                  references: reference,
                                  amount: asyncSnapshot.data?["totalcharge"],
                                  artisanid: asyncSnapshot.data?["artisanid"],
                                  connectid: asyncSnapshot.data?["id"],
                                  artisancharge: asyncSnapshot
                                      .data?["artisanservicecharge"],
                                ),
                              );

                              if (kDebugMode) {
                                print("Payment URL: $authorizationUrl");
                                print("Reference: $reference");
                              }
                            } else {
                              setState(() {
                                loading = false;
                              });

                              if (kDebugMode) {
                                print("Error: ${data["message"]}");
                              }
                            }
                          } catch (e) {
                            setState(() {
                              loading = false;
                            });

                            if (kDebugMode) {
                              print("Exception: $e");
                            }
                          }
                        }

                        await makePayment();
                      },
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
                          "Make payment",

                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox(),

          // Visibility(
          //   visible:
          //       asyncSnapshot.data?["complete"] == true &&
          //       asyncSnapshot.data?["completed"] == false &&
          //       asyncSnapshot.data?["paid"] == false,
          //   child: SafeArea(
          //     child: InkWell(
          //       onTap: () async {
          //         if (asyncSnapshot.data?["completed"] == true) {

          //         } else {

          //       },
          //       child: Padding(

          //         ),
          //         child: Container(
          //           height: 0.060 * height,
          //           width: width,
          //           decoration: BoxDecoration(
          //             color: Colors.amber,
          //             borderRadius: BorderRadius.circular(10),
          //           ),
          //           alignment: Alignment.center,
          //           child: Text(
          //             asyncSnapshot.data?["completed"]
          //                 ? "Make payment"
          //                 : "Confirm complete work",
          //             style: GoogleFonts.poppins(
          //               color: Colors.black,
          //               fontSize: 13,
          //               fontWeight: FontWeight.w700,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        );
      },
    );
  }
}
