import 'dart:math';

import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:housemasterapp/Pages/Client/artisan_connected_page.dart';
import 'package:intl/intl.dart';

class ClientInvoicePage extends StatefulWidget {
  final String artisanid;
  final String clientid;
  final List services;
  final String artisanname;

  const ClientInvoicePage({
    super.key,
    required this.artisanid,
    required this.clientid,
    required this.services,
    required this.artisanname,
  });

  @override
  State<ClientInvoicePage> createState() => _ClientInvoicePageState();
}

class _ClientInvoicePageState extends State<ClientInvoicePage> {
  final formatCurrency = NumberFormat.currency(symbol: " ");
  String? clientplacename;
  String? artisanplacename;
  String? clientimage;
  double? clientlat;
  double? clientlng;
  double? artisanlat;
  double? artisanlng;
  String? artisanimage;
  String? clientname;
  String? artisanname;
  bool loading = false;
  int totalcharge = 0;
  User? user = FirebaseAuth.instance.currentUser;

  late BitmapDescriptor shopIcon;
  late BitmapDescriptor userIcon;
  bool _iconsLoaded = false;
  bool ordering = false;
  //List<CartItem> cartItems = [];
  // Dummy coordinates
  LatLng clientLatLng = const LatLng(5.5600, -0.2050); // Accra Mall
  LatLng artisanLatLng = const LatLng(5.5850, -0.1750); // East Legon
  num distancefee = 0;
  // final String _darkMapStyle = '''[
  //   {
  //     "elementType": "geometry",
  //     "stylers": [{"color": "#212121"}]
  //   },
  //   {
  //     "elementType": "labels.icon",
  //     "stylers": [{"visibility": "off"}]
  //   },
  //   {
  //     "elementType": "labels.text.fill",
  //     "stylers": [{"color": "#757575"}]
  //   },
  //   {
  //     "elementType": "labels.text.stroke",
  //     "stylers": [{"color": "#212121"}]
  //   },
  //   {
  //     "featureType": "administrative",
  //     "elementType": "geometry",
  //     "stylers": [{"color": "#757575"}]
  //   },
  //   {
  //     "featureType": "poi",
  //     "elementType": "geometry",
  //     "stylers": [{"color": "#181818"}]
  //   },
  //   {
  //     "featureType": "road",
  //     "elementType": "geometry.fill",
  //     "stylers": [{"color": "#2c2c2c"}]
  //   },
  //   {
  //     "featureType": "road",
  //     "elementType": "geometry.stroke",
  //     "stylers": [{"color": "#212121"}]
  //   },
  //   {
  //     "featureType": "transit",
  //     "elementType": "geometry",
  //     "stylers": [{"color": "#2f3948"}]
  //   },
  //   {
  //     "featureType": "water",
  //     "elementType": "geometry",
  //     "stylers": [{"color": "#000000"}]
  //   },
  //   {
  //     "featureType": "water",
  //     "elementType": "labels.text.fill",
  //     "stylers": [{"color": "#3d3d3d"}]
  //   }
  // ]''';

  Future<void> getClientDetails() async {
    final clientvalue = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.clientid)
        .get();
    setState(() {
      clientlat = double.parse(clientvalue["lat"].toString());
      clientlng = double.parse(clientvalue["lng"].toString());
      clientLatLng = LatLng(clientlat!, clientlng!);
      clientimage = clientvalue["image"];
      clientname = clientvalue["name"];
      clientplacename = clientvalue["placename"];
    });

