import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String recipientcode = "";
  bool loading = false;
  Future<void> getRecipientCode() async {
    FirebaseFirestore.instance.collection("users").doc(user?.uid).get().then((
      value,
    ) {
      setState(() {
        recipientcode = value["recipient_code"];
      });
    });
  }

  final formatCurrency = NumberFormat.currency(symbol: " ");
  User? user = FirebaseAuth.instance.currentUser;
  String paymentmethod = "";
  String paymentchannel = "";
  Future<void> getPaymentDetails() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user?.uid)
        .get()
        .then((value) {
          setState(() {
            paymentmethod = value["paymentmethod"];
            paymentchannel = value["paymentchannel"];
          });
        });
  }

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
    getPaymentDetails();
    getRecipientCode();
    getPaymentApi();
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
          Column(
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
              if (paymentchannel != "" && paymentmethod != "")
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 20.0,
                  ),
                  child: Container(
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
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Payment method",
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            paymentmethod == ""
                                ? "N/A"
                                : paymentmethod == "momo"
                                ? "Mobile money"
                                : paymentmethod == "bank"
                                ? "Bank"
                                : " ",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Payment channel",
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            paymentchannel == "" ? "N/A" : paymentchannel,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("accounts")
                        .where("artisanid", isEqualTo: user?.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox();
                      }

                      return snapshot.data!.docs.isEmpty
                          ? FadeInUp(
                              child: Container(
                                height: 0.60 * height,
                                width: width,
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.circle_outlined,
                                      size: 85,
                                      color: Colors.amber,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "List is empty",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                              ),
                              child: ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  Timestamp timestamp =
                                      snapshot.data!.docs[index]['datecreated'];
                                  DateTime date = timestamp.toDate();
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Container(
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
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20.0,
                                          right: 20.0,
                                          top: 30.0,
                                          bottom: 30.0,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Date created",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Text(
                                                  "${date.day} - ${date.month} - ${date.year}",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Amount",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  "GHS ${formatCurrency.format(snapshot.data!.docs[index]["artisancharge"])}",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Service charge",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  "GHS ${formatCurrency.format(10 / 100 * snapshot.data!.docs[index]["artisancharge"])}",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Total amount",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  "GHS ${formatCurrency.format(snapshot.data!.docs[index]["artisancharge"] - (10 / 100 * snapshot.data!.docs[index]["artisancharge"]))}",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            Divider(),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 30.0,
                                                right: 30.0,
                                                top: 20.0,
                                              ),
                                              child: InkWell(
                                                onTap: () async {
                                                  try {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("accounts")
                                                        .doc(
                                                          snapshot
                                                              .data!
                                                              .docs[index]["id"],
                                                        )
                                                        .update({
                                                          "status":
                                                              "processing",
                                                        })
                                                        .then((value) async {
                                                          await sendFunds(
                                                            snapshot
                                                                    .data!
                                                                    .docs[index]["artisancharge"] -
                                                                (10 /
                                                                    100 *
                                                                    snapshot
                                                                        .data!
                                                                        .docs[index]["artisancharge"]),
                                                          );
                                                        });
                                                  } catch (e) {
                                                    setState(() {});
                                                  }
                                                },
                                                child: Container(
                                                  height: 0.060 * height,
                                                  width: width,
                                                  decoration: BoxDecoration(
                                                    color: Colors.amber,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black12,
                                                        blurRadius: 7,
                                                        offset: Offset(1, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    snapshot
                                                                .data!
                                                                .docs[index]["status"] ==
                                                            "pending"
                                                        ? "Withdraw"
                                                        : snapshot
                                                                  .data!
                                                                  .docs[index]["status"] ==
                                                              "processing"
                                                        ? "Processing payment"
                                                        : "Complete",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
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
      bottomNavigationBar: Visibility(
        visible: paymentmethod == "" && paymentchannel == "",
        child: SafeArea(
          child: Container(
            height: 0.10 * height,
            width: width,
            decoration: BoxDecoration(color: Colors.red),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Payment method is not set",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "You will not be able to make withrawals\nuntil payment method is set",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendFunds(double amount) async {
    try {
      setState(() {
        loading = true;
      });
      final response = await http.post(
        Uri.parse("https://api.paystack.co/transfer"),
        headers: {
          'Authorization': 'Bearer $paymentapi',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "source": "balance",
          "amount": amount * 100,
          "recipient": recipientcode,
          "reason": "Withdrawal",
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data["status"] == true) {
        String recipientcode = data["data"]["recipient_code"];
        int id = data["data"]["id"];
        int integration = data["data"]["integration"];

        setState(() {
          loading = false;
        });

        if (kDebugMode) {
          print("RECIPENT_CODE :: $recipientcode");
          print("ID: $id");
          print("INTEGRATION: $integration");
        }
      } else {
        Get.snackbar(
          "",
          "",
          backgroundColor: Colors.red,

          titleText: Text(
            "Payment error",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          messageText: Text(
            "${data["message"]}",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
        if (kDebugMode) {
          print("Error: ${data["message"]}");
        }
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }
}
