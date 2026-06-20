import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final box = GetStorage();

  ThemeMode themeMode = ThemeMode.system;

  @override
  void onInit() {
    super.onInit();
    loadTheme();
  }

  void loadTheme() {
    String theme = box.read('theme') ?? "system";

    if (theme == "light") {
      themeMode = ThemeMode.light;
    } else if (theme == "dark") {
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.system;
    }

    update();
  }

  void setTheme(String theme) {
    box.write("theme", theme);
    loadTheme();
  }
}