    getArtisanDetails();
  }

  Future<void> getArtisanDetails() async {
    final artisanvalue = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.artisanid) // ← FIXED
        .get();

    setState(() {
      artisanlat = double.parse(artisanvalue["lat"].toString());
      artisanlng = double.parse(artisanvalue["lng"].toString());
      artisanLatLng = LatLng(artisanlat!, artisanlng!);
      artisanimage = artisanvalue["image"];
      artisanname = artisanvalue["name"];
      artisanplacename = artisanvalue["placename"];
    });
  }

  @override
  void initState() {
    super.initState();
    getClientDetails();
    getArtisanDetails();
    loadCustomMarkers();
    calculateTotal();
    calculateArtisanTotal();
  }

  // double _degToRad(double deg) {
  //   return deg * (pi / 180);
  // }

  Future<void> loadCustomMarkers() async {
    shopIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 40)),
      'images/profile.jpg',
    );
    userIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 40)),
      'images/profile.jpg',
    );
    setState(() {
      _iconsLoaded = true;
    });
  }

  late GoogleMapController mapController;

  //final LatLng pointA = clientLa
  //const LatLng(5.6037, -0.1870); // Accra
  final LatLng pointB = const LatLng(5.5560, -0.1969); // Example point

  double calculateServiceCharge() {
    double total = 0;

    for (var element in widget.services) {
      total += element["amount"];
    }

    return 1 / 100 * total;
  }

  double calculateTotal() {
    double total = 0;

    for (var element in widget.services) {
      total += element["amount"];
    }

    return total + calculateServiceCharge();
  }

  double calculateArtisanTotal() {
    double total = 0;

    for (var element in widget.services) {
      total += element["amount"];
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    if (!_iconsLoaded) {
      return const Center(child: CircularProgressIndicator());
    }
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
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 30.0,
                    ),
                    child: SizedBox(
                      height: height * 0.25,
                      width: width,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: clientLatLng,
                          zoom: 14,
                        ),
                        markers: {
                          Marker(
                            markerId: const MarkerId("client"),
                            position: clientLatLng,
                            infoWindow: const InfoWindow(title: "Client"),
                          ),
                          Marker(
                            markerId: const MarkerId("artisan"),
                            position: artisanLatLng,
                            infoWindow: const InfoWindow(title: "Artisan"),
                          ),
                        },
                        polylines: {
                          Polyline(
                            polylineId: const PolylineId("route"),
                            color: Colors.amber,
                            width: 5,
                            points: [clientLatLng, artisanLatLng],
                          ),
                        },
                        onMapCreated: (controller) async {
                          mapController = controller;

                          final bounds = LatLngBounds(
                            southwest: LatLng(
                              clientLatLng.latitude < artisanLatLng.latitude
                                  ? clientLatLng.latitude
                                  : artisanLatLng.latitude,
                              clientLatLng.longitude < artisanLatLng.longitude
                                  ? clientLatLng.longitude
                                  : artisanLatLng.longitude,
                            ),
                            northeast: LatLng(
                              clientLatLng.latitude > artisanLatLng.latitude
                                  ? clientLatLng.latitude
                                  : artisanLatLng.latitude,
                              clientLatLng.longitude > artisanLatLng.longitude
                                  ? clientLatLng.longitude
                                  : artisanLatLng.longitude,
                            ),
                          );

                          await Future.delayed(
                            const Duration(milliseconds: 300),
                          );

                          controller.animateCamera(
                            CameraUpdate.newLatLngBounds(bounds, 60),
                          );
                        },
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 30.0),
                        child: Text(
                          "Artisan",
                          style: GoogleFonts.poppins(
                            color: Colors.amber,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      top: 20.0,
                      right: 20.0,
                    ),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(widget.artisanid)
                          .snapshots(),
                      builder: (context, asyncsnapshot) {
                        if (!asyncsnapshot.hasData) {
                          return Text("sdkm");
                        }
                        return Row(
                          children: [
                            Container(
                              height: 0.065 * height,
                              width: 0.15 * width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                image: DecorationImage(
                                  image: AdvImageCache(
                                    asyncsnapshot.data?["image"],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 15.0),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    asyncsnapshot.data?["name"],
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
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 15,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 15,
                                      ),
                                      Icon(
                                        Icons.star_half,
                                        color: Colors.amber,
                                        size: 15,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "${asyncsnapshot.data?['ratingAverage'].toStringAsFixed(1)}",
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
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
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
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.services.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.services[index]["service"] ?? "kj",
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
                              Text(
                                "GHS ${widget.services[index]["amount"]}",
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
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                        child: Text(
                          "Charges",
                          style: GoogleFonts.poppins(
                            color: Colors.amber,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 10.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Service charge",
                          style: GoogleFonts.poppins(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "GHS ${formatCurrency.format(calculateServiceCharge())}",
                          style: GoogleFonts.poppins(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 10.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total charge",
                          style: GoogleFonts.poppins(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "GHS ${formatCurrency.format(calculateTotal())}",
                          style: GoogleFonts.poppins(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.0),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: FadeInUp(
          child: InkWell(
            onTap: () async {
              await createArtisanRequest();
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
                        "Checkout",
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

  Future<void> createArtisanRequest() async {
    final random = Random();
    int number = 1000 + random.nextInt(9000);
    setState(() {
      loading = true;
    });
    try {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("connects")
          .doc();
      await documentReference
          .set({
            "id": documentReference.id,
            "clientid": user?.uid,
            "artisanid": widget.artisanid,
            "artisanlat": artisanlat,
            "artisanlng": artisanlng,
            "artisanimage": artisanimage,
            "clientlat": clientlat,
            "clientlng": clientlng,
            "clientimage": clientimage,
            "clientname": clientname,
            "artisanname": artisanname,
            "clientplacename": clientplacename,
            "artisanplacename": artisanplacename,
            "paid": false,
            "complete": false,
            "status": "pending",
            "datecreated": DateTime.now(),
            "daycreated": DateTime.now().day,
            "monthcreated": DateTime.now().month,
            "yearcreated": DateTime.now().year,
            "totalcharge": calculateTotal(),
            "artisanservicecharge": calculateArtisanTotal(),
            "servicecharge": calculateServiceCharge(),
            "services": widget.services,
            "pin": number.toString(),
            "pending": false,
            "arrived": false,
            "heading": false,
            "completed": false,
            "starting": false,
            "started": false,
          })
          .then((value) {
            setState(() {
              loading = false;
            });
            Get.offAll(
              () => ArtisanConnectedPage(artisanname: widget.artisanname),
            );
          });
    } catch (e) {
      loading = false;
    }
  }
}
