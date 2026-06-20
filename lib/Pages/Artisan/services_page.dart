import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemasterapp/Pages/Artisan/add_new_service.dart';
import 'package:housemasterapp/Pages/Artisan/service_details.dart';
import 'package:housemasterapp/theme_controller.dart';
import 'package:intl/intl.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final ThemeController controller = Get.find();
  User? user = FirebaseAuth.instance.currentUser;
  final formatCurrency = NumberFormat.currency(symbol: " ");
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
                  FadeInUp(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20.0,
                            left: 20.0,
                            right: 20.0,
                            bottom: 10.0,
                          ),
                          child: Text(
                            "Services",
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
                      ],
                    ),
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("services")
                        .where("artisanid", isEqualTo: user?.uid)
                        .orderBy("servicename")
                        .snapshots(),
                    builder: (context, asyncsnapshot) {
                      if (!asyncsnapshot.hasData) {
                        return SizedBox();
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: asyncsnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return FadeInUp(
                            child: InkWell(
                              onTap: () {
                                Get.to(
                                  () => ServiceDetails(
                                    id: asyncsnapshot.data!.docs[index]["id"],
                                    servicename: asyncsnapshot
                                        .data!
                                        .docs[index]["servicename"],
                                    amount: asyncsnapshot
                                        .data!
                                        .docs[index]["amount"],
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  bottom: 5.0,
                                ),
                                child: Row(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          asyncsnapshot
                                              .data!
                                              .docs[index]["servicename"],
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
                                          "GHS ${formatCurrency.format(asyncsnapshot.data!.docs[index]["amount"])}",

                                          style: GoogleFonts.poppins(
                                            color: Colors.amber,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return FadeInUp(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                bottom: 10.0,
                                top: 10.0,
                              ),
                              child: Divider(
                                color: Colors.amber.withAlpha(110),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FadeInRight(
        child: FloatingActionButton.extended(
          icon: Icon(Icons.add, color: Colors.black),
          backgroundColor: Colors.amber,
          onPressed: () {
            Get.to(() => AddNewService());
          },
          label: Text(
            "Add new service",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
