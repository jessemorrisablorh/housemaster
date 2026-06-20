import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:housemasterapp/Pages/Artisan/artisan_home_page.dart';
import 'package:housemasterapp/Pages/Client/client_home_page.dart';
import 'package:housemasterapp/Pages/verification_screen_page.dart';
import 'package:housemasterapp/Widgets/loading_widget.dart';

class ScreenControllerPage extends StatefulWidget {
  const ScreenControllerPage({super.key});

  @override
  State<ScreenControllerPage> createState() => _ScreenControllerPageState();
}

class _ScreenControllerPageState extends State<ScreenControllerPage> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(user?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingWidget();
        }
        if (snapshot.data?["authentication"] == true) {
          return VerificationScreenPage();
        }
        return snapshot.data?["role"] == "client"
            ? ClientHomePage()
            : snapshot.data?["role"] == "artisan"
            ? ArtisanHomePage()
            : LoadingWidget();
      },
    );
  }
}
