import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool loading = false;
  bool oldpassworderror = false;
  bool newpassworderror = false;
  String newpasswordtext = "New password";
  String oldpasswrdtext = "Old password";
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController oldpassword = TextEditingController();
  TextEditingController newpassword = TextEditingController();
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(user?.uid)
          .snapshots(),
      builder: (context, asyncSnapshot) {
        if (!asyncSnapshot.hasData) {
          return Scaffold(
            backgroundColor: Theme.of(context).brightness == Brightness.light
                ? Colors.grey[50]
                : Colors.grey[900],
          );
        }
        return Scaffold(
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.grey[50]
              : Colors.grey[900],
          body: Form(
            key: formkey,
            child: Column(
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
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Column(
                        children: [
                          FadeInUp(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 30.0),
                                  child: Text(
                                    "Old password",
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
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Container(
                              height: 0.060 * height,
                              width: width,
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.grey[300]
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 15.0,
                                  right: 15.0,
                                ),
                                child: TextFormField(
                                  onTap: () {
                                    if (oldpassworderror == true) {
                                      setState(() {
                                        oldpassworderror = false;
                                        oldpasswrdtext = "Old password";
                                      });
                                    }
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      setState(() {
                                        oldpassworderror = true;
                                        oldpassword.clear();
                                        oldpasswrdtext = "Required";
                                      });
                                      return "Required";
                                    } else {
                                      if (oldpassword.text !=
                                          asyncSnapshot.data?["password"]) {
                                        setState(() {
                                          oldpassworderror = true;
                                          oldpassword.clear();
                                          oldpasswrdtext = "Wrong password";
                                        });
                                        return "Wrong passsword";
                                      }
                                    }
                                    return null;
                                  },
                                  controller: oldpassword,
                                  style: GoogleFonts.poppins(
                                    color: oldpassworderror
                                        ? Colors.red
                                        : Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  cursorColor: Colors.black,
                                  cursorErrorColor: Colors.black,
                                  cursorHeight: 13,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: oldpasswrdtext,
                                    hintStyle: GoogleFonts.poppins(
                                      color: oldpassworderror
                                          ? Colors.red
                                          : Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    errorStyle: TextStyle(fontSize: 0.01),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          FadeInUp(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Text(
                                    "New password",
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
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Container(
                              height: 0.060 * height,
                              width: width,
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.grey[300]
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 15.0,
                                  right: 15.0,
                                ),
                                child: TextFormField(
                                  onTap: () {
                                    if (newpassworderror == true) {
                                      setState(() {
                                        newpassworderror = false;
                                        newpassword.clear();
                                        newpasswordtext = "New password";
                                      });
                                    }
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      setState(() {
                                        newpassworderror = true;
                                        newpassword.clear();
                                        newpasswordtext = "Required";
                                      });
                                      return "Required";
                                    } else {
                                      if (value.length <= 8) {
                                        setState(() {
                                          newpassworderror = true;
                                          newpassword.clear();
                                          newpasswordtext = "Weak password";
                                        });
                                        return "Weak password";
                                      }
                                    }
                                    return null;
                                  },
                                  controller: newpassword,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  cursorColor: Colors.black,
                                  cursorErrorColor: Colors.black,
                                  cursorHeight: 13,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: newpasswordtext,
                                    hintStyle: GoogleFonts.poppins(
                                      color: newpassworderror
                                          ? Colors.red
                                          : Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    errorStyle: TextStyle(fontSize: 0.01),
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
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: FadeInUp(
              child: InkWell(
                onTap: () async {
                  if (formkey.currentState!.validate()) {
                    await changePassword(
                      asyncSnapshot.data?["email"],
                      asyncSnapshot.data?["password"],
                      newpassword.text.trim(),
                    );
                  }
                },

                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    bottom: 10.0,
                  ),
                  child: Container(
                    height: 0.065 * height,
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Theme.of(context).brightness == Brightness.light
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
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.edit, color: Colors.black, size: 20),
                              SizedBox(width: 10),
                              Text(
                                "Change password",
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
            ),
          ),
        );
      },
    );
  }

  Future<void> changePassword(
    String email,
    String password,
    String newpassword,
  ) async {
    setState(() {
      loading = true;
    });
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
            FirebaseAuth.instance.currentUser!.updatePassword(newpassword).then(
              (value) {
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(user?.uid)
                    .update({"password": newpassword})
                    .then((value) {
                      setState(() {
                        loading = false;
                      });
                      Get.back();
                    });
              },
            );
          });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }
}
