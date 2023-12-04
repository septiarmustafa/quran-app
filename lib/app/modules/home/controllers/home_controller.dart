import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:alquran_app/app/constant/color.dart';
import 'package:alquran_app/app/data/models/db/bookmark.dart';
import 'package:alquran_app/app/data/models/detail_surah.dart';
import 'package:alquran_app/app/data/models/surah.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class HomeController extends GetxController {
  List<Surah> allSurah = [];
  List<Map<String, dynamic>> allJuz = [];
  RxBool isDark = false.obs;
  RxBool dataAllJuzAvailable = false.obs;

  DatabaseManager database = DatabaseManager.instance;

  Future<void> saveToLocal() async {
    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final file = File('${appDocumentsDirectory.path}/list_surah.json');
    final jsonData =
        jsonEncode(allSurah.map((surah) => surah.toJson()).toList());
    await file.writeAsString(jsonData);
  }

  Future<void> readFile() async {
    final box = GetStorage();
    final String? allSurahJson = box.read('list_surah');
    if (allSurahJson != null) {
      final List<dynamic> allSurahList = jsonDecode(allSurahJson);
      allSurah = allSurahList.map((item) => Surah.fromJson(item)).toList();
      log('data: $allSurah');
    }
  }

  Future<List<Surah>> getListSurah() async {
    bool result = await InternetConnectionChecker().hasConnection;

    if (result) {
      await getAllsurat();
      await saveToLocal();
    } else {
      log('No internet');
      await readFile();
    }
    return allSurah;
  }

  Future<Map<String, dynamic>?> getLastRead() async {
    Database db = await database.db;
    List<Map<String, dynamic>> dataLastRead = await db.query(
      "bookmark",
      where: "last_read = 1",
    );
    if (dataLastRead.isEmpty) {
      // tidak ada data last read
      return null;
    } else {
      // ada data -> ambil index ke 0 (karena cuma ada 1 data dalam list)
      return dataLastRead.first;
    }
  }

  void deleteLastRead(int id) async {
    Database db = await database.db;
    await db.delete("bookmark", where: "id = $id");
    update();
    Get.back(); // tuutp dialog
    Get.snackbar("Berhasil", "Telah berhasil menghapus last read",
        colorText: appPurple);
  }

  void deleteBookmark(int id) async {
    Database db = await database.db;
    await db.delete("bookmark", where: "id = $id");
    update();
    Get.snackbar("Berhasil", "Telah berhasil menghapus bookmark",
        colorText: appPurple);
  }

  Future<List<Map<String, dynamic>>> getBookmark() async {
    Database db = await database.db;
    List<Map<String, dynamic>> allBookmark = await db.query(
      "bookmark",
      where: "last_read = 0",
      orderBy: "juz, via, surah, ayat",
    );
    return allBookmark;
  }

  void changeThemeMode() async {
    Get.isDarkMode ? Get.changeTheme(themeLight) : Get.changeTheme(themeDark);
    isDark.toggle();

    final box = GetStorage();
    if (Get.isDarkMode) {
      // dark -> light
      box.remove("themeDark");
    } else {
      // light -> dark
      box.write("themeDark", true);
    }
  }

  Future<List<Surah>> getAllsurat() async {
    Uri urlSurah = Uri.parse("https://api.quran.gading.dev/surah");
    var responseSurah = await http.get(urlSurah);

    List? data =
        (json.decode(responseSurah.body) as Map<String, dynamic>)["data"];

    if (data == null || data.isEmpty) {
      return [];
    } else {
      allSurah = data.map((e) => Surah.fromJson(e)).toList();
      log('data: $allSurah');
      return allSurah;
    }
  }

  // *OPSI KEDUA
  Future<List<Map<String, dynamic>>> getAllJuz() async {
    int juz = 1;

    List<Map<String, dynamic>> penampungAyat = [];

    for (var i = 0; i <= 114; i++) {
      Uri url = Uri.parse("https://api.quran.gading.dev/surah/$i");
      var res = await http.get(url);

      Map<String, dynamic> rawData = json.decode(res.body)['data'];
      DetailSurah data = DetailSurah.fromJson(rawData);

      if (data.verses != null) {
        for (var ayat in data.verses!) {
          if (ayat.meta?.juz == juz) {
            penampungAyat.add(
              {"surah": data, "ayat": ayat},
            );
          } else {
            allJuz.add({
              "juz": juz,
              "start": penampungAyat[0],
              "end": penampungAyat[penampungAyat.length - 1],
              "verses": penampungAyat
            });
            juz++;
            penampungAyat = [];
            penampungAyat.add(
              {"surah": data, "ayat": ayat},
            );
          }
        }
      }
    }

    allJuz.add({
      "juz": juz,
      "start": penampungAyat[0],
      "end": penampungAyat[penampungAyat.length - 1],
      "verses": penampungAyat
    });

    // *OPSI PERTAMA
    // Future<List<Juz>> getAllJuz() async {
    // List<Juz> allJuz = [];
    // for (dynamic i = 1; i <= 30; i++) {
    //   Uri urlJuz = Uri.parse("https://api.quran.gading.dev/juz/$i");
    //   var responseJuz = await http.get(urlJuz);

    //   Map<String, dynamic> data =
    //       (json.decode(responseJuz.body) as Map<dynamic, dynamic>)["data"];

    //   Juz juz = Juz.fromJson(data);
    //   allJuz.add(juz);
    // }

    // return allJuz;
    return allJuz;
  }
}
