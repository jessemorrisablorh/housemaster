import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemasterapp/theme_controller.dart';

class AddNewService extends StatefulWidget {
  const AddNewService({super.key});

  @override
  State<AddNewService> createState() => _AddNewServiceState();
}

class _AddNewServiceState extends State<AddNewService> {
  final ThemeController controller = Get.find();
  User? user = FirebaseAuth.instance.currentUser;
  bool loading = false;
  TextEditingController serviceinfo = TextEditingController();
  TextEditingController servicecharge = TextEditingController();
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
          Stack(
            children: [
              Container(
                width: width,
                height: 0.30 * height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/tools.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  width: width,
                  height: 0.30 * height,
                  color: Colors.black.withAlpha(190),
                ),
              ),
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
                                  color: Colors.white,
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
            ],
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FadeInUp(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Create a service",
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
                              SizedBox(height: 8.0),
                              Text(
                                "Tell the world what you do and how much you charge",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 12,
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
                          color:
                              Theme.of(context).brightness == Brightness.light
                              ? Colors.grey[200]
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(10),
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
                              hintText: "Service description",

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
                          color:
                              Theme.of(context).brightness == Brightness.light
                              ? Colors.grey[200]
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(10),
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
                                child: TextField(
                                  controller: servicecharge,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  cursorHeight: 13,
                                  cursorColor: Colors.black,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "0",

                                    hintStyle: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
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
                        onTap: () {
                          if (serviceinfo.text != "" &&
                              servicecharge.text != "") {
                            createService();
                          }
                        },
                        child: Container(
                          height: 0.060 * height,
                          width: width,
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(10),
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
    );
  }

  void createService() async {
    try {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("services")
          .doc();
      await documentReference
          .set({
            "id": documentReference.id,
            "artisanid": user?.uid,
            "servicename": serviceinfo.text.trim(),
            "amount": int.parse(servicecharge.text),
            "datecreated": DateTime.now(),
            "daycreated": DateTime.now().day,
            "monthcreated": DateTime.now().month,
            "yearcreated": DateTime.now().year,
          })
          .then((value) async {
            await FirebaseFirestore.instance
                .collection("users")
                .doc(user?.uid)
                .update({"addedservice": true})
                .then((value) {
                  Get.back();
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
