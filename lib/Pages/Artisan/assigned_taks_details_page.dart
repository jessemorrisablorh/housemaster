// import 'package:adv_image_cache/adv_image_cache.dart';
// import 'package:animate_do/animate_do.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:url_launcher/url_launcher.dart';

// class AssignedTaksDetailsPage extends StatefulWidget {
//   final String clientid;
//   final String clientname;
//   final String clientimage;
//   final double clientlat;
//   final double clientlng;
//   final String clientlocationname;
//   final String connectid;
//   final List serives;
//   final num totalcharge;
//   String status;
//   AssignedTaksDetailsPage({
//     super.key,
//     required this.clientid,
//     required this.connectid,
//     required this.serives,
//     required this.totalcharge,
//     required this.clientname,
//     required this.clientimage,
//     required this.clientlat,
//     required this.clientlng,
//     required this.clientlocationname,
//     required this.status,
//   });

//   @override
//   State<AssignedTaksDetailsPage> createState() =>
//       _AssignedTaksDetailsPageState();
// }

// class _AssignedTaksDetailsPageState extends State<AssignedTaksDetailsPage> {
//   final formatCurrency = NumberFormat.currency(symbol: " ");
//   bool loading = false;
//   bool started = false;
//   bool hidedirections = false;
//   bool showstartingnow = false;
//   bool showgetstarted = false;
//   bool completework = false;
//   TextEditingController fourpin = TextEditingController();
//   String randomNumber = "----";

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return StreamBuilder(
//       stream: FirebaseFirestore.instance
//           .collection("connects")
//           .doc(widget.connectid)
//           .snapshots(),
//       builder: (context, asyncSnapshot) {
//         if (!asyncSnapshot.hasData) {
//           return Scaffold(backgroundColor: Colors.grey[900]);
//         }
//         return Scaffold(
//           backgroundColor: Colors.grey[900],
//           body: Column(
//             children: [
//               SafeArea(
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                     left: 20.0,
//                     top: 20.0,
//                     right: 20.0,
//                   ),
//                   child: InkWell(
//                     onTap: () {
//                       Get.back();
//                     },
//                     child: Row(
//                       children: [
//                         Container(
//                           height: 0.060 * height,
//                           width: 0.40 * width,
//                           decoration: BoxDecoration(
//                             color: Colors.amber.withAlpha(60),
//                             borderRadius: BorderRadius.circular(25),
//                           ),
//                           child: Row(
//                             children: [
//                               SlideInRight(
//                                 duration: Duration(milliseconds: 900),
//                                 child: Container(
//                                   height: 0.060 * height,
//                                   width: 0.14 * width,
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Colors.amber,
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(15.0),
//                                     child: Icon(Icons.arrow_back),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 15),
//                               Text(
//                                 "Back",
//                                 style: GoogleFonts.poppins(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 13,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(
//                           left: 20.0,
//                           right: 20.0,
//                           top: 20.0,
//                         ),
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Text(
//                                   "Client details",
//                                   style: GoogleFonts.poppins(
//                                     color: Colors.amber,
//                                     fontSize: 13,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 15),
//                             Container(
//                               height: 0.30 * height,
//                               width: width,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(10),
//                                 image: DecorationImage(
//                                   image: widget.clientimage == ""
//                                       ? AssetImage("images/empty.jpg")
//                                       : AdvImageCache(widget.clientimage),
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               alignment: Alignment.bottomCenter,
//                               child: Container(
//                                 height: 0.10 * height,
//                                 width: width,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.only(
//                                     bottomLeft: Radius.circular(10),
//                                     bottomRight: Radius.circular(10),
//                                   ),
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(
//                                     left: 20.0,
//                                     right: 20.0,
//                                   ),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "${widget.clientname.toString().capitalizeFirst}",
//                                         overflow: TextOverflow.ellipsis,
//                                         style: GoogleFonts.poppins(
//                                           color: Colors.black,
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                       SizedBox(height: 10),
//                                       Row(
//                                         children: [
//                                           Icon(
//                                             Icons.location_on,
//                                             color: Colors.amber,
//                                             size: 14,
//                                           ),
//                                           SizedBox(width: 10),
//                                           Text(
//                                             widget.clientlocationname,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: GoogleFonts.poppins(
//                                               color: Colors.black,
//                                               fontSize: 13,
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(
//                           left: 20.0,
//                           right: 20.0,
//                           top: 30.0,
//                         ),
//                         child: Row(
//                           children: [
//                             Text(
//                               "Services",
//                               style: GoogleFonts.poppins(
//                                 color: Colors.amber,
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20.0, right: 20.0),
//                         child: ListView.separated(
//                           shrinkWrap: true,
//                           physics: NeverScrollableScrollPhysics(),
//                           itemCount: widget.serives.length,
//                           itemBuilder: (context, index) {
//                             return Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   widget.serives[index]["service"],
//                                   style: GoogleFonts.poppins(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 SizedBox(height: 8.0),
//                                 Text(
//                                   "GHS ${formatCurrency.format(widget.serives[index]["amount"])}",
//                                   style: GoogleFonts.poppins(
//                                     color: Colors.amber,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             );
//                           },
//                           separatorBuilder: (BuildContext context, int index) {
//                             return Divider(color: Colors.grey);
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           bottomNavigationBar: FadeInUp(
//             child: SizedBox(
//               height: 0.35 * height,
//               width: width,
//               child: Column(
//                 //   mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(
//                       left: 20.0,
//                       right: 20.0,
//                       top: 30.0,
//                       bottom: 15.0,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Total",
//                           style: GoogleFonts.poppins(
//                             color: Colors.white,
//                             fontSize: 13,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         Text(
//                           "GHS ${formatCurrency.format(widget.totalcharge)}",
//                           style: GoogleFonts.poppins(
//                             color: Colors.amber,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   Container(
//                     height: 0.27 * height,
//                     width: width,
//                     decoration: BoxDecoration(
//                       color: Colors.transparent,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(10),
//                         topRight: Radius.circular(10),
//                       ),
//                     ),
//                     child: widget.status == "pending"
//                         ? SafeArea(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(
//                                     left: 20.0,
//                                     right: 20.0,
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       InkWell(
//                                         onTap: () {
//                                           Get.dialog(
//                                             barrierDismissible: false,
//                                             StatefulBuilder(
//                                               builder: (context, setState) {
//                                                 return AlertDialog(
//                                                   backgroundColor:
//                                                       Colors.grey[900],
//                                                   title: Column(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .center,
//                                                     children: [
//                                                       SizedBox(height: 30),
//                                                       Icon(
//                                                         Icons.check,
//                                                         color: Colors.amber,
//                                                         size: 85,
//                                                       ),
//                                                       SizedBox(height: 20),
//                                                       Text(
//                                                         "Accepting this task will make you gain\nGHS ${formatCurrency.format(widget.totalcharge)}, that's some cool cash",
//                                                         textAlign:
//                                                             TextAlign.center,
//                                                         style:
//                                                             GoogleFonts.poppins(
//                                                               color:
//                                                                   Colors.white,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w600,
//                                                               fontSize: 12,
//                                                             ),
//                                                       ),
//                                                       SizedBox(height: 20),
//                                                       InkWell(
//                                                         onTap: () async {
//                                                           await acceptTask();
//                                                         },
//                                                         child: Container(
//                                                           height:
//                                                               0.060 * height,
//                                                           width: width,
//                                                           decoration: BoxDecoration(
//                                                             color: Colors.green,
//                                                             borderRadius:
//                                                                 BorderRadius.circular(
//                                                                   10,
//                                                                 ),
//                                                             boxShadow: [
//                                                               BoxShadow(
//                                                                 color: Colors
//                                                                     .black26,
//                                                                 blurRadius: 7,
//                                                                 offset: Offset(
//                                                                   1,
//                                                                   2,
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           alignment:
//                                                               Alignment.center,
//                                                           child: loading
//                                                               ? SizedBox(
//                                                                   height: 13,
//                                                                   width: 13,
//                                                                   child: CircularProgressIndicator(
//                                                                     color: Colors
//                                                                         .white,
//                                                                     strokeWidth:
//                                                                         3,
//                                                                   ),
//                                                                 )
//                                                               : Text(
//                                                                   "Accept task",
//                                                                   style: GoogleFonts.poppins(
//                                                                     color: Colors
//                                                                         .white,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .w600,
//                                                                     fontSize:
//                                                                         12,
//                                                                   ),
//                                                                 ),
//                                                         ),
//                                                       ),
//                                                       SizedBox(height: 20),
//                                                       InkWell(
//                                                         onTap: () {
//                                                           Get.close(1);
//                                                         },
//                                                         child: Text(
//                                                           "Close",
//                                                           style:
//                                                               GoogleFonts.poppins(
//                                                                 color:
//                                                                     Colors.red,
//                                                                 fontSize: 12,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w600,
//                                                               ),
//                                                         ),
//                                                       ),
//                                                       SizedBox(height: 30),
//                                                     ],
//                                                   ),
//                                                 );
//                                               },
//                                             ),
//                                           );
//                                         },
//                                         child: Column(
//                                           children: [
//                                             Container(
//                                               height: 0.070 * height,
//                                               width: 0.20 * width,
//                                               decoration: BoxDecoration(
//                                                 color: Colors.green,
//                                                 shape: BoxShape.circle,
//                                               ),
//                                               child: Icon(
//                                                 Icons.check,
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                             SizedBox(height: 10),
//                                             Text(
//                                               "Accept task",
//                                               style: GoogleFonts.poppins(
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.w700,
//                                                 fontSize: 13,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       InkWell(
//                                         onTap: () {
//                                           Get.dialog(
//                                             barrierDismissible: false,
//                                             StatefulBuilder(
//                                               builder: (context, setState) {
//                                                 return AlertDialog(
//                                                   backgroundColor:
//                                                       Colors.grey[900],
//                                                   title: Column(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .center,
//                                                     children: [
//                                                       SizedBox(height: 30),
//                                                       Icon(
//                                                         Icons.close,
//                                                         color: Colors.amber,
//                                                         size: 85,
//                                                       ),
//                                                       SizedBox(height: 20),
//                                                       Text(
//                                                         "Reject task this task will make you lose\nGHS ${formatCurrency.format(widget.totalcharge)}, do you still want to\nreject it?",
//                                                         textAlign:
//                                                             TextAlign.center,
//                                                         style:
//                                                             GoogleFonts.poppins(
//                                                               color:
//                                                                   Colors.white,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w600,
//                                                               fontSize: 12,
//                                                             ),
//                                                       ),
//                                                       SizedBox(height: 20),
//                                                       InkWell(
//                                                         onTap: () async {
//                                                           await cancelTask();
//                                                         },
//                                                         child: Container(
//                                                           height:
//                                                               0.060 * height,
//                                                           width: width,
//                                                           decoration: BoxDecoration(
//                                                             color: Colors.red,
//                                                             borderRadius:
//                                                                 BorderRadius.circular(
//                                                                   10,
//                                                                 ),
//                                                             boxShadow: [
//                                                               BoxShadow(
//                                                                 color: Colors
//                                                                     .black26,
//                                                                 blurRadius: 7,
//                                                                 offset: Offset(
//                                                                   1,
//                                                                   2,
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           alignment:
//                                                               Alignment.center,
//                                                           child: loading
//                                                               ? SizedBox(
//                                                                   height: 13,
//                                                                   width: 13,
//                                                                   child: CircularProgressIndicator(
//                                                                     color: Colors
//                                                                         .white,
//                                                                     strokeWidth:
//                                                                         3,
//                                                                   ),
//                                                                 )
//                                                               : Text(
//                                                                   "Reject task",
//                                                                   style: GoogleFonts.poppins(
//                                                                     color: Colors
//                                                                         .white,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .w600,
//                                                                     fontSize:
//                                                                         12,
//                                                                   ),
//                                                                 ),
//                                                         ),
//                                                       ),
//                                                       SizedBox(height: 20),
//                                                       InkWell(
//                                                         onTap: () {
//                                                           Get.close(1);
//                                                         },
//                                                         child: Text(
//                                                           "Close",
//                                                           style:
//                                                               GoogleFonts.poppins(
//                                                                 color:
//                                                                     Colors.red,
//                                                                 fontSize: 12,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w600,
//                                                               ),
//                                                         ),
//                                                       ),
//                                                       SizedBox(height: 30),
//                                                     ],
//                                                   ),
//                                                 );
//                                               },
//                                             ),
//                                           );
//                                         },
//                                         child: Column(
//                                           children: [
//                                             Container(
//                                               height: 0.070 * height,
//                                               width: 0.20 * width,
//                                               decoration: BoxDecoration(
//                                                 color: Colors.red,
//                                                 shape: BoxShape.circle,
//                                               ),
//                                               child: Icon(
//                                                 Icons.close,
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                             SizedBox(height: 10),
//                                             Text(
//                                               "Reject task",
//                                               style: GoogleFonts.poppins(
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.w700,
//                                                 fontSize: 13,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         : SafeArea(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 // InkWell(
//                                 //   onTap: () {
//                                 //     openGoogleMaps(
//                                 //       widget.clientlat,
//                                 //       widget.clientlng,
//                                 //     );
//                                 //   },
//                                 //   child: Padding(
//                                 //     padding: const EdgeInsets.only(
//                                 //       left: 20.0,
//                                 //       right: 20.0,
//                                 //     ),
//                                 //     child: Container(
//                                 //       height: 0.060 * height,
//                                 //       width: width,
//                                 //       decoration: BoxDecoration(
//                                 //         color: Colors.green,
//                                 //         borderRadius: BorderRadius.circular(10),
//                                 //         boxShadow: [
//                                 //           BoxShadow(
//                                 //             color: Colors.black26,
//                                 //             blurRadius: 7,
//                                 //             offset: Offset(1, 2),
//                                 //           ),
//                                 //         ],
//                                 //       ),
//                                 //       alignment: Alignment.center,
//                                 //       child: Text(
//                                 //         "Get directions to client's loocation",
//                                 //         style: GoogleFonts.poppins(
//                                 //           color: Colors.black,
//                                 //           fontSize: 13,
//                                 //           fontWeight: FontWeight.w600,
//                                 //         ),
//                                 //       ),
//                                 //     ),
//                                 //   ),
//                                 // ),
//                                 if (showgetstarted == false)
//                                   InkWell(
//                                     onTap: () {
//                                       Get.dialog(
//                                         barrierDismissible: false,
//                                         StatefulBuilder(
//                                           builder: (context, setState) {
//                                             return AlertDialog(
//                                               backgroundColor: Colors.grey[900],
//                                               title: Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.center,
//                                                 children: [
//                                                   SizedBox(height: 30),
//                                                   Icon(
//                                                     Icons.directions,
//                                                     color: Colors.amber,
//                                                     size: 85,
//                                                   ),
//                                                   SizedBox(height: 20),
//                                                   Text(
//                                                     "Get dirctions to client's location",
//                                                     textAlign: TextAlign.center,
//                                                     style: GoogleFonts.poppins(
//                                                       color: Colors.white,
//                                                       fontWeight:
//                                                           FontWeight.w700,
//                                                       fontSize: 13,
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: 10),
//                                                   Text(
//                                                     "Tap on the button below to get directions to client's location",
//                                                     textAlign: TextAlign.center,
//                                                     style: GoogleFonts.poppins(
//                                                       color: Colors.white,
//                                                       fontWeight:
//                                                           FontWeight.w600,
//                                                       fontSize: 12,
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: 20),
//                                                   InkWell(
//                                                     onTap: () async {
//                                                       await updateToHeading();
//                                                       openGoogleMaps(
//                                                         widget.clientlat,
//                                                         widget.clientlng,
//                                                       );
//                                                     },
//                                                     child: Container(
//                                                       height: 0.060 * height,
//                                                       width: width,
//                                                       decoration: BoxDecoration(
//                                                         color: Colors.amber,
//                                                         borderRadius:
//                                                             BorderRadius.circular(
//                                                               10,
//                                                             ),
//                                                         boxShadow: [
//                                                           BoxShadow(
//                                                             color:
//                                                                 Colors.black26,
//                                                             blurRadius: 7,
//                                                             offset: Offset(
//                                                               1,
//                                                               2,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       alignment:
//                                                           Alignment.center,
//                                                       child: loading
//                                                           ? SizedBox(
//                                                               height: 13,
//                                                               width: 13,
//                                                               child:
//                                                                   CircularProgressIndicator(
//                                                                     color: Colors
//                                                                         .white,
//                                                                     strokeWidth:
//                                                                         3,
//                                                                   ),
//                                                             )
//                                                           : Text(
//                                                               "Get derections",
//                                                               style: GoogleFonts.poppins(
//                                                                 color: Colors
//                                                                     .black,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w700,
//                                                                 fontSize: 12,
//                                                               ),
//                                                             ),
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: 20),
//                                                   InkWell(
//                                                     onTap: () {
//                                                       Get.close(1);
//                                                     },
//                                                     child: Text(
//                                                       "Close",
//                                                       style:
//                                                           GoogleFonts.poppins(
//                                                             color: Colors.red,
//                                                             fontSize: 12,
//                                                             fontWeight:
//                                                                 FontWeight.w600,
//                                                           ),
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: 30),
//                                                 ],
//                                               ),
//                                             );
//                                           },
//                                         ),
//                                       );
//                                     },
//                                     child: Padding(
//                                       padding: const EdgeInsets.only(
//                                         left: 35.0,
//                                         right: 35.0,
//                                         top: 10.0,
//                                       ),
//                                       child: Container(
//                                         height: 0.060 * height,
//                                         width: width,
//                                         decoration: BoxDecoration(
//                                           color: Colors.amber,
//                                           borderRadius: BorderRadius.circular(
//                                             10,
//                                           ),
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: Colors.black26,
//                                               blurRadius: 7,
//                                               offset: Offset(1, 2),
//                                             ),
//                                           ],
//                                         ),
//                                         alignment: Alignment.center,
//                                         child: Text(
//                                           "Get started",
//                                           style: GoogleFonts.poppins(
//                                             color: Colors.black,
//                                             fontSize: 13,
//                                             fontWeight: FontWeight.w700,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 if (hidedirections == true)
//                                   InkWell(
//                                     onTap: () {
//                                       Get.dialog(
//                                         barrierDismissible: false,
//                                         StatefulBuilder(
//                                           builder: (context, setState) {
//                                             return AlertDialog(
//                                               backgroundColor: Colors.grey[900],
//                                               title: Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.center,
//                                                 children: [
//                                                   SizedBox(height: 30),
//                                                   Icon(
//                                                     Icons.location_on,
//                                                     color: Colors.amber,
//                                                     size: 85,
//                                                   ),
//                                                   SizedBox(height: 20),

//                                                   Text(
//                                                     "Have you arrived at the client's location?",
//                                                     textAlign: TextAlign.center,
//                                                     style: GoogleFonts.poppins(
//                                                       color: Colors.white,
//                                                       fontWeight:
//                                                           FontWeight.w600,
//                                                       fontSize: 12,
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: 20),
//                                                   InkWell(
//                                                     onTap: () async {
//                                                       await updateToArrived();
//                                                     },
//                                                     child: Container(
//                                                       height: 0.060 * height,
//                                                       width: width,
//                                                       decoration: BoxDecoration(
//                                                         color: Colors.amber,
//                                                         borderRadius:
//                                                             BorderRadius.circular(
//                                                               10,
//                                                             ),
//                                                         boxShadow: [
//                                                           BoxShadow(
//                                                             color:
//                                                                 Colors.black26,
//                                                             blurRadius: 7,
//                                                             offset: Offset(
//                                                               1,
//                                                               2,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       alignment:
//                                                           Alignment.center,
//                                                       child: loading
//                                                           ? SizedBox(
//                                                               height: 13,
//                                                               width: 13,
//                                                               child:
//                                                                   CircularProgressIndicator(
//                                                                     color: Colors
//                                                                         .white,
//                                                                     strokeWidth:
//                                                                         3,
//                                                                   ),
//                                                             )
//                                                           : Text(
//                                                               "Yes, I have arrived",
//                                                               style: GoogleFonts.poppins(
//                                                                 color: Colors
//                                                                     .black,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w700,
//                                                                 fontSize: 12,
//                                                               ),
//                                                             ),
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: 20),
//                                                   InkWell(
//                                                     onTap: () {
//                                                       Get.close(1);
//                                                     },
//                                                     child: Text(
//                                                       "Close",
//                                                       style:
//                                                           GoogleFonts.poppins(
//                                                             color: Colors.red,
//                                                             fontSize: 12,
//                                                             fontWeight:
//                                                                 FontWeight.w600,
//                                                           ),
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: 30),
//                                                 ],
//                                               ),
//                                             );
//                                           },
//                                         ),
//                                       );
//                                     },
//                                     child: Padding(
//                                       padding: const EdgeInsets.only(
//                                         left: 30.0,
//                                         right: 30.0,
//                                         top: 15.0,
//                                       ),
//                                       child: Container(
//                                         height: 0.060 * height,
//                                         width: width,
//                                         decoration: BoxDecoration(
//                                           color: Colors.green,
//                                           borderRadius: BorderRadius.circular(
//                                             10,
//                                           ),
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: Colors.black26,
//                                               blurRadius: 7,
//                                               offset: Offset(1, 2),
//                                             ),
//                                           ],
//                                         ),
//                                         alignment: Alignment.center,
//                                         child: Text(
//                                           "I have arrived at the location",
//                                           style: GoogleFonts.poppins(
//                                             color: Colors.black,
//                                             fontSize: 13,
//                                             fontWeight: FontWeight.w700,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 if (showstartingnow == true)
//                                   InkWell(
//                                     onTap: () async {
//                                       Get.dialog(
//                                         barrierDismissible: false,
//                                         StatefulBuilder(
//                                           builder: (context, setState) {
//                                             return AlertDialog(
//                                               backgroundColor: Colors.grey[900],
//                                               title: Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.center,
//                                                 children: [
//                                                   SizedBox(height: 30),
//                                                   Icon(
//                                                     Icons.handshake,
//                                                     color: Colors.amber,
//                                                     size: 85,
//                                                   ),
//                                                   SizedBox(height: 20),
//                                                   Text(
//                                                     "Clients approval",
//                                                     textAlign: TextAlign.center,
//                                                     style: GoogleFonts.poppins(
//                                                       color: Colors.white,
//                                                       fontWeight:
//                                                           FontWeight.w700,
//                                                       fontSize: 13,
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: 10),
//                                                   Text(
//                                                     "Request and input the four digits code that appears on client's screen",
//                                                     textAlign: TextAlign.center,
//                                                     style: GoogleFonts.poppins(
//                                                       color: Colors.white,
//                                                       fontWeight:
//                                                           FontWeight.w600,
//                                                       fontSize: 12,
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: 20),
//                                                   Container(
//                                                     height: 0.060 * height,
//                                                     width: width,
//                                                     decoration: BoxDecoration(
//                                                       color: Colors.grey[600],
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                             10,
//                                                           ),
//                                                       boxShadow: [
//                                                         BoxShadow(
//                                                           color: Colors.black26,
//                                                           blurRadius: 7,
//                                                           offset: Offset(1, 2),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     child: Padding(
//                                                       padding:
//                                                           const EdgeInsets.only(
//                                                             left: 15.0,
//                                                             right: 15.0,
//                                                           ),
//                                                       child: TextField(
//                                                         style:
//                                                             GoogleFonts.poppins(
//                                                               color:
//                                                                   Colors.black,
//                                                               fontSize: 13,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w600,
//                                                             ),
//                                                         cursorColor:
//                                                             Colors.black,
//                                                         cursorErrorColor:
//                                                             Colors.black,
//                                                         cursorHeight: 13,
//                                                         controller: fourpin,
//                                                         keyboardType:
//                                                             TextInputType
//                                                                 .number,
//                                                         maxLength: 4,
//                                                         decoration:
//                                                             InputDecoration(
//                                                               border:
//                                                                   InputBorder
//                                                                       .none,
//                                                               counterStyle:
//                                                                   TextStyle(
//                                                                     fontSize:
//                                                                         0.01,
//                                                                   ),
//                                                             ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: 20),
//                                                   InkWell(
//                                                     onTap: () async {
//                                                       if (fourpin.text ==
//                                                           asyncSnapshot
//                                                               .data?["pin"]) {
//                                                         await updateToStarted();
//                                                       } else {
//                                                         Get.snackbar(
//                                                           "",
//                                                           "",
//                                                           backgroundColor:
//                                                               Colors.red,
//                                                           titleText: Text(
//                                                             "Error",
//                                                             style:
//                                                                 GoogleFonts.poppins(
//                                                                   color: Colors
//                                                                       .white,
//                                                                   fontSize: 13,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w600,
//                                                                 ),
//                                                           ),
//                                                           messageText: Text(
//                                                             "Invalid code",
//                                                             style:
//                                                                 GoogleFonts.poppins(
//                                                                   color: Colors
//                                                                       .white,
//                                                                   fontSize: 13,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w600,
//                                                                 ),
//                                                           ),
//                                                         );
//                                                       }
//                                                     },
//                                                     child: Container(
//                                                       height: 0.060 * height,
//                                                       width: width,
//                                                       decoration: BoxDecoration(
//                                                         color: Colors.amber,
//                                                         borderRadius:
//                                                             BorderRadius.circular(
//                                                               10,
//                                                             ),
//                                                         boxShadow: [
//                                                           BoxShadow(
//                                                             color:
//                                                                 Colors.black26,
//                                                             blurRadius: 7,
//                                                             offset: Offset(
//                                                               1,
//                                                               2,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       alignment:
//                                                           Alignment.center,
//                                                       child: loading
//                                                           ? SizedBox(
//                                                               height: 13,
//                                                               width: 13,
//                                                               child:
//                                                                   CircularProgressIndicator(
//                                                                     color: Colors
//                                                                         .white,
//                                                                     strokeWidth:
//                                                                         3,
//                                                                   ),
//                                                             )
//                                                           : Text(
//                                                               "Submit code",
//                                                               style: GoogleFonts.poppins(
//                                                                 color: Colors
//                                                                     .black,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w700,
//                                                                 fontSize: 12,
//                                                               ),
//                                                             ),
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: 20),
//                                                   InkWell(
//                                                     onTap: () {
//                                                       Get.close(1);
//                                                     },
//                                                     child: Text(
//                                                       "Close",
//                                                       style:
//                                                           GoogleFonts.poppins(
//                                                             color: Colors.red,
//                                                             fontSize: 12,
//                                                             fontWeight:
//                                                                 FontWeight.w600,
//                                                           ),
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: 30),
//                                                 ],
//                                               ),
//                                             );
//                                           },
//                                         ),
//                                       );
//                                     },
//                                     child: Padding(
//                                       padding: const EdgeInsets.only(
//                                         left: 35.0,
//                                         right: 35.0,
//                                         top: 10.0,
//                                       ),
//                                       child: Container(
//                                         height: 0.060 * height,
//                                         width: width,
//                                         decoration: BoxDecoration(
//                                           color: Colors.amber,
//                                           borderRadius: BorderRadius.circular(
//                                             10,
//                                           ),
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: Colors.black26,
//                                               blurRadius: 7,
//                                               offset: Offset(1, 2),
//                                             ),
//                                           ],
//                                         ),
//                                         alignment: Alignment.center,
//                                         child: Text(
//                                           "Starting client's work now",
//                                           style: GoogleFonts.poppins(
//                                             color: Colors.black,
//                                             fontSize: 13,
//                                             fontWeight: FontWeight.w700,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Future<void> acceptTask() async {
//     setState(() {
//       loading = true;
//     });
//     try {
//       await FirebaseFirestore.instance
//           .collection("connects")
//           .doc(widget.connectid)
//           .update({
//             "status": "accepted",
//             "pending": true,
//             "dateaccepted": DateTime.now(),
//           })
//           .then((value) {
//             setState(() {
//               loading = false;
//               widget.status = "accepted";
//             });
//             Get.close(1);
//           });
//     } catch (e) {
//       setState(() {
//         loading = false;
//       });
//       Get.snackbar(
//         "",
//         "",
//         backgroundColor: Colors.red,
//         titleText: Text(
//           "Error!",
//           style: GoogleFonts.poppins(
//             color: Colors.white,
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         messageText: Text(
//           "Try again later",
//           style: GoogleFonts.poppins(
//             color: Colors.white,
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       );
//     }
//   }

