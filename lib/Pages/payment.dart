import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemasterapp/Pages/payment_successful_page.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class Payment extends StatefulWidget {
  final String? uid;
  final String? link;
  final String? references;
  final num? amount;
  final num? artisancharge;
  final String artisanid;
  final String connectid;
  const Payment({
    super.key,
    required this.artisanid,
    required this.link,
    required this.uid,
    required this.references,
    required this.amount,
    required this.connectid,
    required this.artisancharge,
  });

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  late String currentUrl;

  String labelapikey = "";
  int position = 1;

  final key = UniqueKey();

  Future<void> verifyPayment(String reference) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.paystack.co/transaction/verify/$reference'),
        headers: {
          'Authorization': 'Bearer YOUR_SECRET_KEY',
          'Content-Type': 'application/json',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["data"]["status"] == "success") {
        await FirebaseFirestore.instance
            .collection("connects")
            .doc(widget.connectid)
            .update({"paid": true, "datepaid": DateTime.now()});

        DocumentReference paymentReference = FirebaseFirestore.instance
            .collection("payment_transactions")
            .doc();

        await paymentReference.set({
          "id": paymentReference.id,
          "datecreated": DateTime.now(),
          "amount": widget.amount,
          "paymentmethod": "Paystack",
          "reference": reference,
        });

        Get.offAll(() => PaymentSuccessfulPage(artisanid: widget.artisanid));
      } else {
        if (kDebugMode) {
          print("Payment not successful");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Verification error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.startsWith('https://google.com/')) {
              try {
                await FirebaseFirestore.instance
                    .collection("connects")
                    .doc(widget.connectid)
                    .update({
                      "paid": true,
                      "datepaid": DateTime.now(),
                      "completed": true,
                      "status": "completed",
                      "datecompleted": DateTime.now(),
                    });

                DocumentReference paymentReference = FirebaseFirestore.instance
                    .collection("payment_transactions")
                    .doc();

                await paymentReference.set({
                  "id": paymentReference.id,
                  "datecreated": DateTime.now(),
                  "amount": widget.amount,
                  "paymentmethod": "Paystack",
                  // "reference": reference,
                });
                DocumentReference accountReference = FirebaseFirestore.instance
                    .collection("accounts")
                    .doc();
                await accountReference.set({
                  "id": accountReference.id,
                  "clientid": FirebaseAuth.instance.currentUser?.uid,
                  "artisanid": widget.artisanid,
                  "datecreated": DateTime.now(),
                  "artisancharge": widget.artisancharge,
                  "amount": widget.amount,
                  "connectid": widget.connectid,
                  "status": "pending",
                });

                Get.offAll(
                  () => PaymentSuccessfulPage(artisanid: widget.artisanid),
                );
              } catch (e) {
                if (kDebugMode) {
                  print(e);
                }
              }

              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          // onNavigationRequest: (NavigationRequest request) async {
          //   if (request.url.startsWith('https://google.com')) {
          //     Uri uri = Uri.parse(request.url);
          //     String? reference = uri.queryParameters['reference'];

          //     if (reference != null) {
          //       await verifyPayment(reference);
          //     }

          //     return NavigationDecision.prevent;
          //   }

          //   return NavigationDecision.navigate;
          // },
        ),
      )
      ..loadRequest(Uri.parse("${widget.link}"));
    return Scaffold(
      backgroundColor: Colors.grey[900],

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
          Expanded(child: WebViewWidget(controller: controller)),
        ],
      ),
    );
  }
}
