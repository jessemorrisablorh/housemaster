import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemasterapp/Pages/Client/client_home_page.dart';

class PaymentSuccessfulPage extends StatefulWidget {
  final String artisanid;
  const PaymentSuccessfulPage({super.key, required this.artisanid});

  @override
  State<PaymentSuccessfulPage> createState() => _PaymentSuccessfulPageState();
}

class _PaymentSuccessfulPageState extends State<PaymentSuccessfulPage> {
  double ratecount = 0;
  bool loading = false;
  bool reviewtext = false;
  TextEditingController review = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FadeInUp(
                  child: Container(
                    height: 0.15 * height,
                    width: 0.20 * width,
                    decoration: BoxDecoration(
                      color: Colors.amber.withAlpha(90),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, color: Colors.white, size: 50),
                  ),
                ),
                SizedBox(height: 10),
                FadeInUp(
                  child: Text(
                    "Payment successful",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 10),
                FadeInUp(
                  child: Text(
                    "Thank you for choosing the house master app",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                FadeInUp(
                  child: Text(
                    "Leave a review",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          ratecount = 1;
                        });
                      },
                      child: Icon(
                        Icons.star,
                        color: ratecount >= 1 ? Colors.amber : Colors.grey[500],
                        size: 40,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          ratecount = 2;
                        });
                      },
                      child: Icon(
                        Icons.star,
                        color: ratecount >= 2 ? Colors.amber : Colors.grey[500],
                        size: 40,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          ratecount = 3;
                        });
                      },
                      child: Icon(
                        Icons.star,
                        color: ratecount >= 3 ? Colors.amber : Colors.grey[500],
                        size: 40,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          ratecount = 4;
                        });
                      },
                      child: Icon(
                        Icons.star,
                        color: ratecount >= 4 ? Colors.amber : Colors.grey[500],
                        size: 40,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          ratecount = 5;
                        });
                      },
                      child: Icon(
                        Icons.star,
                        color: ratecount >= 5 ? Colors.amber : Colors.grey[500],
                        size: 40,
                      ),
                    ),
                  ],
                ),
                FadeInUp(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 25.0,
                      right: 25.0,
                      top: 20.0,
                    ),
                    child: Container(
                      height: 0.12 * height,
                      width: width,
                      decoration: BoxDecoration(
                        color: Colors.grey[500],
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 7,
                            offset: Offset(1, 2),
                          ),
                        ],
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextField(
                          controller: review,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          onChanged: (value) {
                            if (review.text != "") {
                              setState(() {
                                reviewtext = true;
                              });
                            } else {
                              setState(() {
                                reviewtext = false;
                              });
                            }
                          },
                          cursorColor: Colors.black,
                          cursorErrorColor: Colors.black,
                          cursorHeight: 13,
                          maxLines: 25,
                          decoration: InputDecoration(
                            hintText: "Give artisan a review",
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            border: InputBorder.none,
                            counterStyle: TextStyle(fontSize: 0.01),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                FadeInUp(
                  child: InkWell(
                    onTap: () async {
                      if (review.text.isNotEmpty && ratecount > 0) {
                        await giveReview();
                      } else {
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
                                      Icons.rate_review,
                                      color: Colors.amber,
                                      size: 85,
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      "Rating and comment is empty",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "You have not rated artisan and review is empty",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 20),

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
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 25.0,
                        right: 25.0,
                        top: 30.0,
                      ),
                      child: Container(
                        height: 0.060 * height,
                        width: width,
                        decoration: BoxDecoration(
                          color: reviewtext == false
                              ? Colors.grey[800]
                              : Colors.amber,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 7,
                              offset: Offset(1, 2),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Submit review",
                          style: GoogleFonts.poppins(
                            color: review.text.isEmpty
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Get.offAll(() => ClientHomePage());
                  },
                  child: Text(
                    "Skip review",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> alreadyRated() async {
    var result = await FirebaseFirestore.instance
        .collection("reviews")
        .where("artisanid", isEqualTo: widget.artisanid)
        .where("clientid", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .limit(1)
        .get();

    return result.docs.isNotEmpty;
  }

  Future<void> giveReview() async {
    setState(() {
      loading = true;
    });
    bool rated = await alreadyRated();

    if (rated) {
      Get.snackbar(
        "",
        "",
        backgroundColor: Colors.red,
        titleText: Text(
          "Already Rated",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        messageText: Text(
          "You have already rated this artisan",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
      return;
    }

    setState(() {
      loading = true;
    });
    try {
      await rateUser(ratecount);
      DocumentReference reviewsreference = FirebaseFirestore.instance
          .collection("reviews")
          .doc();
      await reviewsreference
          .set({
            "id": reviewsreference.id,
            "artisanid": widget.artisanid,
            "review": review.text.trim(),
            // "rating": ratecount,
            "clientid": FirebaseAuth.instance.currentUser?.uid,
            "datecreated": DateTime.now(),
          })
          .then((value) {
            setState(() {
              loading = false;
            });
            review.clear();
            Get.offAll(() => ClientHomePage());
          });
    } catch (e) {
      setState(() {
        loading = false;
      });
      print(e.toString());
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

  Future<void> rateUser(double rating) async {
    DocumentReference userRef = FirebaseFirestore.instance
        .collection("users")
        .doc(widget.artisanid);

    DocumentSnapshot doc = await userRef.get();

    double total = (doc['ratingTotal'] ?? 0).toDouble();
    int count = (doc['ratingCount'] ?? 0);

    double newTotal = total + rating;
    int newCount = count + 1;

    double average = newTotal / newCount;

    await userRef.update({
      "ratingTotal": newTotal,
      "ratingCount": newCount,
      "ratingAverage": average,
    });
  }
}