//   Future<void> cancelTask() async {
//     setState(() {
//       loading = true;
//     });
//     try {
//       await FirebaseFirestore.instance
//           .collection("connects")
//           .doc(widget.connectid)
//           .update({"status": "cancelled", "datecancelled": DateTime.now()})
//           .then((value) {
//             setState(() {
//               loading = false;
//             });
//             Get.close(1);
//             Get.back();
//           });
//     } catch (e) {
//       setState(() {
//         loading = false;
//       });
//       Get.snackbar(
//         "",
//         "",
//         backgroundColor: Colors.red,
//         titleText: Text(
//           "Error!",
//           style: GoogleFonts.poppins(
//             color: Colors.white,
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         messageText: Text(
//           "Try again later",
//           style: GoogleFonts.poppins(
//             color: Colors.white,
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       );
//     }
//   }

//   Future<void> openGoogleMaps(double lat, double lng) async {
//     final Uri googleMapsUrl = Uri.parse(
//       "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng",
//     );

//     await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
//   }

//   Future<void> updateToHeading() async {
//     try {
//       Get.close(1);
//       await FirebaseFirestore.instance
//           .collection("connects")
//           .doc(widget.connectid)
//           .update({"heading": true, "dateheading": DateTime.now()})
//           .then((value) {
//             setState(() {
//               hidedirections = true;
//               showgetstarted = true;
//             });
//           });
//     } catch (e) {
//       setState(() {
//         loading = false;
//       });
//       Get.snackbar(
//         "",
//         "",
//         backgroundColor: Colors.red,
//         titleText: Text(
//           "Error!",
//           style: GoogleFonts.poppins(
//             color: Colors.white,
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         messageText: Text(
//           "Try again later",
//           style: GoogleFonts.poppins(
//             color: Colors.white,
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       );
//     }
//   }

