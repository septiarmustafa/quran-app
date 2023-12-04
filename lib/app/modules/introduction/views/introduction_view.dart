import 'package:alquran_app/app/constant/color.dart';
import 'package:alquran_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/introduction_controller.dart';

class IntroductionView extends GetView<IntroductionController> {
  const IntroductionView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                "My Quran App",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Center(
              child: Text(
                "Belajar coding kuat, baca quran 10 menit aja berat",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Lottie.asset("assets/lotties/introquran.json"),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  backgroundColor: Get.isDarkMode ? appWhite : appOrange,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
              onPressed: () {
                Get.toNamed(Routes.HOME);
              },
              child: Text(
                "Get Started",
                style: TextStyle(color: Get.isDarkMode ? appPurple : appWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
