import 'dart:convert';
import 'dart:io';
import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemasterapp/Models/bank_model.dart';
import 'package:housemasterapp/Pages/Artisan/account_page.dart';
import 'package:housemasterapp/Pages/Artisan/artisan_assigned_task_page.dart';
import 'package:housemasterapp/Pages/Artisan/artisan_profile_page.dart';
import 'package:housemasterapp/Pages/Artisan/services_page.dart';
import 'package:housemasterapp/Pages/Artisan/work_profile_page.dart';
import 'package:housemasterapp/Widgets/loading_widget.dart';
import 'package:housemasterapp/main.dart';
import 'package:housemasterapp/theme_controller.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ArtisanHomePage extends StatefulWidget {
  const ArtisanHomePage({super.key});

  @override
  State<ArtisanHomePage> createState() => _ArtisanHomePageState();
}

class _ArtisanHomePageState extends State<ArtisanHomePage> {
  final ThemeController controller = Get.find();
  TextEditingController bio = TextEditingController();
  TextEditingController serviceinfo = TextEditingController();
  TextEditingController servicecharge = TextEditingController();
  TextEditingController paymentphone = TextEditingController();
  TextEditingController bankaccountnumber = TextEditingController();
  TextEditingController bankname = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController bankaccountname = TextEditingController();
  final formkey = GlobalKey<FormState>();
  String caption = "";
  User? user = FirebaseAuth.instance.currentUser;
  String home = "requests";
  bool locationloading = false;
  String? cityname;
  String? regionname;
  String? placename;
  double? latitude;
  double? longitude;
  String? selectedPlaceName;
  String? citynamenew;
  String? regionnamenew;
  double? lat;
  double? lng;
  String? useraddress;
  bool loading = false;
  bool imageselected = false;
  File? imageFile;
  String? fileName;
  String? clientcity;
  String? clientregion;
  String network = "Network";
  String? selectedBankName;
  String? selectedBankCode;

  String fcmtoken = "";

  Future<void> getToken() async {
    String token = box.read("fcmtoken") ?? "";

    fcmtoken = token;

    if (user != null && token.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .update({"token": token});
    }
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

  final List<Bank> banks = [
    // Banks
    Bank(name: "GCB Bank", code: "040100"),
    Bank(name: "Ecobank Ghana", code: "130100"),
    Bank(name: "Fidelity Bank", code: "070100"),
    Bank(name: "CalBank", code: "150100"),
  ];

  @override
  void initState() {
    super.initState();
    getToken();
    getCurrentLocationDetails();
    getPaymentApi();
  }

  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;
  String? imageUrl;

  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (pickedFile == null) return;

    setState(() {
      imageselected = true;
      imageFile = File(pickedFile.path);
      fileName = const Uuid().v4();
    });
  }

