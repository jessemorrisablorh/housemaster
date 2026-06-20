import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemasterapp/Pages/Client/cancelled_tasks_page.dart';
import 'package:housemasterapp/Pages/Client/client_artisan_pending_tasks_page.dart';
import 'package:housemasterapp/Pages/Client/client_artsan_accepted_tasks_page.dart';
import 'package:housemasterapp/Pages/Client/completed_tasks_page.dart';

class ClientArtisanTasksPage extends StatefulWidget {
  const ClientArtisanTasksPage({super.key});

  @override
  State<ClientArtisanTasksPage> createState() => _ClientArtisanTasksPageState();
}

class _ClientArtisanTasksPageState extends State<ClientArtisanTasksPage> {
  User? user = FirebaseAuth.instance.currentUser;
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
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 10.0,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Tasks",
                          style: GoogleFonts.poppins(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    FadeInUp(
                      child: InkWell(
                        onTap: () {
                          Get.to(() => ClientArtisanPendingTasksPage());
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 30.0,
                            bottom: 20.0,
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
                                  Icons.remove,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.amber,
                                ),
                              ),
                              SizedBox(width: 15.0),
                              Expanded(
                                child: Text(
                                  "Pending tasks",
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
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("connects")
                                    .where("clientid", isEqualTo: user?.uid)
                                    .where("status", isEqualTo: "pending")
                                    .snapshots(),
                                builder: (context, asyncSnapshot) {
                                  if (!asyncSnapshot.hasData) {
                                    return Text(
                                      "0",
                                      style: GoogleFonts.poppins(
                                        color:
                                            Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.black
                                            : Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    );
                                  }
                                  return Text(
                                    "${asyncSnapshot.data!.docs.length}",
                                    style: GoogleFonts.poppins(
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    FadeInUp(
                      child: Divider(color: Colors.amber.withAlpha(110)),
                    ),
                    FadeInUp(
                      child: InkWell(
                        onTap: () {
                          Get.to(() => ClientArtsanAcceptedTasksPage());
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 30.0,
                            bottom: 20.0,
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
                              Expanded(
                                child: Text(
                                  "Accepted tasks",
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
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("connects")
                                    .where("clientid", isEqualTo: user?.uid)
                                    .where("status", isEqualTo: "accepted")
                                    .snapshots(),
                                builder: (context, asyncSnapshot) {
                                  if (!asyncSnapshot.hasData) {
                                    return Text(
                                      "0",
                                      style: GoogleFonts.poppins(
                                        color:
                                            Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.black
                                            : Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    );
                                  }
                                  return Text(
                                    "${asyncSnapshot.data!.docs.length}",
                                    style: GoogleFonts.poppins(
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    FadeInUp(
                      child: Divider(color: Colors.amber.withAlpha(110)),
                    ),
                    FadeInUp(
                      child: InkWell(
                        onTap: () {
                          Get.to(() => CompletedTasksPage());
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 20.0,
                            bottom: 20.0,
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
                                  Icons.check,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.amber,
                                ),
                              ),
                              SizedBox(width: 15.0),
                              Expanded(
                                child: Text(
                                  "Completed tasks",
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
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("connects")
                                    .where("clientid", isEqualTo: user?.uid)
                                    .where("status", isEqualTo: "completed")
                                    .snapshots(),
                                builder: (context, asyncSnapshot) {
                                  if (!asyncSnapshot.hasData) {
                                    return Text(
                                      "0",
                                      style: GoogleFonts.poppins(
                                        color:
                                            Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.black
                                            : Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    );
                                  }
                                  return Text(
                                    "${asyncSnapshot.data!.docs.length}",
                                    style: GoogleFonts.poppins(
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    FadeInUp(
                      child: Divider(color: Colors.amber.withAlpha(110)),
                    ),
                    FadeInUp(
                      child: InkWell(
                        onTap: () {
                          Get.to(() => CancelledTasksPage());
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 20.0,
                            bottom: 20.0,
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
                                  Icons.close,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.amber,
                                ),
                              ),
                              SizedBox(width: 15.0),
                              Expanded(
                                child: Text(
                                  "Cancelled tasks",
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
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("connects")
                                    .where("clientid", isEqualTo: user?.uid)
                                    .where("status", isEqualTo: "cancelled")
                                    .snapshots(),
                                builder: (context, asyncSnapshot) {
                                  if (!asyncSnapshot.hasData) {
                                    return Text(
                                      "0",
                                      style: GoogleFonts.poppins(
                                        color:
                                            Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.black
                                            : Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    );
                                  }
                                  return Text(
                                    "${asyncSnapshot.data!.docs.length}",
                                    style: GoogleFonts.poppins(
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
