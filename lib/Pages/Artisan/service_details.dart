import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemasterapp/theme_controller.dart';
import 'package:intl/intl.dart';

class ServiceDetails extends StatefulWidget {
  final String id;
  final String servicename;
  final int amount;
  const ServiceDetails({
    super.key,
    required this.id,
    required this.servicename,
    required this.amount,
  });

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  final ThemeController controller = Get.find();
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController serviceinfo = TextEditingController();
  TextEditingController servicecharge = TextEditingController();
  bool deleting = false;
  bool loading = false;
  String state = "read";
  final formatCurrency = NumberFormat.currency(symbol: " ");
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: state != "write",
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (state == "write") {
          setState(() {
            state = "read";
          });
        }
      },
      child: Scaffold(
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
                    if (state == "write") {
                      setState(() {
                        state = "read";
                      });
                    } else {
                      Get.back();
                    }
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
              child: state == "read"
                  ? SingleChildScrollView(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("services")
                            .doc(widget.id)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return SizedBox();
                          }
                          return FadeInUp(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 80.0,
                                    bottom: 30.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 0.11 * height,
                                        width: 0.25 * width,
                                        decoration: BoxDecoration(
                                          color:
                                              Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Colors.amber
                                              : Colors.amber.withAlpha(100),
                                          borderRadius: BorderRadius.circular(
                                            17,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 7,
                                              offset: Offset(1, 2),
                                            ),
                                          ],
                                          border: Border.all(
                                            color: Colors.amber,
                                            width: 2,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.workspaces_sharp,
                                          color:
                                              Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Colors.black
                                              : Colors.amber,
                                          size: 50,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 25.0,
                                    right: 25.0,
                                    top: 30.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Service",
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
                                    left: 25.0,
                                    right: 25.0,
                                    top: 5.0,
                                  ),
                                  child: Text(
                                    snapshot.data?["servicename"],
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
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 25.0,
                                    right: 25.0,
                                    top: 15.0,
                                  ),
                                  child: Text(
                                    "Price",
                                    style: GoogleFonts.poppins(
                                      color: Colors.amber,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 25.0,
                                    right: 25.0,
                                    top: 5.0,
                                  ),
                                  child: Text(
                                    "GHS ${formatCurrency.format(snapshot.data?["amount"])}",
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
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  : FadeInUp(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 80.0,
                              bottom: 30.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 0.090 * height,
                                  width: 0.22 * width,
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withAlpha(100),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.amber,
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.amber,
                                    size: 50,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  FadeInUp(
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20.0,
                                            top: 30.0,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Edit service",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 15,
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
                                        right: 20.0,
                                        top: 30.0,
                                      ),
                                      child: Container(
                                        height: 0.15 * height,
                                        width: width,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: TextField(
                                            controller: serviceinfo,
                                            maxLines: 20,
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            cursorHeight: 13,
                                            cursorColor: Colors.black,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: widget.servicename,

                                              hintStyle: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  FadeInUp(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20.0,
                                        right: 20.0,
                                        top: 15.0,
                                      ),
                                      child: Container(
                                        height: 0.060 * height,
                                        width: width,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                "GHS",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        bottom: 2,
                                                      ),
                                                  child: TextField(
                                                    controller: servicecharge,
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    cursorHeight: 13,
                                                    cursorColor: Colors.black,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText:
                                                          "${widget.amount}",

                                                      hintStyle:
                                                          GoogleFonts.poppins(
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  FadeInUp(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20.0,
                                        right: 20.0,
                                        top: 30.0,
                                      ),
                                      child: InkWell(
                                        onTap: () async {
                                          editService();
                                        },
                                        child: Container(
                                          height: 0.060 * height,
                                          width: width,
                                          decoration: BoxDecoration(
                                            color: Colors.amber,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
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
                                                  "Save service",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
        bottomNavigationBar: FadeInUp(
          child: Visibility(
            visible: state == "read",
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
                  height: 0.060 * height,
                  decoration: BoxDecoration(color: Colors.amber),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              state = "write";
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit, color: Colors.black, size: 20),
                              SizedBox(width: 10),
                              Text(
                                "Edit",
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
                      Container(
                        height: 0.030 * height,
                        width: 2,
                        color: Colors.grey[900],
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.dialog(
                              StatefulBuilder(
                                builder: (context, setState) {
                                  return Dialog(
                                    backgroundColor: Colors.grey[900],
                                    child: Container(
                                      width: width,
                                      height: 0.40 * height,
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 30),
                                          Container(
                                            height: 0.11 * height,
                                            width: 0.25 * width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.amber.withAlpha(
                                                100,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.delete_forever_outlined,
                                              color: Colors.amber,
                                              size: 45,
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Text(
                                            "Deleting selected service",
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          Text(
                                            "Do you want to proceed?",
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          InkWell(
                                            onTap: () async {
                                              if (deleting == false) {
                                                setState(() {
                                                  deleting = true;
                                                });
                                              }
                                              await deleteWork();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 20.0,
                                                right: 20.0,
                                              ),
                                              child: Container(
                                                height: 0.055 * height,
                                                width: width,
                                                decoration: BoxDecoration(
                                                  color: Colors.amber,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                alignment: Alignment.center,
                                                child: deleting
                                                    ? SizedBox(
                                                        height: 13,
                                                        width: 13,
                                                        child:
                                                            CircularProgressIndicator(
                                                              color:
                                                                  Colors.black,
                                                              strokeWidth: 3,
                                                            ),
                                                      )
                                                    : Text(
                                                        "Delete work image",
                                                        style:
                                                            GoogleFonts.poppins(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 30),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete, color: Colors.red, size: 20),
                              SizedBox(width: 10),
                              Text(
                                "Delete",
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> deleteWork() async {
    try {
      await FirebaseFirestore.instance
          .collection("services")
          .doc(widget.id)
          .delete()
          .then((value) {
            setState(() {
              deleting = false;
            });
            Get.close(1);
            Get.back();
          });
    } catch (e) {
      setState(() {
        deleting = false;
      });
      Get.snackbar(
        "",
        "",
        backgroundColor: Colors.red,
        titleText: Text(
          "Error!",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        messageText: Text(
          "Try again later",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }

  void editService() async {
    setState(() {
      loading = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection("services")
          .doc(widget.id)
          .update({
            "servicename": serviceinfo.text == ""
                ? widget.servicename
                : serviceinfo.text.trim(),
            "amount": servicecharge.text == ""
                ? widget.amount
                : int.parse(servicecharge.text),
          })
          .then((value) async {
            setState(() {
              state = "read";
              loading = false;
            });
          });
    } catch (e) {
      setState(() {
        loading = false;
      });
      Get.snackbar(
        "",
        "",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text(
          "Error!",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        messageText: Text(
          "Try again",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }
}