  Future<void> uploadImageToFirebase() async {
    setState(() {
      isLoading = true;
    });
    try {
      // Upload to Firebase Storage
      final ref = FirebaseStorage.instance.ref().child(
        'profile_images/$fileName.jpg',
      );

      await ref.putFile(imageFile!);

      // Get download URL
      String downloadUrl = await ref.getDownloadURL();

      // Save URL to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid) // 🔥 Replace with actual user id
          .set({
            'image': downloadUrl,
            //  'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      setState(() {
        imageUrl = downloadUrl;
      });
    } catch (e) {
      debugPrint("Upload failed: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

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
          return LoadingWidget();
        }
        return Scaffold(
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.grey[50]
              : Colors.grey[900],
          body: asyncSnapshot.data?["bio"] == ""
              ? Column(
                  children: [
                    Container(
                      width: width,
                      height: 0.30 * height,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("images/tag.jpg"),
                          fit: BoxFit.cover,
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
                                          "Create a bio",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          "A writeup people will see about you",
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
                                  height: 0.20 * height,
                                  width: width,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: TextField(
                                      controller: bio,
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
                                        hintText: "Bio ..",

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
                                  top: 30.0,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    if (bio.text != "") {
                                      updateBio();
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
                                            "Save bio",
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
                )
              : asyncSnapshot.data?["addedservice"] == false
              ? Column(
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
                                          "Create a service",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
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
                                    color: Colors.grey,
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
                                    color: Colors.grey,
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
                )
              : asyncSnapshot.data?["image"] == ""
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 0.28 * height,
                        width: 0.58 * width,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          image: DecorationImage(
                            image: imageselected == false
                                ? AssetImage("images/profile.jpg")
                                : FileImage(imageFile!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        "Upload an image of yourself",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                          top: 30.0,
                        ),
                        child: Row(
                          children: [
                            if (imageselected)
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    backgroundColor: Colors.black,
                                    context: context,
                                    builder: (_) => SafeArea(
                                      child: Wrap(
                                        children: [
                                          ListTile(
                                            leading: const Icon(
                                              Icons.camera_alt,
                                              color: Colors.amber,
                                            ),
                                            title: Text(
                                              "Take Photo",
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.pop(context);
                                              pickImage(ImageSource.camera);
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(
                                              Icons.photo_library,
                                              color: Colors.amber,
                                            ),
                                            title: Text(
                                              "Choose from Gallery",
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.pop(context);
                                              pickImage(ImageSource.gallery);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: Container(
                                    height: 0.060 * height,
                                    width: 0.13 * width,
                                    decoration: BoxDecoration(
                                      color: Colors.amber.withAlpha(60),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.refresh,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),
                              ),

                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  if (imageselected == true) {
                                    uploadImageToFirebase();
                                  } else {
                                    showModalBottomSheet(
                                      backgroundColor: Colors.black,
                                      context: context,
                                      builder: (_) => SafeArea(
                                        child: Wrap(
                                          children: [
                                            ListTile(
                                              leading: const Icon(
                                                Icons.camera_alt,
                                                color: Colors.amber,
                                              ),
                                              title: Text(
                                                "Take Photo",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);
                                                pickImage(ImageSource.camera);
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(
                                                Icons.photo_library,
                                                color: Colors.amber,
                                              ),
                                              title: Text(
                                                "Choose from Gallery",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);
                                                pickImage(ImageSource.gallery);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
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
                                  child: isLoading
                                      ? SizedBox(
                                          height: 13,
                                          width: 13,
                                          child: CircularProgressIndicator(
                                            color: Colors.black,
                                            strokeWidth: 3,
                                          ),
                                        )
                                      : Text(
                                          imageselected
                                              ? "Upload image"
                                              : "Select image",
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : asyncSnapshot.data?["paymentmethod"] == "" &&
                    asyncSnapshot.data?["paymentchannel"] == ""
              ? Form(
                  key: formkey,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Set payment method",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          children: [
                            Text(
                              "Let Housemaster app know how to pay you",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),

                        InkWell(
                          onTap: () {
                            setState(() {
                              caption = "bank";
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_box,
                                color: caption == "bank"
                                    ? Colors.amber
                                    : Colors.grey,
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Text(
                                  "Bank account payment",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                        InkWell(
                          onTap: () {
                            setState(() {
                              caption = "momo";
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_box,
                                color: caption == "momo"
                                    ? Colors.amber
                                    : Colors.grey,
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Text(
                                  "Mobile money payment",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30.0),
                        Row(
                          children: [
                            Text(
                              caption == ""
                                  ? "Select payment method"
                                  : caption == "bank"
                                  ? "Add bank account details"
                                  : caption == "momo"
                                  ? "Add mobile money details"
                                  : caption,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        if (caption == "bank")
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Container(
                              height: 0.060 * height,
                              width: width,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(7),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 15.0,
                                  right: 15.0,
                                ),
                                child: DropdownButtonFormField<String>(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Required";
                                    }
                                    return null;
                                  },
                                  initialValue: selectedBankName,
                                  decoration: InputDecoration(
                                    labelText: "Select Bank",
                                    labelStyle: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  items: banks.map((bank) {
                                    return DropdownMenuItem<String>(
                                      value: bank.name,
                                      child: Text(bank.name),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedBankName = value;

                                      // get bank code
                                      selectedBankCode = banks
                                          .firstWhere((b) => b.name == value)
                                          .code;

                                      print("Selected Bank: $selectedBankName");
                                      print("Bank Code: $selectedBankCode");
                                    });
                                  },
                                ),
                                // TextFormField(
                                //   validator: (value) {
                                //     if (value!.isEmpty) {
                                //       return "Required";
                                //     }
                                //     return null;
                                //   },
                                //   controller: bankname,
                                //   style: GoogleFonts.poppins(
                                //     color: Colors.black,
                                //     fontSize: 13,
                                //     fontWeight: FontWeight.w600,
                                //   ),
                                //   cursorHeight: 13,
                                //   decoration: InputDecoration(
                                //     border: InputBorder.none,
                                //     hintText: "Bank name",
                                //     hintStyle: GoogleFonts.poppins(
                                //       color: Colors.black,
                                //       fontSize: 13,
                                //       fontWeight: FontWeight.w600,
                                //     ),
                                //   ),
                                // ),
                              ),
                            ),
                          ),
                        if (caption == "bank")
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Container(
                              height: 0.060 * height,
                              width: width,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(7),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 15.0,
                                  right: 15.0,
                                ),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Required";
                                    }
                                    return null;
                                  },
                                  controller: bankaccountname,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  cursorHeight: 13,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Bank account name",
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
                        if (caption == "bank")
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Container(
                              height: 0.060 * height,
                              width: width,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(7),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 15.0,
                                  right: 15.0,
                                ),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Required";
                                    }
                                    return null;
                                  },
                                  controller: bankaccountnumber,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  cursorHeight: 13,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Bank account number",
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

                        if (caption == "momo")
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Container(
                              height: 0.060 * height,
                              width: width,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(7),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 15.0,
                                  right: 15.0,
                                ),
                                child: Text(
                                  network,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (caption == "momo")
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Container(
                              height: 0.060 * height,
                              width: width,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(7),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 15.0,
                                  right: 15.0,
                                ),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Required";
                                    }
                                    return null;
                                  },
                                  controller: name,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  cursorHeight: 13,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Name",
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
                        if (caption == "momo")
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Container(
                              height: 0.060 * height,
                              width: width,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(7),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 15.0,
                                  right: 15.0,
                                ),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  maxLength: 10,
                                  onChanged: (value) {
                                    if (paymentphone.text.contains("054") ||
                                        paymentphone.text.contains("024") ||
                                        paymentphone.text.contains("053") ||
                                        paymentphone.text.contains("055") ||
                                        paymentphone.text.contains("059")) {
                                      setState(() {
                                        network = "MTN";
                                      });
                                    } else if (paymentphone.text.contains(
                                          "020",
                                        ) ||
                                        paymentphone.text.contains("050")) {
                                      setState(() {
                                        network = "TELECEL";
                                      });
                                    } else if (paymentphone.text.contains(
                                          "026",
                                        ) ||
                                        paymentphone.text.contains("056") ||
                                        paymentphone.text.contains("026") ||
                                        paymentphone.text.contains("027") ||
                                        paymentphone.text.contains("057")) {
                                      setState(() {
                                        network = "AT";
                                      });
                                    } else if (paymentphone.text == "") {
                                      setState(() {
                                        network = "Network";
                                      });
                                    }
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Required";
                                    }
                                    return null;
                                  },
                                  controller: paymentphone,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  cursorHeight: 13,
                                  decoration: InputDecoration(
                                    counterStyle: TextStyle(fontSize: 0),
                                    border: InputBorder.none,
                                    hintText: "Phone number",
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
                        SizedBox(height: 20.0),
                        InkWell(
                          onTap: () async {
                            if (formkey.currentState!.validate()) {
                              if (caption == "momo") {
                                await addMobileMoneyNumber();
                              } else {
                                await addBankAccount();
                              }
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
                                    "Continue",
                                    style: GoogleFonts.poppins(
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
                )
              : Column(
                  children: [
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          top: 20.0,
                          right: 20.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 0.060 * height,
                              width: 0.40 * width,
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.amber
                                    : Colors.amber.withAlpha(60),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 0.060 * height,
                                    width: 0.14 * width,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.amber,
                                      image: DecorationImage(
                                        image:
                                            asyncSnapshot.data?["image"] == ""
                                            ? AssetImage("images/empty.jpg")
                                            : AdvImageCache(
                                                asyncSnapshot.data?["image"],
                                              ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: Text(
                                      "Hi ${asyncSnapshot.data?["name"].toString().capitalizeFirst}",
                                      overflow: TextOverflow.ellipsis,
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
                                  ),
                                  SizedBox(width: 15),
                                ],
                              ),
                            ),

                            InkWell(
                              onTap: () {
                                Get.to(() => ArtisanProfilePage());
                              },
                              child: Container(
                                height: 0.060 * height,
                                width: 0.13 * width,
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.amber
                                      : Colors.amber.withAlpha(60),
                                  borderRadius: BorderRadius.circular(7),
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
                                  padding: const EdgeInsets.all(15.0),
                                  child: ImageIcon(
                                    AssetImage("images/user.png"),
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors.amber,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(
                                  () => ArtisanAssignedTaskPage(
                                    artisanid: user!.uid,
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 30.0,
                                  left: 20.0,
                                  right: 20.0,
                                ),
                                child: Container(
                                  height: 0.15 * height,
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
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "images/task.jpg",
                                        height: 0.12 * height,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Tasks",
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 20.0,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(() => WorkProfilePage());
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 0.23 * height,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  "images/tag.jpg",
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                      Theme.of(
                                                            context,
                                                          ).brightness ==
                                                          Brightness.light
                                                      ? Colors.black26
                                                      : Colors.black,
                                                  blurRadius: 7,
                                                  offset: Offset(1, 2),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          Text(
                                            "Work profile",
                                            style: GoogleFonts.poppins(
                                              color:
                                                  Theme.of(
                                                        context,
                                                      ).brightness ==
                                                      Brightness.light
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),

                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(() => ServicesPage());
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 0.23 * height,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  "images/tools.jpg",
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                      Theme.of(
                                                            context,
                                                          ).brightness ==
                                                          Brightness.light
                                                      ? Colors.black26
                                                      : Colors.black,
                                                  blurRadius: 7,
                                                  offset: Offset(1, 2),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          Text(
                                            "Services",
                                            style: GoogleFonts.poppins(
                                              color:
                                                  Theme.of(
                                                        context,
                                                      ).brightness ==
                                                      Brightness.light
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontSize: 12,
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
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 20.0,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(() => AccountPage());
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 0.23 * height,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  "images/accounts.jpg",
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                      Theme.of(
                                                            context,
                                                          ).brightness ==
                                                          Brightness.light
                                                      ? Colors.black26
                                                      : Colors.black,

                                                  blurRadius: 7,
                                                  offset: Offset(1, 2),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          Text(
                                            "Accounts",
                                            style: GoogleFonts.poppins(
                                              color:
                                                  Theme.of(
                                                        context,
                                                      ).brightness ==
                                                      Brightness.light
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(child: SizedBox()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                height: 0.050 * height,
                width: width,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey[50]
                      : Colors.grey[900],
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          useraddress ??
                              "Searching for your current location ...",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> getCurrentLocationDetails() async {
    try {
      setState(() {
        locationloading = true;
      });

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        setState(() => locationloading = false);
        return;
      }

      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      // Handle denied forever
      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        setState(() => locationloading = false);
        return;
      }

      if (permission == LocationPermission.denied) {
        setState(() => locationloading = false);
        return;
      }

      // Get position with timeout
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      ).timeout(const Duration(seconds: 15));

      lat = position.latitude;
      lng = position.longitude;

      // Reverse geocoding
      final placemarks = await placemarkFromCoordinates(lat!, lng!);

      if (placemarks.isEmpty) {
        throw Exception("No address found");
      }

      final placemark = placemarks.first;

      useraddress = placemark.name ?? "Unknown place";
      clientcity = placemark.locality ?? "Unknown city";
      clientregion = placemark.administrativeArea ?? "Unknown region";

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user?.uid)
          .update({
            "lat": lat,
            "lng": lng,
            "placename": useraddress,
            "clientcity": clientcity,
            "clientregion": clientregion,
          });

      if (!mounted) return;

      setState(() {
        locationloading = false;
      });
    } catch (e) {
      debugPrint("Location error: $e");

      if (!mounted) return;

      setState(() {
        locationloading = false;
      });
    }
  }

  // Future<void> getCurrentLocationDetails() async {
  //   try {
  //     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //     if (!serviceEnabled) {
  //       await Geolocator.openLocationSettings();
  //       return;
  //     }

  //     LocationPermission permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //     }

  //     if (permission == LocationPermission.denied ||
  //         permission == LocationPermission.deniedForever) {
  //       return;
  //     }

  //     final Position position = await Geolocator.getCurrentPosition(
  //       locationSettings: const LocationSettings(
  //         accuracy: LocationAccuracy.high,
  //       ),
  //     );

  //     lat = position.latitude;
  //     lng = position.longitude;

  //     final placemarks = await placemarkFromCoordinates(lat!, lng!);
  //     final placemark = placemarks.first;

  //     useraddress = placemark.name;
  //     clientcity = placemark.locality;
  //     clientregion = placemark.administrativeArea;

  //     await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(user?.uid)
  //         .update({
  //           "lat": lat,
  //           "lng": lng,
  //           "placename": placemark.name,
  //           "clientcity": placemark.locality,
  //           "clientregion": placemark.administrativeArea,
  //         });

  //     setState(() {
  //       locationloading = false;
  //     });
  //   } catch (e) {
  //     debugPrint("Location error: $e");
  //   }
  // }

  void updateBio() async {
    setState(() {
      loading = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user?.uid)
          .update({"bio": bio.text.trim()})
          .then((value) {
            setState(() {
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
                .update({"addedservice": true});
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

  Future<void> addMobileMoneyNumber() async {
    try {
      setState(() {
        loading = true;
      });
      final response = await http.post(
        Uri.parse('https://api.paystack.co/transferrecipient'),
        headers: {
          'Authorization': 'Bearer $paymentapi',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "type": "mobile_money",
          "name": name.text.trim(),
          "account_number": paymentphone.text.trim(),
          "bank_code": network == "TELECEL"
              ? "VOD"
              : network == "AT"
              ? "ATL"
              : network,
          "currency": "GHS",
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data["status"] == true) {
        String recipientcode = data["data"]["recipient_code"];
        int id = data["data"]["id"];
        int integration = data["data"]["integration"];
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user?.uid)
            .update({
              "recipient_code": data["data"]["recipient_code"],
              "recipientid": data["data"]["id"],
              "recipient_integration": data["data"]["integration"],
              "paymentname": name.text.trim(),
              "paymentchannel": paymentphone.text.trim(),
              "paymentmethod": caption,
            });

        setState(() {
          loading = false;
        });

        if (kDebugMode) {
          print("RECIPENT_CODE :: $recipientcode");
          print("ID: $id");
          print("INTEGRATION: $integration");
        }
      } else {
        if (kDebugMode) {
          print("Error: ${data["message"]}");
        }
      }
    } catch (e) {
      print("E :: $e");
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> addBankAccount() async {
    try {
      setState(() {
        loading = true;
      });
      final response = await http.post(
        Uri.parse('https://api.paystack.co/transferrecipient'),
        headers: {
          'Authorization': 'Bearer $paymentapi',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "type": "ghipss",
          "name": name.text.trim(),
          "account_number": bankaccountnumber.text.trim(),
          "bank_code": selectedBankCode,
          "currency": "GHS",
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data["status"] == true) {
        String recipientcode = data["data"]["recipient_code"];
        int id = data["data"]["id"];
        int integration = data["data"]["integration"];
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user?.uid)
            .update({
              "recipient_code": data["data"]["recipient_code"],
              "recipientid": data["data"]["id"],
              "recipient_integration": data["data"]["integration"],
              "paymentname": bankaccountname.text.trim(),
              "paymentchannel": bankaccountnumber,
              "bankname": selectedBankName,
              "paymentmethod": caption,
            });

        setState(() {
          loading = false;
        });

        if (kDebugMode) {
          print("RECIPENT_CODE :: $recipientcode");
          print("ID: $id");
          print("INTEGRATION: $integration");
        }
      } else {
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
