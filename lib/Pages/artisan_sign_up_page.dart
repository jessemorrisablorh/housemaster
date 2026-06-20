import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemasterapp/Pages/screen_controller_page.dart';

class ArtisanSignUpPage extends StatefulWidget {
  const ArtisanSignUpPage({super.key});

  @override
  State<ArtisanSignUpPage> createState() => _ArtisanSignUpPageState();
}

class _ArtisanSignUpPageState extends State<ArtisanSignUpPage> {
  TextEditingController name = TextEditingController();
  TextEditingController phonenumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String nametext = "Name";
  String phonenumbertext = "Phone number";
  String emailtext = "Email";
  String passwordtext = "Password";
  String artisantext = "What do you do?";
  bool nameerror = false;
  bool phoneerror = false;
  bool emailerror = false;
  bool passworderror = false;
  bool artisanserror = false;
  bool loading = false;
  bool hidepassword = true;
  String? selectedArtisanId;
  String? selectedArtisanName;
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[50]
          : Colors.grey[900],
      body: Form(
        key: formkey,
        child: Stack(
          children: [
            Hero(
              tag: 'artisan',
              child: Container(
                height: 0.25 * height,
                width: width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/artisan.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  height: 0.25 * height,
                  width: width,
                  color: Colors.black26,
                ),
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 30.0),
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
                          color: Colors.amber.withAlpha(119),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            SlideInRight(
                              duration: Duration(milliseconds: 900),
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
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 0.70 * height,
                width: width,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey[50]
                      : Colors.grey[900],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      FadeInUp(
                        child: Container(
                          height: 0.15 * height,
                          width: 0.30 * width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                              image: AssetImage("images/app_icon.png"),
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 30.0,
                          right: 30.0,
                          top: 17.0,
                        ),
                        child: Container(
                          height: 0.065 * height,
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
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                            ),
                            child: Row(
                              children: [
                                ImageIcon(AssetImage("images/user.png")),
                                SizedBox(width: 15.0),
                                Expanded(
                                  child: TextFormField(
                                    onTap: () {
                                      if (nameerror) {
                                        setState(() {
                                          name.clear();
                                          nametext = "Name";
                                          nameerror = false;
                                        });
                                      }
                                    },
                                    controller: name,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    cursorHeight: 13,
                                    cursorColor: Colors.black,
                                    cursorErrorColor: Colors.black,
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(fontSize: 0.01),
                                      hintText: nametext,
                                      hintStyle: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: nameerror
                                            ? Colors.red
                                            : Colors.black,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        setState(() {
                                          name.clear();
                                          nameerror = true;
                                          nametext = "Required";
                                        });
                                        return "Required";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                          left: 30.0,
                          right: 30.0,
                          top: 15.0,
                        ),
                        child: Container(
                          height: 0.065 * height,
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
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                            ),
                            child: Row(
                              children: [
                                ImageIcon(AssetImage("images/phone.png")),
                                SizedBox(width: 15.0),
                                Expanded(
                                  child: TextFormField(
                                    onTap: () {
                                      if (phoneerror) {
                                        setState(() {
                                          phonenumber.clear();
                                          phonenumbertext = "Phone number";
                                          phoneerror = false;
                                        });
                                      }
                                    },
                                    keyboardType: TextInputType.phone,
                                    controller: phonenumber,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    cursorHeight: 13,
                                    cursorColor: Colors.black,
                                    cursorErrorColor: Colors.black,
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(fontSize: 0.01),
                                      hintText: phonenumbertext,
                                      hintStyle: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: phoneerror
                                            ? Colors.red
                                            : Colors.black,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        setState(() {
                                          phonenumber.clear();
                                          phoneerror = true;
                                          phonenumbertext = "Required";
                                        });
                                        return "Required";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                          left: 30.0,
                          right: 30.0,
                          top: 15.0,
                        ),
                        child: Container(
                          height: 0.065 * height,
                          width: width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 7,
                                offset: Offset(1, 2),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                            ),
                            child: Row(
                              children: [
                                ImageIcon(AssetImage("images/email.png")),
                                SizedBox(width: 15.0),
                                Expanded(
                                  child: TextFormField(
                                    onTap: () {
                                      if (emailerror) {
                                        setState(() {
                                          email.clear();
                                          emailtext = "Email";
                                          emailerror = false;
                                        });
                                      }
                                    },
                                    controller: email,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    cursorHeight: 13,
                                    cursorColor: Colors.black,
                                    cursorErrorColor: Colors.black,
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(fontSize: 0.01),
                                      hintText: emailtext,
                                      hintStyle: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: emailerror
                                            ? Colors.red
                                            : Colors.black,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        setState(() {
                                          email.clear();
                                          emailerror = true;
                                          emailtext = "Required";
                                        });
                                        return "Required";
                                      } else if (email.text.isEmail == false) {
                                        setState(() {
                                          email.clear();
                                          emailerror = true;
                                          emailtext = "Invalid email";
                                        });
                                        return "Invalid email";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('artisans')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 30.0,
                                right: 30.0,
                                top: 15.0,
                              ),
                              child: Container(
                                height: 0.065 * height,
                                width: width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 30.0,
                              right: 30.0,
                              top: 15.0,
                            ),
                            child: Container(
                              height: 0.065 * height,
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
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                ),
                                child: Row(
                                  children: [
                                    ImageIcon(AssetImage("images/search.png")),
                                    SizedBox(width: 15.0),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8.0,
                                        ),
                                        child: DropdownButtonFormField(
                                          dropdownColor: Colors.white,
                                          initialValue: selectedArtisanId,
                                          decoration: InputDecoration(
                                            hint: Text(
                                              artisantext,
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            border: InputBorder.none,
                                          ),
                                          items: snapshot.data!.docs.map((doc) {
                                            final data = doc.data();
                                            return DropdownMenuItem<String>(
                                              value:
                                                  doc.id, // ID stays as value
                                              child: Text(
                                                data['name'],
                                              ), // Name shown
                                              onTap: () {
                                                selectedArtisanName =
                                                    data['name']; // ✅ capture name
                                              },
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            //  print(doc["nams"]);
                                            setState(() {
                                              selectedArtisanId = value;
                                            });
                                          },
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

                      Padding(
                        padding: const EdgeInsets.only(
                          left: 30.0,
                          right: 30.0,
                          top: 15.0,
                        ),
                        child: Container(
                          height: 0.065 * height,
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
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                            ),
                            child: Row(
                              children: [
                                ImageIcon(AssetImage("images/password.png")),
                                SizedBox(width: 15.0),
                                Expanded(
                                  child: TextFormField(
                                    obscureText: hidepassword,
                                    onTap: () {
                                      if (passworderror) {
                                        setState(() {
                                          password.clear();
                                          passwordtext = "Password";
                                          passworderror = false;
                                        });
                                      }
                                    },
                                    controller: password,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    cursorHeight: 13,
                                    cursorColor: Colors.black,
                                    cursorErrorColor: Colors.black,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                        bottom: 5.0,
                                      ),
                                      suffix: InkWell(
                                        onTap: () {
                                          if (hidepassword == true) {
                                            setState(() {
                                              hidepassword = false;
                                            });
                                          } else {
                                            if (hidepassword == false) {
                                              setState(() {
                                                hidepassword = true;
                                              });
                                            }
                                          }
                                        },
                                        child: Icon(
                                          hidepassword
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.black,
                                        ),
                                      ),
                                      errorStyle: TextStyle(fontSize: 0.01),
                                      hintText: passwordtext,
                                      hintStyle: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: passworderror
                                            ? Colors.red
                                            : Colors.black,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        setState(() {
                                          password.clear();
                                          passworderror = true;
                                          passwordtext = "Required";
                                        });
                                        return "Required";
                                      } else if (value.length <= 8) {
                                        setState(() {
                                          password.clear();
                                          passworderror = true;
                                          passwordtext = "Weak password";
                                        });
                                        return "Weak password";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 30.0,
                          right: 30.0,
                          top: 20,
                        ),
                        child: InkWell(
                          onTap: () {
                            if (formkey.currentState!.validate()) {
                              createUserAccount();
                            }
                          },
                          child: Container(
                            height: 0.065 * height,
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
                                    "Create account",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
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
        child: FadeIn(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              "HOUSE MASTER",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createUserAccount() async {
    try {
      setState(() {
        loading = true;
      });

      final now = DateTime.now();

      // Create user
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.text.trim(),
            password: password.text.trim(),
          );

      // Save user data in Firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
            "uid": userCredential.user!.uid,
            "authentication": false,
            "role": "artisan",
            "bio": "",
            "name": name.text.trim(),
            "phonenumber": phonenumber.text.trim(),
            "verified": false,
            "rating": 0,
            "image": "",
            "addedservice": false,
            "occupation": selectedArtisanName,
            "email": email.text.trim(),
            "password": password.text.trim(),
            "datecreated": now,
            "daycreated": now.day,
            "monthcreated": now.month,
            "yearcreated": now.year,
            "token": "",
            "ratingAverage": 0,
            "ratingCount": 0,
            "ratingTotal": 0,
            "paymentmethod": "",
            "paymentchannel": "",
          });

      setState(() {
        loading = false;
      });

      Get.offAll(() => ScreenControllerPage());
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });

      Get.snackbar(
        "",
        "",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        titleText: Text(
          "Error!",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        messageText: Text(
          e.message ?? "Something went wrong",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        loading = false;
      });

      Get.snackbar(
        "",
        "",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        titleText: Text(
          "Error!",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        messageText: Text(
          "Try again later",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }
}
