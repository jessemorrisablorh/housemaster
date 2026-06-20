import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemasterapp/Pages/Client/client_invoice_page.dart';
import 'package:intl/intl.dart';

class ConnectArtisanPage extends StatefulWidget {
  final String artisanid;
  final String clientid;
  final String artisanname;
  const ConnectArtisanPage({
    super.key,
    required this.artisanid,
    required this.clientid,
    required this.artisanname,
  });

  @override
  State<ConnectArtisanPage> createState() => _ConnectArtisanPageState();
}

class _ConnectArtisanPageState extends State<ConnectArtisanPage> {
  final formatCurrency = NumberFormat.currency(symbol: " ");
  bool loading = false;
  List selectedservice = [];
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
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 30.0),
                        child: Text(
                          "Services",
                          style: GoogleFonts.poppins(
                            color: Colors.amber,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("services")
                        .where("artisanid", isEqualTo: widget.artisanid)
                        .orderBy("servicename")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20.0,
                                    bottom: 5.0,
                                  ),
                                  child: Container(
                                    width: width,
                                    height: 0.080 * height,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20.0,
                              bottom: 5.0,
                            ),
                            child: FadeInUp(
                              child: InkWell(
                                onTap: () {
                                  final serviceName =
                                      snapshot.data!.docs[index]["servicename"];
                                  final amount =
                                      snapshot.data!.docs[index]["amount"];

                                  final alreadySelected = selectedservice.any(
                                    (item) => item["service"] == serviceName,
                                  );

                                  setState(() {
                                    if (alreadySelected) {
                                      selectedservice.removeWhere(
                                        (item) =>
                                            item["service"] == serviceName,
                                      );
                                    } else {
                                      selectedservice.add({
                                        "service": serviceName,
                                        "amount": amount,
                                      });
                                    }
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10.0,
                                    bottom: 10.0,
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
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
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
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot
                                                  .data!
                                                  .docs[index]["servicename"],
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
                                            SizedBox(height: 8),
                                            Text(
                                              "GHS ${formatCurrency.format(snapshot.data!.docs[index]["amount"])}",

                                              style: GoogleFonts.poppins(
                                                color: Colors.amber,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.check_box,
                                        size: 30,
                                        color:
                                            selectedservice.any(
                                              (item) =>
                                                  item["service"] ==
                                                  snapshot
                                                      .data!
                                                      .docs[index]["servicename"],
                                            )
                                            ? Colors.amber
                                            : Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // ),

                              // Container(
                              //   height: 0.06 * height,
                              //   width: width,
                              //   decoration: BoxDecoration(
                              //     color:
                              //         Theme.of(context).brightness ==
                              //             Brightness.light
                              //         ? Colors.white
                              //         : Colors.black,
                              //     boxShadow: [
                              //       BoxShadow(
                              //         color: Colors.black26,
                              //         blurRadius: 7,
                              //         offset: Offset(1, 2),
                              //       ),
                              //     ],
                              //   ),
                              //   alignment: Alignment.centerLeft,
                              //   child: Padding(
                              //     padding: const EdgeInsets.only(
                              //       left: 15.0,
                              //       right: 15.0,
                              //     ),
                              //     child: Text(
                              //       snapshot.data!.docs[index]["name"],
                              //       style: GoogleFonts.poppins(
                              //         fontSize: 13,
                              //         color:
                              //             Theme.of(context).brightness ==
                              //                 Brightness.light
                              //             ? Colors.black
                              //             : Colors.white,
                              //         fontWeight: FontWeight.w600,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return FadeInUp(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20.0,
                              ),
                              child: Divider(
                                color: Colors.amber.withAlpha(110),
                              ),
                            ),
                          );
                        },
                      );
                      // if (!snapshot.hasData) {
                      //   return Text("sljkncmsda");
                      // }
                      // return ListView.separated(
                      //   itemCount: snapshot.data!.docs.length,
                      //   shrinkWrap: true,
                      //   physics: NeverScrollableScrollPhysics(),
                      //   itemBuilder: (context, index) {
                      //     return FadeInUp(
                      //       child: InkWell(
                      //         onTap: () {
                      //           final serviceName =
                      //               snapshot.data!.docs[index]["servicename"];
                      //           final amount =
                      //               snapshot.data!.docs[index]["amount"];

                      //           final alreadySelected = selectedservice.any(
                      //             (item) => item["service"] == serviceName,
                      //           );

                      //           setState(() {
                      //             if (alreadySelected) {
                      //               selectedservice.removeWhere(
                      //                 (item) => item["service"] == serviceName,
                      //               );
                      //             } else {
                      //               selectedservice.add({
                      //                 "service": serviceName,
                      //                 "amount": amount,
                      //               });
                      //             }
                      //           });
                      //         },
                      //         child: Padding(
                      //           padding: const EdgeInsets.only(
                      //             left: 20.0,
                      //             right: 20.0,
                      //           ),
                      //           child: Row(
                      //             children: [
                      //               Expanded(
                      //                 child: Column(
                      //                   mainAxisAlignment:
                      //                       MainAxisAlignment.start,
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.start,
                      //                   children: [
                      //                     Text(
                      //                       snapshot
                      //                           .data!
                      //                           .docs[index]["servicename"],
                      //                       style: GoogleFonts.poppins(
                      //                         color:
                      //                             Theme.of(
                      //                                   context,
                      //                                 ).brightness ==
                      //                                 Brightness.light
                      //                             ? Colors.black
                      //                             : Colors.white,
                      //                         fontSize: 13,
                      //                         fontWeight: FontWeight.w600,
                      //                       ),
                      //                     ),
                      //                     SizedBox(height: 8),
                      //                     Text(
                      //                       "GHS ${formatCurrency.format(snapshot.data!.docs[index]["amount"])}",

                      //                       style: GoogleFonts.poppins(
                      //                         color: Colors.amber,
                      //                         fontSize: 13,
                      //                         fontWeight: FontWeight.w600,
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //               Icon(
                      //                 Icons.check_box,
                      //                 color:
                      //                     selectedservice.any(
                      //                       (item) =>
                      //                           item["service"] ==
                      //                           snapshot
                      //                               .data!
                      //                               .docs[index]["servicename"],
                      //                     )
                      //                     ? Colors.amber
                      //                     : Colors.grey,
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     );
                      //   },
                      //   separatorBuilder: (BuildContext context, int index) {
                      //     return FadeInUp(
                      //       child: Padding(
                      //         padding: const EdgeInsets.only(
                      //           left: 20.0,
                      //           right: 20.0,
                      //           bottom: 5.0,
                      //           top: 5.0,
                      //         ),
                      //         child: Divider(color: Colors.grey),
                      //       ),
                      //     );
                      //   },
                      // );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: FadeInUp(
          child: InkWell(
            onTap: () {
              if (selectedservice.isEmpty) {
                showModalBottomSheet(
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Colors.black,
                  context: context,
                  builder: (_) => SafeArea(
                    child: Container(
                      height: 0.25 * height,
                      width: width,
                      alignment: Alignment.center,
                      child: Wrap(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 0.15 * height,
                                width: 0.20 * width,
                                decoration: BoxDecoration(
                                  color: Colors.amber.withAlpha(90),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.list,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Select at least one service",

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
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                Get.to(
                  () => ClientInvoicePage(
                    clientid: widget.clientid,
                    artisanid: widget.artisanid,
                    services: selectedservice,
                    artisanname: widget.artisanname,
                  ),
                );
              }
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
                        "Proceed",
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
}