//   Future<void> updateToArrived() async {
//     try {
//       Get.close(1);
//       await FirebaseFirestore.instance
//           .collection("connects")
//           .doc(widget.connectid)
//           .update({"arrived": true, "datearrived": DateTime.now()})
//           .then((value) {
//             setState(() {
//               hidedirections = false;
//               showstartingnow = true;
//             });
//           });
//     } catch (e) {
//       setState(() {
//         loading = false;
//       });
//       Get.snackbar(
//         "",
//         "",
//         backgroundColor: Colors.red,
//         titleText: Text(
//           "Error!",
//           style: GoogleFonts.poppins(
//             color: Colors.white,
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         messageText: Text(
//           "Try again later",
//           style: GoogleFonts.poppins(
//             color: Colors.white,
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       );
//     }
//   }

//   Future<void> updateToStarted() async {
//     try {
//       Get.close(1);
//       await FirebaseFirestore.instance
//           .collection("connects")
//           .doc(widget.connectid)
//           .update({"started": true, "datestarted": DateTime.now()})
//           .then((value) {
//             setState(() {
//               hidedirections = false;
//               showstartingnow = true;
//             });
//           });
//     } catch (e) {
//       setState(() {
//         loading = false;
//       });
//       Get.snackbar(
//         "",
//         "",
//         backgroundColor: Colors.red,
//         titleText: Text(
//           "Error!",
//           style: GoogleFonts.poppins(
//             color: Colors.white,
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         messageText: Text(
//           "Try again later",
//           style: GoogleFonts.poppins(
//             color: Colors.white,
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       );
//     }
//   }
// }
